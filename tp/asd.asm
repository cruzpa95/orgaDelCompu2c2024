global	main
extern	puts

section .data
    da db 71
    tabla times 540 dw 1


section .text
main:
    mov rbp, rsp; for correct debugging

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
         
    ret