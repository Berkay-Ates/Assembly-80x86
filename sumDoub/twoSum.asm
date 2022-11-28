stacksg         segment para stack 'stacksg'
                dw 16 dup(?)
stacksg         ends

datasg          segment para 'datasg'
                aSayisi     dw  1234h
                bsayisi     dw  0ffcdh
                toplam      dd  0
datasg          ends

codesg          segment para 'codesg'
                assume cs:codesg,ss:stacksg,ds:datasg
ana             proc far
                push ds
                xor ax,ax
                push ax
                mov ax,datasg
                mov ds,ax
                mov ax,aSayisi
                mov bx,bsayisi
                add ax,bx
                mov word ptr [toplam],ax
                adc word ptr [toplam +2],0
                retf
ana             endp
codesg          ends
                end ana