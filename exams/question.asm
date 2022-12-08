stacksg         segment para stack 'stacksg'
                dw 20 dup(?)
stacksg         ends
datasg          segment para 'datasg'
                n           dw  280
                esik        db  40
                esikustu    dw  0
                topNot      dw  0
                kalan       dw  0
                but         dw  0
                basarili    dw  0
                notlar      db  280 dup(45)

datasg          ends
codesg          segment para 'codesg'
                assume cs:codesg,ss:stacksg,ds:datasg
ana             proc    far
                push    ds
                xor     ax,ax
                push    ax
                mov     ax,datasg
                mov     ds,ax
                xor     si,si
                mov     cx,n
      disdon:   mov     al,N[si]
                cmp     al,esik
                ja      gecti
                inc     kalan
                jmp     icdon
    gecti:      add     byte ptr [topNot],al
                adc     byte ptr [topNot+1],0
    icdon:      inc     si
                loop    disdon
                mov     cx,n
                sub     cx,kalan
                mov     esikustu,cx
                xor     dx,dx
                mov     ax,topNot
                div     cx ;*sonuc AX, -> al icerisinde olusur
                ;* cx icerisinde zaten basarili ogrencilerin sayisi var 
                xor     si,si
                mov     cx,n
                mov     ah,notlar[si]
                cmp     al,ah
                ja      missionDone
                cmp     ah,esik
                jb      missionDone
                inc     but
missionDone:    inc     basarili
                inc     si         
                retf
ana             endp
codesg          ends
end ana



