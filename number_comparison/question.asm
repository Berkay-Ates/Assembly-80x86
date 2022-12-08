mycs                segment para 'code'
                    org 100h
                    assume ss:mycs ,cs:mycs, ds:mycs
data:               jmp ana
                    sayi1   db  100
                    sayi2   db  200
                    enBuyuk db  0

ana                 proc near
                    mov     ah,sayi1
                    mov     al,sayi2
                    call    compareNumbers
                    mov     enBuyuk,bl
                    ret
ana                 endp


compareNumbers      proc near
                    ;* ah ve al icerisindeki sayiları kıyaslayip buyugunu bl icerisine atacagiz 
                    cmp ah,al
                    ja ahbuyuk
                    mov bl,al
                    jmp cik 
        ahbuyuk:    mov bl,ah
            cik:    ret
compareNumbers      endp


mycs        ends
            end     data