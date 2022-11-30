codesg      segment para 'codesg'
            org 100h
            assume cs:codesg, ss:codesg, ds:codesg
    ana     proc near   ;here is our codes 

            mov cx,gunSayisi
            xor si,si
    don:    mov al,N[si]
            cmp si,cx
            jae L1;*demekki bulamadı
            cmp al,N[si]
            jg  L2;*-20 den daha soguk gun bulduk
            inc si
            jmp don

    L1:     mov sonuc,0
            jmp son
    L2:     mov sonuc,1
    
    son:    ret
    ana    endp

            esik        db  -20
            N           db  365 dup(?)
            sonuc       db  ?
            gunSayisi   dw  365

codesg      ends
            end ana
