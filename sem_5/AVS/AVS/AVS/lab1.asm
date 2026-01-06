.386P
.MODEL  LARGE
S_DESC  struc
    LIMIT       dw 0
    BASE_L      dw 0
    BASE_M      db 0
    ACCESS      db 0
    ATTRIBS     db 0
    BASE_H      db 0
S_DESC  ends        
I_DESC  struc
    OFFS_L      dw 0
    SEL         dw 0
    PARAM_CNT   db 0
    ACCESS      db 0
    OFFS_H      dw 0
I_DESC  ends        
R_IDTR  struc
    LIMIT       dw 0
    IDT_L       dw 0
    IDT_H       dw 0
R_IDTR  ends
ACS_PRESENT     EQU 10000000B
ACS_CSEG        EQU 00011000B
ACS_DSEG        EQU 00010000B
ACS_READ        EQU 00000010B
ACS_WRITE       EQU 00000010B
ACS_CODE        =   ACS_PRESENT or ACS_CSEG
ACS_DATA =  ACS_PRESENT or ACS_DSEG or ACS_WRITE
ACS_STACK=  ACS_PRESENT or ACS_DSEG or ACS_WRITE
ACS_INT_GATE    EQU 00001110B
ACS_TRAP_GATE   EQU 00001111B
ACS_IDT         EQU ACS_DATA
ACS_INT         EQU ACS_PRESENT or ACS_INT_GATE
ACS_TRAP        EQU ACS_PRESENT or ACS_TRAP_GATE
ACS_DPL_3       EQU 01100000B
CODE_RM segment para use16
CODE_RM_BEGIN   = $
    assume cs:CODE_RM,DS:DATA,ES:DATA
START:
    mov ax,DATA
    mov ds,ax                                   
    mov es,ax                          
    lea dx,MSG_EXIT
    mov ah,9h
    int 21h
    lea dx,MSG_HELLO
    mov ah,9h
    int 21h
ANSWER:
    mov ah, 8h
    int 21h
    cmp al, 'y'
    je ENABLE_A20
    cmp al, 'n'
    je END_PROG
    jmp ANSWER
ENABLE_A20:
    in  al,92h                                                                              
    or  al,2                                    
    out 92h,al                                                                                                                     
SAVE_MASK:
    in      al,21h
    mov     INT_MASK_M,al                  
    in      al,0A1h
    mov     INT_MASK_S,al                 
DISABLE_INTERRUPTS:
    cli                                         
    in  al,70h  
    or  al,10000000b                            
    out 70h,al
    nop 
LOAD_GDT:
    mov ax,DATA
    mov dl,ah
    xor dh,dh
    shl ax,4
    shr dx,4
    mov si,ax
    mov di,dx
WRITE_GDT:
    lea bx,GDT_GDT
    mov ax,si
    mov dx,di
    add ax,offset GDT
    adc dx,0
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_CODE_RM:
    lea bx,GDT_CODE_RM
    mov ax,cs
    xor dh,dh
    mov dl,ah
    shl ax,4
    shr dx,4
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_DATA:
    lea bx,GDT_DATA
    mov ax,si
    mov dx,di
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_STACK:
    lea bx, GDT_STACK
    mov ax,ss
    xor dh,dh
    mov dl,ah
    shl ax,4
    shr dx,4
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh
WRITE_CODE_PM:
    lea bx,GDT_CODE_PM
    mov ax,CODE_PM
    xor dh,dh
    mov dl,ah
    shl ax,4
    shr dx,4
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh        
    or  [bx][S_DESC.ATTRIBS],40h
WRITE_IDT:
    lea bx,GDT_IDT
    mov ax,si
    mov dx,di
    add ax,OFFSET IDT
    adc dx,0
    mov [bx][S_DESC.BASE_L],ax
    mov [bx][S_DESC.BASE_M],dl
    mov [bx][S_DESC.BASE_H],dh        
    mov IDTR.IDT_L,ax
    mov IDTR.IDT_H,dx
FILL_IDT:
    irpc    N, 0123456789ABCDEF
        lea eax, EXC_0&N
        mov IDT_0&N.OFFS_L,ax
        shr eax, 16
        mov IDT_0&N.OFFS_H,ax
    endm
    irpc    N, 0123456789ABCDEF
        lea eax, EXC_1&N
        mov IDT_1&N.OFFS_L,ax
        shr eax, 16
        mov IDT_1&N.OFFS_H,ax
    endm
    lea eax, KEYBOARD_HANDLER
    mov IDT_KEYBOARD.OFFS_L,ax
    shr eax, 16
    mov IDT_KEYBOARD.OFFS_H,ax
    irpc    N, 0234567
        lea eax,DUMMY_IRQ_MASTER
        mov IDT_2&N.OFFS_L, AX
        shr eax,16
        mov IDT_2&N.OFFS_H, AX
    endm
    irpc    N, 89ABCDEF
        lea eax,DUMMY_IRQ_SLAVE
        mov IDT_2&N.OFFS_L,ax
        shr eax,16
        mov IDT_2&N.OFFS_H,ax
    endm
    lgdt fword ptr GDT_GDT
    lidt fword ptr IDTR
    mov eax,cr0
    or  al,00000001b
    mov cr0,eax
