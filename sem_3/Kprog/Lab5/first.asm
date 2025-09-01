.model small
.stack 100h

.data

; MESSAGES
mess_noData db "No data.", 0Ah, 0Dh, '$'
mess_noFileName db "No file with this name.", 0Ah, 0Dh, '$'
mess_start db "...started working with your file...", 0Ah, 0Dh, '$'
mess_end db "...finished working with your file...", 0Ah, 0Dh, '$'
mess_lines db "The number of non-empty lines in the file: ", '$'
mess_totalLines db "The total number of lines in the file: ", '$'
mess_additionalLines db "Additional number (empty lines): ", 0Ah, 0Dh, '$'
mess_errorFile db "ERROR: the file was not found.", 0Ah, 0Dh, '$'
mess_errorPath db "ERROR: the path was not found.", 0Ah, 0Dh, '$'
mess_errorFiles db "ERROR: there are too many open files.", 0Ah, 0Dh, '$'
mess_errorAccess db "ERROR: access to the file is denied.", 0Ah, 0Dh, '$'
mess_errorAccessMode db "ERROR: invalid access mode.", 0Ah, 0Dh, '$'
mess_errorDescriptor db "ERROR: invalid descriptor.", 0Ah, 0Dh, '$'
mess_errorR db "ERROR: the file cannot be read.", 0Ah, 0Dh, '$'
mess_successfulOpen db "The file has been opened successfully.", 0Ah, 0Dh, '$'
mess_successfulClose db "The file has been closed successfully.", 0Ah, 0Dh, '$'
mess_successfulRead db "The file has been read successfully.", 0Ah, 0Dh, '$'
mess_foundLines db "Number of lines containing symbols: ", '$'
mess_symbols db "Symbols entered: ", '$'
mess db 0Ah, 0Dh, '$'

; CONSTANTS
LENGTH equ 126
SIZE equ 2

; FLAGS
rf dw 0
eof dw 0

; COUNTERS
cChars dw 0
cNonEmptyLines dw 0
addLines dw 0
totalLines dw 0  ; Counter for the total number of lines
matchedLines dw 0 ; Counter for lines with matches
 
; VARIABLES 
dc equ 1024
cmdLengthFact dw ?
CMD db 126 dup(?)
SYMBOLS db 126 dup(?)
descriptor dw ?

buffer db dc+2 dup('$')

.code
; MACROS
display macro str
    pusha
    display1 str
    popa
endm

display1 macro str
    lea dx, str
    mov ah, 09h
    int 21h
endm  

endProg macro
    mov ax, 4Ch
    int 21h
endm

start:
    mov ax, @data
    mov ds, ax
    
    ; Get command line arguments
    call getComandLineArgs
    
    ; Check CMD
    mov ax, cmdLengthFact
    cmp ax, 1
    jle noData
    
    ; Display start message
    display mess_start
    
    lea dx, CMD
    call openFile
    cmp ax, 1
    je endStart
    
    call numberLines
    
    display1 mess_lines
    mov ax, cNonEmptyLines
    call print
    display1 mess
    
    display mess_totalLines
    mov ax, totalLines
    call print
    display1 mess
    
    display mess_additionalLines
    mov ax, totalLines
    sub ax, cNonEmptyLines
    call print
    display1 mess
    
    ; Display symbols entered by user
    display1 mess_symbols
    lea dx, SYMBOLS
    call displaySymbols  ; Call new procedure to display symbols
    
    ; Search for symbols in the file
    call searchInFile
    
    display mess_foundLines
    mov ax, matchedLines
    call print
    display1 mess

    call closeFile
    cmp ax, 1
    je endStart
    
    display mess_end
    jmp endStart 

noData:
    display mess_noData    
    
endStart:
    endProg 

