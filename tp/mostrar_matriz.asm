global	main
extern	printf

section .data
    matriz db ' 01234567', 0
           db 'a   XXX  ', 0
           db 'b   XXX  ', 0
           db 'c XXXXXXX', 0
           db 'd XXXXXXX', 0
           db 'e XX   XX', 0
           db 'f     O  ', 0
           db 'g   O    ', 0
    saltoLinea  db 10, 0       ; Salto de línea al final de cada fila
    CANT_FIL    equ	3
    CANT_COL    equ	3
    posicion    dq       0
    

section .bss    

section .text
main:
    sub rsp, 8                ; Reserva espacio en la pila
    mov rcx, 10
    fila_loop:
        push rcx ;es necesario para loop, sino el registro rcx se pisa y loopea infinito
        ; Carga la dirección de la fila actual en la matriz

        ; Imprime la fila actual

        mov rdi, matriz         ; Pasa la dirección de la fila a printf
        add rdi, [posicion]
        sub rax, rax           ; Limpia rax para printf
        call printf

        ; Imprime salto de línea después de cada fila
        mov rdi, saltoLinea
        xor rax, rax           ; Limpia rax para printf
        call printf
        pop rcx ;es necesario para loop, sino el registro rcx se pisa y loopea infinito
        
        ; Sumar 10 a "posicion"
        mov rax, [posicion]         ; Carga el valor de "posicion" en rax
        add rax, 10                 ; Suma 10 a rax
        mov [posicion], rax         ; Guarda el nuevo valor en "posicion"
        
        loop fila_loop

    fin:
        add rsp, 8             ; Restaura el espacio de la pila
        ret
