mystack         SEGMENT PARA STACK 'stacksg'
                DW 256 dup(0)
mystack         ENDS 
mydata          SEGMENT PARA 'datasg'
                deger DW 10
                sonuc DW 0ffffh
mydata          ENDS
codesgA         SEGMENT PARA 'codesgA'
                ASSUME CS:codesgA, SS:mystack, DS:mydata
Main            PROC FAR 
                PUSH DS
                XOR AX,AX 
                PUSH AX
                MOV AX,mydata
                MOV DS,AX

                MOV CX,deger              ;* deger 10'a esit 
                PUSH CX
                CALL FAR PTR DNUM         ;* donus degeri stack icerisinde olacak 
                CALL FAR PTR PRINTINT
                POP CX                    ;* donus degerini CX'e aldık
                MOV sonuc,CX

                RETF
Main            ENDP

DNUM            PROC FAR
                PUSH BP 
                PUSH AX
                PUSH DX
                PUSH BX
            
                MOV BP,SP
                MOV AX,[BP+12]            ;* ax icerisinde degerini bulmak istedigimiz dizi elemanı var 
                MOV DX,[BP+12]

                CMP AX,2
                JA L2                     ;* DNUM TEKRAR CAGRILACAK
                CMP AX,0
                JE L3
                MOV AX,1
     L3:        MOV [BP+12],AX
                JMP cik

     L2:        SUB AX,1 
                PUSH AX
                CALL FAR PTR DNUM         ;* D(N-1) degeri hesaplandı
                CALL FAR PTR DNUM         ;* D(D(n-1)) degeri hesaplandı
                POP BX                    ;* D(D(n-1)) BX icerisinde  
                SUB AX,1
                PUSH AX
                CALL FAR PTR DNUM
                POP AX                    ;* D(n-2) AX icerisinde
                SUB DX,1
                SUB DX,AX
                PUSH DX
                CALL FAR PTR DNUM
                POP DX                    ;* D(n-1-D(n-2)) DX icerisinde 
                ADD DX,BX                 ;* sonuc DX icerisinde
                MOV [BP+12],DX            ;* parametrenin geldigi yer uzerine yani stackte ilgili yere sonucu yazdık
            
    cik:        POP BX
                POP DX
                POP AX
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
                ADD DX,48     ;* ascıı table da uyumlu karaktere denk gelmek icin 48 eklıyoruz
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