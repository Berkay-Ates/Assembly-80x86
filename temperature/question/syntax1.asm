codesg      segment para 'codesg'
            org 100h
            assume cs:codesg, ss:codesg, ds:codesg
    data:   jmp  ana
            esik        db  -20
            N           db  365 dup(?)
            sonuc       db  ?
            gunSayisi   dw  365

    ana:    proc near   ;here is our codes 
            mov cx,0
            xor si,si
            mov al,sonuc
    don:    cmp cx,gunSayisi
            jae son
            cmp al,N[si]
            jg son
            inc si
            inc cx
            jmp don
    son:    cmp cx,gunSayisi
            je false
            mov sonuc,1
            jmp bitir
    false:  mov sonuc,0


    bitir:  ret
    ana:    endp
codesg      ends
            end data
