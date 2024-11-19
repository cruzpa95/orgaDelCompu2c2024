global	main
extern 	printf
extern  gets
extern	sscanf
extern	puts

section .data

    f db '4'
    tex db "AB"
    c   db "CD"
    cont db 0

    tabla times 1040 db 1, 0

section .text
main:
    mov rbp, rsp; for correct debugging
    
    mov rax, 0
    mov rcx, 0
    mov cl, [f]
    mov esi,0
foo:
    add ax, [tabla+esi]
    add si, 40
    loop foo

    mov dl,al
    imul rax,2
    mov dh, al

    mov [tex],dx
    
    mov rcx,1
    mov rsi, cont
    mov rdi, c
    inc rdi
    rep movsb
    
    mov rdi, tex
    sub rsp, 8
    call puts
    add rsp, 8

    ret
