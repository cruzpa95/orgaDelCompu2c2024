global	main
extern 	printf
extern  gets
extern	sscanf
extern	puts

section .data

    tx  db 'hola','0'
    tz  db '123'
    result db 0
    ty  db 'chaucha',0

    tabla times 150 dd 1

section .text
main:
    mov rbp, rsp; for correct debugging
    
    mov esi, 16
    mov rcx, 5
    mov ebx, tabla
    mov rax, 0
    
ne:
    add eax, [ebx+esi]
    add si, 4
    loop ne

    inc rcx
    mov ebx, tabla
    add eax, [tabla+560]
    
    add eax,59
    mov ah,[tz]
    
    mov [tx],ax
    
    mov rdi, tx
    sub rsp, 8
    call puts
    add rsp, 8
    
    sub byte[ty+1], 104
    mov rdi,ty
    sub rsp, 8
    call puts        
    add rsp, 8
    ret