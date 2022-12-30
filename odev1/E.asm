mystack         SEGMENT PARA STACK 'stacksg'
                DW 256 dup(0)
mystack         ENDS 
mydata          SEGMENT PARA 'datasg'
                deger DW 500
                sonuc DW 0ffffh
                hafiza DB 500 dup(0)
mydata          ENDS
codesgA         SEGMENT PARA 'codesgA'
                ASSUME CS:codesgA, SS:mystack, DS:mydata
Main            PROC FAR 

                PUSH DS
                XOR AX,AX 
                PUSH AX
                MOV AX,mydata
                MOV DS,AX

                MOV CX,deger
                LEA SI,hafiza
                XOR BX,BX

     next:      PUSH BX
                PUSH SI
                CALL FAR PTR DNUM
                POP DI
                POP AX
                MOV sonuc,AX
                INC BX
                LOOP next  
                MOV AX,sonuc
                PUSH AX
                CALL FAR PTR PRINTINT
                POP CX  

                RETF
Main            ENDP

DNUM            PROC FAR
                PUSH BP
                PUSH DI
                PUSH AX
                PUSH BX
                PUSH CX
                PUSH DX
                PUSH SI

                MOV BP,SP
                MOV DI,[BP+18]          ;* dizinin baslangic adresini cekelim  
                MOV AX,[BP+20]
                XOR CX,CX

                CMP AX,2
                JA L2D                  ;* DNUM TEKRAR CAGRILACAK
                CMP AX,0
                JE L3D
                MOV AX,1 
        L3D:    MOV [BP+20],AX
                ADD DI,AX
                MOV [DI],AX
                JMP cikD


        L2D:    SUB AX,1
                ADD DI,AX
                CMP BYTE PTR [DI],0
                JA L4D                  ;*D(N-1) degeri coktan hesaplanmıs tekrar hesaplamayacagız
                PUSH AX
                PUSH [BP+18]
                CALL FAR PTR DNUM
                POP SI                  ; * STACK UZERINDEN gelen fazladan degeri yani dizi adresini bosa cekelim
                POP BX                  ;* Stack temizlendi yeni deger BX de
                MOV BYTE PTR [DI],BL    ;*D(N-1) degeri hesaplandı ve artık hafızada 
        L4D:    XOR AX, AX
                MOV AL,BYTE PTR [DI]    ;* yeni deger AX icerisinde D(D(N-1)) hesaplanacak D(AX) 
                MOV DI,[BP+18]          ;* DI degismisti simdi tekrar en basa geldi
                ADD DI,AX               ;* hesaplanacak degere denk gelen hafıza noktasına bakalım
                CMP BYTE PTR [DI],0
                JA L5D                  ;* D(D(N-1) = AX) coktan hesaplanmıs
                PUSH AX
                PUSH [BP+18]
                CALL FAR PTR DNUM
                POP SI
                POP BX
                MOV BYTE PTR [DI],BL    ;* D(D(N-1) = AX) hesaplandı ve artık hafızada
        L5D:    MOV CL,BYTE PTR [DI]    ;? D(D(N-1) = AX) degeri CL icerisinde Stack Tertemiz ilk geldigi gibi duruyor
                MOV AX,[BP+20]          ;* AX degeri kaybolmustu tekrar set oldu 
                MOV DI,[BP+18]          ;* DI hafızanın en basına geldi
                SUB AX,2
                ADD DI,AX
                CMP BYTE PTR [DI],0 
                JA L6D                  ;* D(n-2) degeri bizim icin coktan hesaplanmıs demektir
                PUSH AX
                PUSH [BP+18]
                CALL FAR PTR DNUM
                POP SI
                POP BX
                MOV BYTE PTR [DI],BL    ;* D(n-2) degeri hesaplandı ve artık hafızaya kaydedildi
        L6D:    XOR AX,AX
                MOV AL,BYTE PTR [DI]    ;* D(n-2) degeri AX icerisinde 
                MOV DX,[BP+20]
                SUB DX,1
                SUB DX,AX               ;* DX icerisinde n-1-D(n-2) var 
                MOV DI,[BP+18]
                ADD DI,DX               ;* Hafızada hesaplamak istedigimiz elemana denk gelen noktada deger olup olmadıgını kontrol edelim
                CMP BYTE PTR [DI],0
                JA L7D                  ;* D(n-1-D(n-2)) degeri coktan hesaplanmıs ve bizim icin hafizada 
                PUSH DX
                PUSH [BP+18]
                CALL FAR PTR DNUM
                POP SI
                POP DX                  ;* D(n-1-D(n-2)) artık DX icerisinde Sonuc Eminiz ki 255 den kucuk ve DL icerisinde
                MOV BYTE PTR [DI],DL    ;*D(n-1-D(n-2)) degeri hesaplandı ve artık hafızada
        L7D:    XOR DX,DX               ;* Dx icerisine byte koyacagımız icin DH'ın sıfır olmasını saglayalım
                MOV DL,BYTE PTR [DI]    ;* D(n-1-D(n-2)) artık DX icerisinde, onceden hesaplanan D(D(N-1)) degeri CL icerisindeydi
                ADD DX,CX               ;! EN Son Sonuc DX icerisinde HATTA DX'ın DL kısmında 
                MOV DI,[BP+18]          ;* DI Basa geldi
                MOV AX,[BP+20]
                ADD DI, AX 
                MOV BYTE PTR [DI],DL    ;* hesapladıgımız sonucu hafızaya yazdık
                MOV [BP+20],DX          ;* DNUM'e stack Uzerinden gelen veriyi tekrar geldigi yere yazarak stack uzerinden yolladık

       cikD:    POP SI
                POP DX
                POP CX
                POP BX
                POP AX
                POP DI
                POP BP
                RETF 
DNUM            ENDP


PRINTINT        PROC FAR
                PUSH CX
                PUSH BP
                PUSH DX
                PUSH AX
                PUSH BX

                MOV BP,SP
                MOV AX,[BP+14]
                MOV CX,10
                XOR BX,BX

    bol:        XOR DX,DX
                CMP AX,0
                JNA modSon
                DIV CX
                PUSH DX
                INC BX
                JMP bol

 modSon:        MOV CX,BX

   YAZ1:        MOV AH,2
                POP DX
                ADD DX,48       ;* ascıı table da uyumlu karaktere denk gelmek icin 48 eklıyoruz
                INT 21h
                LOOP YAZ1

                POP BX
                POP AX
                POP DX
                POP BP
                POP CX
                RETF
PRINTINT        ENDP

codesgA         ENDS
                END Main