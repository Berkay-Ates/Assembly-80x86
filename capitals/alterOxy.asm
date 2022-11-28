stacksg         segment para stack 'stacksg'
                dw 20 dup(?)
stacksg         ends
datasg          segment para 'datasg'
                topRak          dd  0
                ustunde         dw  0
                ustOrt          dw  0
                topBask         dw  16
                capitals        dw  10,-5,2,5,6,7,222,4,6,7,8,8,9,6,55,-60 
                
datasg          ends
codesg          segment para 'codesg'
                assume cs:codesg,ss:stacksg,ds:datasg
ana             proc far
                push ds
                xor ax,ax
                push ax
                mov ax,datasg
                mov ds,ax
                mov cx,topBask
                xor si,si
    buyukdon:   mov ax,capitals[si]
                cmp ax,0000h
                jle don
                add word ptr [topRak],ax
                adc word ptr [topRak+2],0
                inc ustunde
        don:    add si,2
                loop buyukdon  
                mov dx,word ptr [topRak+2]
                mov ax,word ptr [topRak]
                div ustunde
                mov ustOrt,ax
                retf
ana             endp
codesg          ends
end ana



