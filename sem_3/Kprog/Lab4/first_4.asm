.model small
.stack 100h
.data
    array db 255 dup(0)      
    max_value db 0            
    msg_input db 'Enter the size of the array (1-30): $'
    msg_array_input db 'Enter the array elements: $'
    msg_error db 'Wrong input.$'       
    msg_array db 'Your array: $'
    msg_normalized db 0Dh, 0Ah, 'Normalized array: $'
    msg_div_zero db 'Division by zero is not possible.$'     
    buffer db 3, ?, 3 dup('$')  
    num db 0             
    newline db 0Dh, 0Ah, '$'

.code
main:
    mov ax, @data
    mov ds, ax   
    
input_size:
    lea dx, msg_input
    mov ah, 09h
    int 21h

    mov dx, offset buffer
    mov ah, 0Ah
    int 21h

    mov si, offset buffer + 1 
    mov cx, 0 
    mov cl, [si]              
    xor ax, ax                

convert_loop: 
    inc si 
    mov bl, [si]    
    cmp bl, '0'               
    jb invalid_input_size          
            
    sub bx, '0'              
    mov dx, 10
    mul dx                    
    add ax, bx                
                      
    loop convert_loop         

    cmp ax, 1
    jb invalid_input_size
    cmp ax, 30
    ja invalid_input_size

    mov num, al                

    lea dx, msg_array_input                            
    mov ah, 09h
    int 21h

    lea si, array
    mov bh, cl
    mov cx, 0 
    mov cl, num             

input_loop:                               
    mov ah, 01h               
    int 21h
    cmp al, '0'
    jb invalid_input          
    cmp al, '9'
    ja invalid_input          
    sub al, '0'               
    mov [si], al             
    inc si                    
    loop input_loop           
    jmp find_max             

invalid_input_size:      
    mov dx, offset newline
    mov ah, 09h
    int 21h
    lea dx, msg_error
    mov ah, 09h
    int 21h
    jmp input_size          

invalid_input:      
    mov dx, offset newline
    mov ah, 09h
    int 21h
    lea dx, msg_error
    mov ah, 09h
    int 21h
    jmp input_loop

find_max:  
    mov cl, num
    lea si, array             
    mov al, [si]              
    mov max_value, al         

check_max:
    inc si                    
    mov al, [si]              
    cmp al, max_value         
    jbe skip_max              
    mov max_value, al         

skip_max:
    loop check_max           
  
    cmp max_value, 0
    je division_by_zero 

    lea si, array 
    mov cl, num            
    mov bl, max_value
                   
    mov dx, offset newline
    mov ah, 09h
    int 21h
    lea dx, msg_array
    mov ah, 09h
    int 21h       
    mov cl, num 
                   
output_array:
    mov al, [si]              
    add al, '0'               
    mov dl, al
    mov ah, 02h               
    int 21h
    mov dl, ' '
    mov ah, 02h               
    int 21h
    inc si                    
    loop output_array 
    mov cl, num 

normalize_loop:
    mov al, [si]              
    xor ah, ah                
    cmp al, 0                 
    je skip_normalize 
           
    
    mov bl, max_value
    mov ax, 0
    mov al, [si]              
    mov cx, 10
    mul cx                   

   
    xor dx, dx               
    div bl                    
    mov [si], al 
    mov cl, num            

skip_normalize:
    inc si                    
    loop normalize_loop       

    lea dx, msg_normalized
    mov ah, 09h
    int 21h

    lea si, array             
    mov cl, num           
    
output_loop:
    mov al, [si]              
    
    mov ah, 0                
    mov bl, 10               
    xor dx, dx           
    mov ax, [si]          
    div bl                
    add al, '0'            
    mov dl, al             
    mov ah, 02h              
    int 21h


    
    mov dl, '.'              
    mov ah, 02h              
    int 21h


    mov dx, 0              
    mov ax, [si]          
    div bl                   
    add dl, al           
    mov ah, 02h              
    int 21h

    mov dl, ' '           
    mov ah, 02h              
    int 21h
    inc si                    
    loop output_loop          

    jmp end_program          

division_by_zero: 
    mov dx, offset newline
    mov ah, 09h
    int 21h
    lea dx, msg_div_zero
    mov ah, 09h
    int 21h
    jmp end_program                

end_program:
    mov ax, 4C00h
    int 21h
end main
