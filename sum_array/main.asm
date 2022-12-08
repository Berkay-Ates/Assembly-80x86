extrn summArr:far
mystack     segment para stack 'stacksg'
            dw 20   dup(?)
mystack     ends
mydata      segment para 'datasg'
            arr     db  10,20,30,40,50,60,70,80,90
            count   dw  9
            sum     dw  0
mydata      ends
mycode      segment para 'codesg'
            assume cs:mycode ,ds:mydata,ss:mystack
            
ana         proc far
            push ds
            xor ax,ax
            push ax
            mov ax,mydata
            mov ds,ax
            xor ax,ax
            lea si, arr
            mov cx, count
            call summArr ;*result exists on the ax registers 
            mov sum, ax


            retf
ana         endp
mycode      ends
            end ana                                                                     
