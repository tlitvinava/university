 ldx #$ffff
 ldy #$ffff
 stx $8000
 sty $8002

 ldaa $8001
 ldab $8003
 aba
 staa $8001

 ldaa $8000
 ldab $8002

 adcb $8000
 stab $8000
 
 ldaa $8002
 ldab $8001

 ldaa #0
 adca #0
 staa $8000



 






 
