;sort
ORG 100h

ARRAY DB 5, 3, 8, 6, 2, 7, 1, 4, 9, 0
LENGTH EQU 10

START:
    MOV SI, 0

OUTER_LOOP:
    MOV CX, LENGTH - 1    
    XOR DI, DI         

INNER_LOOP:
    MOV AL, [ARRAY + SI]
    MOV BL, [ARRAY + SI + 1]
    CMP AL, BL
    JBE NO_SWAP
    MOV [ARRAY + SI], BL
    MOV [ARRAY + SI + 1], AL
    INC DI               

NO_SWAP:
    INC SI                
    LOOP INNER_LOOP       
    CMP DI, 0
    JNE OUTER_LOOP       
    MOV AX, 4C00h
    INT 21h        
    
;animation   
ORG 100h
CHARACTERS DB 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'
LENGTH EQU 10

START:
    
    MOV SI, 0

MAIN_LOOP:
   
    MOV AH, 0Eh         
    MOV AL, ' '          
    INT 10h             
    MOV AL, CHARACTERS[SI]
    INT 10h             

    CALL DELAY

    INC SI
    CMP SI, LENGTH
    JAE RESET

    JMP MAIN_LOOP

RESET:
    XOR SI, SI
    JMP MAIN_LOOP


DELAY:
    MOV CX, 0FFFFh
DELAY_LOOP:
    LOOP DELAY_LOOP
    RET

MOV AX, 4C00h
INT 21h