OVERLOAD_CS:
    db  0EAH
    dw  $+4
    dw  CODE_RM_DESC        
OVERLOAD_SEGMENT_REGISTERS:
    mov ax,DATA_DESC
    mov ds,ax                         
    mov es,ax                         
    mov ax,STACK_DESC
    mov ss,ax                         
    xor ax,ax
    mov fs,ax
    mov gs,ax
    lldt ax
PREPARE_TO_RETURN:
    push cs
    push offset BACK_TO_RM
    lea  edi,ENTER_PM
    mov  eax,CODE_PM_DESC
    push eax
    push edi                                    
REINITIALIAZE_CONTROLLER_FOR_PM:
    mov al,00010001b
    out 20h,al
    out 0A0h,al
    mov al,20h
    out 21h,al
    mov al,28h
    out 0A1h,al
    mov al,04h
    out 21h,al       
    mov al,02h
    out 0A1h,al      
    mov al,11h
    out 21h,al        
    mov al,01h
    out 0A1h,al       
    mov al, 0
    out 21h,al
    out 0A1h
ENABLE_INTERRUPTS_0:
    in  al,70h  
    and al,01111111b
    out 70h,al
    nop
    sti
GO_TO_CODE_PM:
    db 66h
    retf
BACK_TO_RM:
    cli
    in  al,70h
    or  AL,10000000b
    out 70h,AL
    nop
REINITIALISE_CONTROLLER:
    mov al,00010001b
    out 20h,al
    out 0A0h,al
    mov al,8h
    out 21h,al
    mov al,70h
    out 0A1h,al
    mov al,04h
    out 21h,al       
    mov al,02h
    out 0A1h,al      
    mov al,11h
    out 21h,al        
    mov al,01h
    out 0A1h,al
PREPARE_SEGMENTS:
    mov GDT_CODE_RM.LIMIT,0FFFFh
    mov GDT_DATA.LIMIT,0FFFFh
    mov GDT_STACK.LIMIT,0FFFFh
    db  0EAH
    dw  $+4
    dw  CODE_RM_DESC
    mov ax,DATA_DESC
    mov ds,ax                                   
    mov es,ax                                   
    mov fs,ax                                   
    mov gs,ax                                   
    mov ax,STACK_DESC
    mov ss,ax
ENABLE_REAL_MODE:
    mov eax,cr0
    and al,11111110b
    mov cr0,eax                        
    db  0EAH
    dw  $+4
    dw  CODE_RM
    mov ax,STACK_A
    mov ss,ax                      
    mov ax,DATA
    mov ds,ax                      
    mov es,ax
    xor ax,ax
    mov fs,ax
    mov gs,ax
    mov IDTR.LIMIT, 3FFH                
    mov dword ptr  IDTR+2, 0            
    lidt fword ptr IDTR                 
REPEAIR_MASK:
    mov al,INT_MASK_M
    out 21h,al
    mov al,INT_MASK_S
    out 0A1h,al
ENABLE_INTERRUPTS:
    in  al,70h  
    and al,01111111b
    out 70h,al
    nop
    sti
DISABLE_A20:
    in  al,92h
    and al,11111101b
    out 92h, al
EXIT:
    mov ax,3h
    int 10H
    lea dx,MSG_HELLO_RM
    mov ah,9h
    int 21h
    jmp START
END_PROG:
    mov ax,4C00h
    int 21H
SIZE_CODE_RM    = ($ - CODE_RM_BEGIN)
CODE_RM ends
CODE_PM  segment para use32
CODE_PM_BEGIN   = $
    assume cs:CODE_PM,ds:DATA,es:DATA
ENTER_PM:
    call CLRSCR
    xor  edi,edi
    lea  esi,MSG_HELLO_PM
    call BUFFER_OUTPUT
    add  edi,160
    lea  esi,MSG_KEYBOARD
    call BUFFER_OUTPUT
WAITING_ESC:
    jmp  WAITING_ESC
EXIT_PM:
    db 66H
    retf
EXIT_FROM_INTERRUPT:
    popad
    pop es
    pop ds
    pop eax
    pop eax
    sti
    db 66H
    retf
M = 0                           
IRPC N, 0123456789ABCDEF
EXC_0&N label word
    cli 
    jmp EXC_HANDLER
endm
M = 010H
IRPC N, 0123456789ABCDEF
EXC_1&N label word                          
    cli
    jmp EXC_HANDLER
endm
EXC_HANDLER proc near
    call CLRSCR
    lea  esi, MSG_EXC
    mov  edi, 40*2
    call BUFFER_OUTPUT
    pop eax
    pop eax
    pop eax
    sti
    db 66H
    retf
