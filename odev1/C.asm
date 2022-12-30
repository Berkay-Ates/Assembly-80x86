                PUBLIC DNUM,PRINTINT,DNUMDYN
codesgB         SEGMENT PARA 'codesgB'
                ASSUME CS:codesgB
DNUM            PROC FAR
                PUSH BP 
                PUSH AX
                PUSH DX
                PUSH BX
            
                MOV BP,SP
                MOV AX,[BP+12];* ax icerisinde degerini bulmak istedigimiz dizi elemanı var 
                MOV DX,[BP+12]

                CMP AX,2
                JA L2 ;* DNUM TEKRAR CAGRILACAK
                CMP AX,0
                JE L3
                MOV AX,1
     L3:        MOV [BP+12],AX
                JMP cik

     L2:        SUB AX,1 
                PUSH AX
                CALL DNUM ;* D(N-1) degeri hesaplandı
                CALL DNUM ;* D(D(n-1)) degeri hesaplandı
                POP BX ;* D(D(n-1)) BX icerisinde  
                SUB AX,1
                PUSH AX
                CALL DNUM
                POP AX ;* D(n-2) AX icerisinde
                SUB DX,1
                SUB DX,AX
                PUSH DX
                CALL DNUM
                POP DX ;* D(n-1-D(n-2)) DX icerisinde 
                ADD DX,BX ;* sonuc DX icerisinde
                MOV [BP+12],DX ;* parametrenin geldigi yer uzerine yani stackte ilgili yere sonucu yazdık
            
    cik:        POP BX
                POP DX
                POP AX
                POP BP
                RETF 
DNUM            ENDP


DNUMDYN         PROC FAR
                PUSH BP
                PUSH DI
                PUSH AX
                PUSH BX
                PUSH CX
                PUSH DX
                PUSH SI

                MOV BP,SP
                MOV DI,[BP+18] ;* dizinin baslangic adresini cekelim  
                MOV AX,[BP+20]
                XOR CX,CX

                CMP AX,2
                JA L2D ;* DNUM TEKRAR CAGRILACAK
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
                JA L4D ;*D(N-1) degeri coktan hesaplanmıs tekrar hesaplamayacagız
                PUSH AX
                PUSH [BP+18]
                CALL DNUMDYN
                POP SI ; * STACK UZERINDEN gelen fazladan degeri yani dizi adresini bosa cekelim
                POP BX ;* Stack temizlendi yeni deger BX de
                MOV BYTE PTR [DI],BL ;*D(N-1) degeri hesaplandı ve artık hafızada 
        L4D:    XOR AX, AX
                MOV AL,BYTE PTR [DI] ;* yeni deger AX icerisinde D(D(N-1)) hesaplanacak D(AX) 
                ;CBW ;! MAALESEF BASTAKI 1 DEN Dolayı Calısmıyor
                MOV DI,[BP+18] ;* DI degismisti simdi tekrar en basa geldi
                ADD DI,AX ;* hesaplanacak degere denk gelen hafıza noktasına bakalım
                CMP BYTE PTR [DI],0
                JA L5D ;* D(D(N-1) = AX) coktan hesaplanmıs
                PUSH AX
                PUSH [BP+18]
                CALL DNUMDYN
                POP SI
                POP BX
                MOV BYTE PTR [DI],BL ;* D(D(N-1) = AX) hesaplandı ve artık hafızada
        L5D:    MOV CL,BYTE PTR [DI] ;? D(D(N-1) = AX) degeri CL icerisinde Stack Tertemiz ilk geldigi gibi duruyor
                MOV AX,[BP+20] ;* AX degeri kaybolmustu tekrar set oldu 
                MOV DI,[BP+18] ;* DI hafızanın en basına geldi
                SUB AX,2
                ADD DI,AX
                CMP BYTE PTR [DI],0 
                JA L6D ;* D(n-2) degeri bizim icin coktan hesaplanmıs demektir
                PUSH AX
                PUSH [BP+18]
                CALL DNUMDYN
                POP SI
                POP BX
                MOV BYTE PTR [DI],BL ;* D(n-2) degeri hesaplandı ve artık hafızaya kaydedildi
        L6D:    XOR AX,AX
                MOV AL,BYTE PTR [DI] ;* D(n-2) degeri AX icerisinde 
                ;CBW  ;! MAALESEF BASTAKI 1 DEN Dolayı Calısmıyor
                MOV DX,[BP+20]
                SUB DX,1
                SUB DX,AX ;* DX icerisinde n-1-D(n-2) var 
                MOV DI,[BP+18]
                ADD DI,DX ;* Hafızada hesaplamak istedigimiz elemana denk gelen noktada deger olup olmadıgını kontrol edelim
                CMP BYTE PTR [DI],0
                JA L7D ;* D(n-1-D(n-2)) degeri coktan hesaplanmıs ve bizim icin hafizada 
                PUSH DX
                PUSH [BP+18]
                CALL DNUMDYN
                POP SI
                POP DX ;* D(n-1-D(n-2)) artık DX icerisinde Sonuc Eminiz ki 255 den kucuk ve DL icerisinde
                MOV BYTE PTR [DI],DL ;*D(n-1-D(n-2)) degeri hesaplandı ve artık hafızada
        L7D:    XOR DX,DX ;* Dx icerisine byte koyacagımız icin DH'ın sıfır olmasını saglayalım
                MOV DL,BYTE PTR [DI] ;* D(n-1-D(n-2)) artık DX icerisinde, onceden hesaplanan D(D(N-1)) degeri CL icerisindeydi
                ADD DX,CX ;! EN Son Sonuc DX icerisinde HATTA DX'ın DL kısmında 
                MOV DI,[BP+18] ;* DI Basa geldi
                MOV AX,[BP+20]
                ADD DI, AX 
                MOV BYTE PTR [DI],DL ;* hesapladıgımız sonucu hafızaya yazdık
                MOV [BP+20],DX ;* DNUMDYN'e stack Uzerinden gelen veriyi tekrar geldigi yere yazarak stack uzerinden yolladık

       cikD:    POP SI
                POP DX
                POP CX
                POP BX
                POP AX
                POP DI
                POP BP
                RETF 
DNUMDYN         ENDP


PRINTINT        PROC FAR
                PUSH CX
                PUSH BP
                PUSH DX
                PUSH AX
                PUSH BX

                MOV BP,SP
                MOV AX,[BP+14]
                MOV CX,10

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
                ADD DX,48
                INT 21h
                LOOP YAZ1

                POP BX
                POP AX
                POP DX
                POP BP
                POP CX
                RETF
PRINTINT        ENDP

codesgB         ENDS
                END