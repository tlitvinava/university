org 100h
       
mov dx, offset my_str      
mov ah, 09h 
      
int 21h

ret  

my_str db 'Hello World!$'
