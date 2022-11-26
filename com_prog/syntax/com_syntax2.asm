codesg      segment para 'codesg'
            org 100h
            assume cs:codesg, ss:codesg, ds:codesg

    ana:    proc near 
             
    ana:    endp 
    
    sayib   db ?
    sayia   db ?


codesg      endsg
            end ana
