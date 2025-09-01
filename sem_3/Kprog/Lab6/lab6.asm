.model tiny
.code
    ;org 80h                     
    cmd_length db ?             
    cmd_line db ?               
    org 100h                    
    
start:
    cld
    mov bp,sp
    mov cl,es:[80h]
    mov di,offset cmd_line             

next_param:                     
    mov al,' '
    repe scasb
    dec di
    push di
    mov si, di         
    mov di, offset number
scan_param:
    cmp [si],0Dh                
    je param_ended
    cmp [si],20h                
    je param_ended
    movsb
    jmp scan_param
param_ended:
    mov byte ptr [si],0         
    mov si, offset number
string_to_num:
    xor dx,dx   
loop_:    
    xor ax,ax
    lodsb    
    dec cl
    cmp al, ' '
    je get_file_name
    cmp al,'9'  
    jnbe  loop_
    cmp al,'0'       
    jb    catch_error
    sub ax,'0' 
    
    push ax
    mov ax, dx
    mov dx, 10
    mul dx
    mov dx, ax
    pop ax 
    add dx, ax  
    jmp  loop_
    
catch_error:
    mov ah, 09h
    mov dx, offset error_less[256]
    int 21h
    jmp exit
  
get_file_name:
    push dx
    lea dx, filename[256]
    mov di,dx
gfn_loop:
    xor ax,ax
    lodsb
    test al,al
    jz ex
    mov [di], al
    inc di
    jmp gfn_loop
    
ex:     
    pop dx
    mov ax,dx   
    mov number, ax
    
    cmp number, 0
    jle catch_error
    
    cmp number, 256
    jge catch_error
    
    mov     bx, ((program_length/16)+1)+((dsize/16)+1) + 32
    mov     ah, 4Ah   
    int     21h   
    jc catch_run_error
    
    xor cx, cx
    mov cx, number
run:
    mov ax,4B00h                        
    mov dx, offset filename[256]               
    mov bx, offset env                  
    int 21h 
    jc catch_run_error
    loop run
    jmp exit
    
catch_run_error: 
    cmp ax, 02h
    je er_404
    
    lea dx, error[256]
    push ax
    mov ah, 9
    int 21h
    pop ax
    mov dl, ah
    add dl, '0'
    mov ah, 2
    int 21h
    jmp exit
er_404:
    lea dx, error_404[256]
    mov ah, 9
    int 21h
    jmp exit
exit:
    mov ax,4C00h
    int 21h                             

print_str macro out_message
    push ax
    push dx
    mov ah, 09h
    mov dx, offset out_message
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h
    pop dx
    pop ax
endm
program_length = $ - start  

env dw 0
number dw 0
filename db 32 dup(0)
argc db 0
buffer db 0
error_less db "Error: N less than 1 or greater than 255$" 
error_404 db "Error: File not found$"
error db "There's an error. Code: $"
dsize = $ - env

end start