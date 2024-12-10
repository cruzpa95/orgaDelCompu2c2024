global	main
extern 	printf
extern  gets
extern	sscanf
extern	puts

section .data

    tx db 'hola','0'
    tz db '123'
    result db 0
    da db 71
    ty db 'chaucha',0
    tw db 'chauchA',0

    tabla times 540 dw 1

section .text
main:
    mov rbp, rsp ; for correct debugging

    mov esi, 0
    mov rcx, 36 ;36 filas
    mov ebx, tabla
    mov rax, 0

ne:
    add ax, [ebx+esi] ;ax = 16bits -> 2 bytes
    add si, 30 ;15 columnas de 2bytes
    loop ne ; ax=36 decimal, 24hexa

    mov ah, [da] ;ax = 47 24 ;hexa
    
    
    mov edx, tx ; rdx = 'hola0' 68 6F 6C 61 30
    mov edi, 2 ;; se mueve 2 posiciones, es decir que modifica desde el 3er elemento de modo little endian
    
    mov [edx + edi], ax ; 68 6F 24 47 30 -> ho$G0
    mov rdi, tx    ;rdi apunta a tx (donde estaba hola0 pero ahora sobreescrito)
    sub rsp, 8
    call puts   ;imprime ho$G0 en tx, pero sigue leyendo la memoria hasta un 0 -> ho$G0123
    add rsp, 8

    mov rcx, 3
    dec cl ;rcx=2
    mov esi, tx ;tx=ho$G0 -> 68 6F 24 47 30
    mov edi, ty ;ty=chaucha -> 63 68 61 75 63 68 61 0
    repe movsb ;copia 2 de rsi a rdi
    mov rdi, ty ;ty = 68 6F 61 75 63 68 61 0
    sub rsp, 8 
    call puts
    add rsp, 8
    
    
    

    mov cx,7
    repe cmpsb
    je uno
    mov rax,2
uno:
    add rax,1

    ret