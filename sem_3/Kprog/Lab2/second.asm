 org $8000
 ldx #$8200
 ldy #$821f
 sty $8220
 ldaa #%00010001
 staa $8221
 
metka 
 ldaa $8221
 anda 0,x
 cmpa $8221
 beq and_1
 bclr 0,x,#%00000010
 jmp continue

and_1
 bset 0,x,#%00000010
 jmp continue

continue
 inx
 cpx $8220
 ble metka




       


