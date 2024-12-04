global	main
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


;La siguiente porcion corresponde al segmento de datos de un programa Intel    
ne:
    add ax, [ebx+esi] ;ax = 16bits -> 2 bytes
    add si, 30 ;15 columnas de 2bytes
    loop ne
;ax = 15
    mov ah, [da]
;ax = 7115
;En el loop se realiza la sumatoria de los elementos de la primer columna de la tabla cuya dimensión es Respuesta
;36
; filas x  Respuesta
;15
; columnas

    ;ax=? 15;
;primera parte.
;El mismo programa continúa con la siguiente porción de código:
         
    mov [edx + edi], ax
    mov rdi, tx    
    sub rsp, 8
    call puts
    add rsp, 8
    
;El mismo programa continúa con la siguiente porción de código:

    dec cl
    mov esi, tx
    mov edi, ty
    repe movsb
    mov rdi, ty
    sub rsp, 8
    call puts
    add rsp, 8
    
;El mismo programa continúa con la siguiente porción de código:
    mov cx,7
    repe cmpsb
    je uno
    mov rax,2
uno:
    add rax,1

    ret