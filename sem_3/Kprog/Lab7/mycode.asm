; Example of program on emu8086 for filling memory cells
ORG 100h          

DATA SEGMENT
    memArray DB 10 DUP(0)  
DATA ENDS

CODE SEGMENT
START:
    MOV CX, 10           
    LEA DI, memArray     

fill_loop:
    MOV AL, CL          
    MOV [DI], AL        
    INC DI              
    LOOP fill_loop      
    MOV CX, 10           
    LEA DI, memArray     

print_loop:
    MOV AL, [DI]         
    CALL PrintNum        
    INC DI              
    LOOP print_loop     
    MOV AH, 4Ch
    INT 21h

PrintNum PROC
   
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BL, 10           
    XOR CX, CX         

next_digit:
    XOR DX, DX           
    DIV BL             
    PUSH DX             
    INC CX             
    TEST AX, AX        
    JNZ next_digit      

print_digits:
    POP DX             
    ADD DL, '0'          
    MOV AH, 02h        
    INT 21h              
    LOOP print_digits    

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintNum ENDP

CODE ENDS
END START     

; Emu8086 program to perform AND operation between 2 and 5 bits

ORG 100h          

DATA SEGMENT
    number DB 0b00000000  
DATA ENDS

CODE SEGMENT
START:
    
    MOV AL, [number]     
    MOV BL, AL            
    SHR BL, 1             
    AND BL, 1            
    MOV CL, AL          
    SHR CL, 4             
    AND CL, 1           
    AND BL, CL           
    MOV AL, [number]      
    AND AL, 0b11011111   
    SHL BL, 5            
    OR AL, BL        
    MOV [number], AL      
    MOV AH, 4Ch
    INT 21h
CODE ENDS
END START  

; Program on emu8086 for working with 3x3 matrix

ORG 100h        

DATA SEGMENT
    matrix DB 9 DUP(0)
DATA ENDS

CODE SEGMENT
START:
    
    MOV BYTE PTR [matrix], 5
    MOV BYTE PTR [matrix + 1], 2
    MOV BYTE PTR [matrix + 2], 8
    MOV BYTE PTR [matrix + 3], 3
    MOV BYTE PTR [matrix + 4], 9
    MOV BYTE PTR [matrix + 5], 1
    MOV BYTE PTR [matrix + 6], 6
    MOV BYTE PTR [matrix + 7], 4
    MOV BYTE PTR [matrix + 8], 7

    MOV CX, 9         
    LEA SI, matrix       
    MOV AL, [SI]      
    MOV BL, AL           
    MOV DI, SI         

find_min_max:
    INC SI               
    DEC CX               
    JZ found             
    MOV AL, [SI]         
    CMP AL, BL           
    JG new_max           
    CMP AL, [DI]         
    JL new_min           
    JMP find_min_max     

new_max:
    MOV BL, AL           
    MOV DI, SI           
    JMP find_min_max

new_min:
    MOV [DI], AL         
    MOV DI, SI           
    JMP find_min_max

found:
    MOV AL, [matrix + DI - matrix]  
    MOV AH, BL           
    MOV [DI], AH        
    MOV [matrix + DI - matrix], AL  
    MOV AH, 4Ch
    INT 21h
CODE ENDS
END START  

;Emu8086 program for counting odd negative numbers

ORG 100h          

DATA SEGMENT
    numbers DB -3, -2, -5, 4, -1, 2, -7, 8, -9, 10 
    count DB 0      
DATA ENDS

CODE SEGMENT
START:
    MOV SI, 0        
    MOV CX, 10       
    MOV AL, 0        

count_loop:
    MOV BL, [numbers + SI] 
    CMP BL, 0              
    JGE next               
    AND BL, 1              
    JZ next                
    INC AL                 

next:
    INC SI                 
    LOOP count_loop        
    MOV [count], AL      
    MOV AH, 4Ch
    INT 21h
CODE ENDS
END START