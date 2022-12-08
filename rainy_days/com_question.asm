codesg      segment para 'mycode'
            org 100h
            assume cs:codesg,ss:codesg,ds:codesg
ana         proc near

            mov cx,gun
            lea si,N
            mov al,top
            mov ah,enBuy
            call calcY ;* al uzerinde bize toplam sonuc, ah uzerinden de en buyuk sayi donmus olacak 
            mov enBuy,ah
            mov top,al
            xor ah,ah
            mov dx,0
            div gun;*sonuc al icerisinde olustu 
            mov ort,al 
            ;*sonlandı

            ret
ana         endp

calcY       proc near
            push cx
            push si

 disdon:    add al,[si]
            cmp ah,[si]
            ja  don
            mov ah,[si]
    don:    inc si
            loop disdon

            pop si
            pop cx

            ret
calcY       endp

            gun     dw  15
            ort     db  0
            top     db  0
            enBuy   db  0
            N       db  1,3,4,6,7,8,2,4,5,6,3,6,8,4,9

codesg      ends
            end ana