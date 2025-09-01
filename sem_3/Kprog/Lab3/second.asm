org 100h

jmp start

print_str macro out_str
    mov ah, 9
    mov dx, offset out_str
    int 21h
endm    

input_str macro in_str
    mov ah, 0Ah
    mov dx, offset in_str
    int 21h
    mov bx, 0
    mov bl, in_str[1]
    mov in_str[bx + 2], '$' 
endm   

search_word:    
    mov si, offset word_buffer[2] 
    mov di, offset buffer[2]             
    mov cx, 0
    mov cl, buffer[1]              
    mov dx, 0
    mov dl, word_buffer[1]        

next_char:
    cmp cl, 0                      
    je not_found                 
    push cx                       
    mov cx, dx                    
    mov bx, 0                     

compare:
    cmp cx, 0                      
    je found                       
    mov al, [di + bx]             
    mov ah, [si + bx]             
    cmp al, ah                    
    jne next_char_1               
    inc bx                         
    dec cx                        
    jmp compare                   

next_char_1:
    pop cx                         
    inc di                       
    dec cl                      
    jmp next_char                  

found: 
    mov ah, 2          
    mov dl, 0Dh        
    int 21h
    mov dl, 0Ah     
    int 21h 
    print_str found_msg              
    jmp replace_between_spaces                              
                             
not_found: 
    mov ah, 2          
    mov dl, 0Dh        
    int 21h
    mov dl, 0Ah     
    int 21h 
    print_str not_found_msg 
    jmp end         

replace_between_spaces:   
    mov cl, buffer[1]       
    mov ax, 2       ; spaces count
replace_loop:  
    dec cl
    cmp cl, 0
    je replace_end   
    dec di    
    cmp ax, 0
    je replace_end   
    cmp [di], ' '
    jne continue_replace
    dec ax
    jmp replace_loop
continue_replace:
    mov [di], ' '
    jmp replace_loop    
    
replace_end:    
    jmp search_word_return

main proc
    print_str start_msg      
    
    print_str input_str_msg  
    input_str buffer 

    mov ah, 2          
    mov dl, 0Dh        
    int 21h
    mov dl, 0Ah       
    int 21h 

    print_str buffer[2]   

    mov ah, 2          
    mov dl, 0Dh        
    int 21h
    mov dl, 0Ah     
    int 21h 
    
    print_str input_word_msg
    input_str word_buffer  

    mov ah, 2          
    mov dl, 0Dh        
    int 21h
    mov dl, 0Ah     
    int 21h 

    print_str word_buffer[2] 

    jmp search_word
search_word_return:
                 
                
    mov ah, 2          
    mov dl, 0Dh        
    int 21h
    mov dl, 0Ah     
    int 21h  
    print_str final_msg   
    mov ah, 2          
    mov dl, 0Dh        
    int 21h
    mov dl, 0Ah     
    int 21h 
    print_str buffer[2] 
    

    jmp end

main endp         
            
start:
    call main
    jmp end      
    
end:
     
    int 20h

buffer db 200, 0, 200 dup('$') 
word_buffer db 200, 0, 200 dup('$')     
start_msg db 'Program started...$'
input_str_msg db 'Please enter a string:$'
input_word_msg db 'Please enter a word:$'
final_msg db 'Final string with word removed: $'
not_found_msg db 'Not found.$'
found_msg db 'Found!$'