; PROCEDURES
getComandLineArgs proc
    push ax
    push cx
    
    mov cx, 0
    mov cl, ES:[80h]
    mov cmdLengthFact, cx
    
    cmp cx, 1
    jle endProc
    
    cld
    mov di, 81h
    mov al, ' '
    rep scasb
    dec di
    lea si, CMD

copyCmd:
    mov al, ES:[DI]
    cmp al, 0Dh
    je endCopyCmd
    cmp al, 20h
    je endCopyCmd
    cmp al, 9h
    je endCopyCmd
    
    mov DS:[SI], al
    inc di
    inc si
    jmp copyCmd
    
endCopyCmd:
    inc si
    mov DS:[SI], '$'
    
    ; Read additional symbols
    lea si, SYMBOLS
    mov di, di   ; Point DI to where we left off in the command line
    mov cx, 0    ; Reset index for SYMBOLS

copySymbols:
    mov al, ES:[DI]
    cmp al, 0Dh
    je endCopySymbols
    cmp al, 20h
    je endCopySymbols
    cmp al, 9h
    je endCopySymbols
    
    mov DS:[SI], al
    inc di
    inc si
    inc cx
    jmp copySymbols
    
endCopySymbols:
    mov DS:[SI], '$'  ; Null-terminate the symbols string

endProc:
    pop cx
    pop ax
    ret    
endp getComandLineArgs    

; OPEN FILE
openFile proc
    push cx
    mov ah, 3Dh
    mov al, 0h
    int 21h
    
    jc errorFile
    
    mov descriptor, ax
    jmp successfulFileOpening
    
errorFile:
    cmp al, 02h
    jne errorPath
    display mess_errorFile
    jmp errorOpenFile
    
errorPath:
    cmp al, 03h
    jne errorManyOpenFiles
    display mess_errorPath
    jmp errorOpenFile
    
errorManyOpenFiles:
    mov al, 04h
    jne errorNoAccess
    display mess_errorFiles
    jmp errorOpenFile
    
errorNoAccess:
    mov al, 05h
    jne errorInvalidAccessMode
    display mess_errorAccess
    jmp errorOpenFile
    
errorInvalidAccessMode:
    mov al, 0Ch
    jne errorOpenFile
    display mess_errorAccessMode
    jmp errorOpenFile    
    
errorOpenFile:
    mov ax, 1
    jmp endProcOpen    

successfulFileOpening:
    mov ax, 0
    display mess_successfulOpen
    jmp endProcOpen
    
endProcOpen:
    pop cx
    ret    
endp openFile

; READ FILE
readFile proc
   mov ax, 0
   mov ah, 3Fh
   mov cx, dc
   lea dx, buffer
   int 21h
   
   jc errorR
   mov cx, ax
   mov ax, 0

   ; Check if file is empty
   cmp cx, 0
   je emptyFile  ; If cx = 0, file is empty

   jmp endProcRead

errorR:
    display mess_errorR
    mov ax, 1  
    jmp endProcRead

emptyFile:
    mov eof, 1  ; Set end of file flag
    mov totalLines, 0
    mov cNonEmptyLines, 0
    mov addLines, 0
    jmp endProcRead

endProcRead:
    ret    
endp readFile

; CLOSE FILE
closeFile proc
    mov bx, descriptor
    mov ah, 3Eh
    int 21h
    
    jnc successfulFileClosing
    
    display mess_errorDescriptor
    mov ax, 1
    jmp endProcClose
    
successfulFileClosing:
    mov ax, 0
    display mess_successfulClose    
    
endProcClose:
    ret    
endp closeFile

; PRINT RESULT
print proc
    pusha
    xor cx, cx
    mov bx, 10
loopf:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    ja loopf
    
loops:
    pop dx
    add dx, 30h
    mov ah, 02h
    int 21h
    loop loops
    
    popa
    ret
endp print

; DISPLAY SYMBOLS
; Добавьте эту процедуру для отображения символов
displaySymbols proc
    lea dx, SYMBOLS
    mov ah, 09h
    int 21h
    display1 mess  ; Отобразить перевод строки
    ret