EXC_HANDLER     ENDP
DUMMY_IRQ_MASTER proc near
    push eax
    mov  al,20h
    out  20h,al
    pop  eax
    iretd
DUMMY_IRQ_MASTER endp
DUMMY_IRQ_SLAVE  proc near
    push eax
    mov  al,20h
    out  20h,al
    out  0A0h,al
    pop  eax
    iretd
DUMMY_IRQ_SLAVE  endp
KEYBOARD_HANDLER proc near
    push ds
    push es
    pushad
    in   al,60h
    cmp  al, 1
    jne   KEYBOARD_RETURN                        
    mov  al,20h
    out  20h,al
    db 0eah
    dd OFFSET EXIT_FROM_INTERRUPT 
    dw CODE_PM_DESC  
KEYBOARD_RETURN:
    mov  al,20h
    out  20h,al
    popad
    pop es
    pop ds
    iretd
KEYBOARD_HANDLER endp
CLRSCR  proc near
    push es
    pushad
    mov  ax,TEXT_DESC
    mov  es,ax
    xor  edi,edi
    mov  ecx,80*25
    mov  ax,700h
    rep  stosw
    popad
    pop  es
    ret
CLRSCR  endp
BUFFER_OUTPUT proc near
    push es
    pushad
    mov  ax,TEXT_DESC
    mov  es,ax
OUTPUT_LOOP:
    lodsb                                       
    or   al,al
    jz   OUTPUT_EXIT
    stosb
    inc  edi
    jmp  OUTPUT_LOOP
OUTPUT_EXIT:
    popad
    pop  es
    ret
BUFFER_OUTPUT ENDP
SIZE_CODE_PM     =       ($ - CODE_PM_BEGIN)
CODE_PM  ENDS
DATA    segment para use16
DATA_BEGIN      = $
    GDT_BEGIN   = $
    GDT label   word
    GDT_0       S_DESC <0,0,0,0,0,0>                              
    GDT_GDT     S_DESC <GDT_SIZE-1,,,ACS_DATA,0,>                 
    GDT_CODE_RM S_DESC <SIZE_CODE_RM-1,,,ACS_CODE,0,>             
    GDT_DATA    S_DESC <SIZE_DATA-1,,,ACS_DATA+ACS_DPL_3,0,>      
    GDT_STACK   S_DESC <1000h-1,,,ACS_DATA,0,>                    
    GDT_TEXT    S_DESC <2000h-1,8000h,0Bh,ACS_DATA+ACS_DPL_3,0,0> 
    GDT_CODE_PM S_DESC <SIZE_CODE_PM-1,,,ACS_CODE+ACS_READ,0,>    
    GDT_IDT     S_DESC <SIZE_IDT-1,,,ACS_IDT,0,>                  
    GDT_SIZE    = ($ - GDT_BEGIN)
    CODE_RM_DESC = (GDT_CODE_RM - GDT_0)
    DATA_DESC    = (GDT_DATA - GDT_0)      
    STACK_DESC   = (GDT_STACK - GDT_0)
    TEXT_DESC    = (GDT_TEXT - GDT_0)  
    CODE_PM_DESC = (GDT_CODE_PM - GDT_0)
    IDT_DESC     = (GDT_IDT - GDT_0)
    IDTR    R_IDTR  <SIZE_IDT,0,0>
    IDT label   word
    IDT_BEGIN   = $
    IRPC    N, 0123456789ABCDEF
        IDT_0&N I_DESC <0, CODE_PM_DESC,0,ACS_TRAP,0>
    ENDM
    IRPC    N, 0123456789ABCDEF
        IDT_1&N I_DESC <0, CODE_PM_DESC, 0, ACS_TRAP, 0>
    ENDM
    IDT_20    I_DESC <0,CODE_PM_DESC,0,ACS_INT,0>
    IDT_KEYBOARD I_DESC <0,CODE_PM_DESC,0,ACS_INT,0>
    IRPC    N, 23456789ABCDEF
        IDT_2&N         I_DESC <0, CODE_PM_DESC, 0, ACS_INT, 0>
    ENDM
    SIZE_IDT        =       ($ - IDT_BEGIN)
    MSG_HELLO           db "- Press 'y' to go to the protected mode",13,10,"$"
    MSG_HELLO_PM        db "Protected mode",0
    MSG_HELLO_RM        db "Normal mode",13,10,"$"
    MSG_KEYBOARD        db "- Press 'N' to come back to the normal mode",0
    MSG_EXC             db "exception: XX",0
    MSG_EXIT            db "- Press 'N' to exit",13,10,"$"
    MSG_ERROR           db "incorrect error$"
    HEX_TAB             db "0123456789ABCDEF"
    ESP32               dd  1 dup(?)
    INT_MASK_M          db  1 dup(?)        
    INT_MASK_S          db  1 dup(?)        

SIZE_DATA   = ($ - DATA_BEGIN)
DATA    ends
STACK_A segment para stack
    db  1000h dup(?)
STACK_A  ends
end START