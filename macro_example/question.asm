codesg      segment para 'mycodesg'
            assume cs:codesg,ss:codesg,ds:codesg
carp        macro
            ;* herhangi bir etikat falan kullanacak olursak bu etiketleri local L1 seklinde bir tanımla tanımlamamız gerekir
            mul bl ;* ax*bl -> sonuc ax uzerinde olustu
            endm

ana         proc near
            mov bl,aSayisi
            mov al,bSayisi
            carp
            mov cSayisi,ax
            ret
ana         endp

aSayisi     db  20
bSayisi     db  20
cSayisi     dw  0 
codesg      ends
            end ana




;* com tipi syntax 2 ile yazalım yani ds codesg den sonra gelecek sekilde 