endp displaySymbols

; Измените вызов displaySymbols в основном коде
; После сохранения символов
display1 mess_symbols
call displaySymbols  ; Вызов процедуры для отображения символов

scanBuffer proc
    lea si, buffer
    push ax
    mov cChars, 0  
    mov totalLines, 0  
    mov lastLineEmpty, 0  

scan:
    lodsb

    cmp al, 13   
    je newlineChar
    cmp al, 10    
    je newlineChar

    cmp al, 20h    
    je next
    cmp al, 9h     
    je next

    inc cChars
    jmp next   

newlineChar:
    inc totalLines  ; Count this line (including empty ones)
    cmp cChars, 0   ; Check if the line is empty
    je next
    inc cNonEmptyLines
    mov cChars, 0   ; Reset character counter for next line
    
next:
    cmp eof, 0      ; Check if end of file is reached
    je checkLastLine
    loop scan

checkLastLine:
    lea si, buffer
    mov bx, cChars  ; Length of the last line

skipLastLineWhitespace:
    cmp bx, 0
    je lastLineEmpty
    dec bx
    mov al, [si + bx]
    cmp al, 13      ; If it's a Carriage Return (CR)
    je skipLastLineWhitespace
    cmp al, 10      ; If it's a Line Feed (LF)
    je skipLastLineWhitespace
    cmp al, 20h     ; If it's a space
    je skipLastLineWhitespace
    cmp al, 9h      ; If it's a tab
    je skipLastLineWhitespace
    jmp endSkipLastLine

lastLineEmpty:
    inc totalLines   ; Count the last line as empty if only whitespace
    jmp endProcS

endSkipLastLine:
    inc totalLines   ; Count the last line
    inc cNonEmptyLines

endProcS:
    mov ax, totalLines
    shr ax, 1       ; Divide by 2 (adjustment)
    add ax, 1       ; Round up
    mov totalLines, ax

    pop ax
    ret         
endp scanBuffer

; COUNT NON-EMPTY LINES
numberLines proc
    pusha
    
    mov cNonEmptyLines, 0
    mov cChars, 0
    mov addLines, 0
    mov totalLines, 0  ; Reset total line count
    mov rf, 0
    mov eof, 0
    mov bx, descriptor
    
main:
    call readFile
    cmp ax, 1
    je endProcN 
    
    cmp eof, 1
    je endProcN

    cmp cx, dc
    jb last
    
    call scanBuffer
    jmp main
    
last:
    mov eof, 1
    call scanBuffer
    jmp endProcN
    
endProcN:
    popa
    ret
endp numberLines

; SEARCH IN FILE
searchInFile proc
    pusha
    lea si, SYMBOLS    ; Load the address of the symbols
    mov matchedLines, 0 ; Reset matched lines counter
    mov bx, descriptor ; File descriptor

searchLoop:
    call readFile      ; Read the file
    cmp ax, 1
    je endSearch       ; If error, end search

    lea di, buffer     ; Point to the buffer
    mov cx, cChars     ; Number of characters in the buffer

checkLine:
    mov al, [si]      ; Load a symbol to check
    cmp al, '$'       ; Check for end of symbols
    je endCheckLine    ; If end of symbols, finish checking

    mov dx, cx        ; Save number of characters
    mov cx, dc        ; Reset character count

    findSymbol:
        lodsb         ; Load next character from buffer
        cmp al, 0     ; Check for end of buffer
        je foundLine   ; If end of buffer, go to foundLine
        cmp al, [si]  ; Compare with the symbol
        je foundLine   ; If found, go to foundLine
        loop findSymbol

    jmp checkLine     ; Check the next symbol

foundLine:
    inc matchedLines   ; Increment matched lines
    jmp searchLoop     ; Go back to search for next line

endCheckLine:
    popa
    ret
endp searchInFile

endSearch: