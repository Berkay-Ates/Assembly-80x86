public  summArr
codesg  segment para 'codesg'   
        assume cs:codesg
        ;*sı uzerinde dizinin baslangıc adresi var 
        ;*cx uzerinde de dizinin eleman sayısı var 
        ;? ikisini de stack e atıp sonrasında pop yaparak geri set ettirelim
summArr proc far
        push si
        push cx 
don:    add al,byte ptr [si]
        adc ah,0
        inc si
        loop don

        pop cx
        pop si

        retf
summArr endp
codesg  ends
        end