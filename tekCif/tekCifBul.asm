stacksg         segment para stack 'stacksg'
                dw 20 dup(?)
stacksg         ends
datasg          segment para 'datasg'
                dizi        dw  10,21,43,71,199,67,88,234,0,467
                eleman      dw  10
                tek_sayi    db  0
                cift_sayi   db  0

datasg          ends
codesg          segment para 'codesg'
                assume cs:codesg,ss:stacksg,ds:datasg
ana             proc far
                push ds
                xor ax,ax
                push ax
                mov ax,datasg
                mov ds,ax
                lea si,dizi
                xor bx,bx
                mov cx,eleman
        don:    mov ax,[si]
                shr ax,1
                ;test ax,0001h
                adc bx,0
                add si,2
                loop don
                mov ax,eleman
                sub ax,bx ;* al de cift sayilar bl de de tek sayilar var 
                retf
ana             endp
codesg          ends
end ana