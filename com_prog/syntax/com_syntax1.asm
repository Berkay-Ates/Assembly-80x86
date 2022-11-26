codesg      segment para 'codesg'
            org 100h
            assume cs:codesg, ss:codesg, ds:codesg

    data:   jmp basla
            sayib   db ?
            sayic   db ?
            


    basla:  proc near 
            ; our codes 
            ; our codes 
            ; our long codes 
            
            ret 
    basla:  endp 
codesg      endsg
            end data
