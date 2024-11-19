global	main
extern	printf

section .data
    msjX db 'X', 0             ; Mensaje que representa cada "X"
    saltoLinea db 10, 0        ; Carácter de salto de línea

section .bss
    i resb 1                   ; Contador para las filas
    j resb 1                   ; Contador para las columnas

section .text
main:
    sub rsp, 8                 ; Reserva espacio en la pila

    ; Inicializa i (fila) en 0
    mov byte [i], 0

    fila_loop:
        ; Comprueba si i < 7
        cmp byte [i], 7
        je fin                  ; Si i >= 7, termina el bucle

        ; Inicializa j (columna) en 0
        mov byte [j], 0

    columna_loop:
        ; Comprueba si j < 7
        cmp byte [j], 7
        je nueva_fila           ; Si j >= 7, pasa a una nueva fila

        ; Imprime 'X'
        mov rdi, msjX
        xor rax, rax            ; Limpia rax para printf
        call printf

        ; Incrementa j (columna)
        inc byte [j]
        jmp columna_loop        ; Repite el bucle de columnas

    nueva_fila:
        ; Imprime salto de línea después de cada fila completa
        mov rdi, saltoLinea
        xor rax, rax            ; Limpia rax para printf
        call printf

        ; Incrementa i (fila)
        inc byte [i]
        jmp fila_loop           ; Repite el bucle de filas

    fin:
        add rsp, 8              ; Restaura el espacio de la pila
        ret
