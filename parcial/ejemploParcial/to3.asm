section .note.GNU-stack noalloc noexec nowrite progbits

section .data
dimension db 7                  ; Dimensión de la matriz cuadrada 7x7
matriz times 49 db ' '          ; Matriz 7x7 con espacios en blanco

newline db 10                       ; Código ASCII para nueva línea

section .text
global _start

_start:
; Llenar la cruz con 'X'
mov al, 'X'

; Llenar la fila superior de la cruz con 'X'
mov rbx, 0                     ; Índice inicial para la fila superior
llenar_fila_superior:
mov [matriz + rbx], al
add rbx, 1
cmp rbx, 21
jl llenar_fila_superior

; Llenar el borde derecho de la cruz con 'X'
mov rbx, 4                     ; Índice inicial del borde derecho
llenar_borde_derecho:
mov [matriz + rbx], al
add rbx, 7
cmp rbx, 46
jl llenar_borde_derecho

; Llenar el borde izquierdo de la cruz con 'X'
mov rbx, 2                     ; Índice inicial del borde izquierdo
llenar_borde_izquierdo:
mov [matriz + rbx], al
add rbx, 7
cmp rbx, 44
jl llenar_borde_izquierdo

; Llenar la fila inferior de la cruz con 'X'
mov rbx, 28                    ; Índice inicial para la fila inferior
llenar_fila_inferior:
mov [matriz + rbx], al
add rbx, 1
cmp rbx, 49
jl llenar_fila_inferior

; Llenar las esquinas rojas con 'X'
mov rbx, 28
mov [matriz + rbx], al
mov rbx, 34
mov [matriz + rbx], al
mov rbx, 30
mov [matriz + rbx], al
mov rbx, 32
mov [matriz + rbx], al

; Llenar la parte inferior gris con 'O'
mov al, 'O'
mov rbx, 38
mov [matriz + rbx], al
mov rbx, 45
mov [matriz + rbx], al

; Mostrar la matriz en pantalla en formato 7x7
mov rcx, 0                     ; Índice para recorrer la matriz
mostrar_matriz:
; Mostrar cada carácter en la matriz
mov rax, 1                     ; syscall número para write
mov rdi, 1                     ; file descriptor (stdout)
mov rsi, matriz                ; dirección de la matriz
add rsi, rcx                   ; ajustar al índice actual
mov rdx, 1                     ; escribir un solo carácter
syscall                        ; llamada al sistema para escribir

; Imprimir nueva línea al final de cada fila (cada 7 caracteres)
inc rcx                        ; incrementar índice
mov rbx, rcx
mov rdx, 7
div rdx                        ; dividir rcx entre 7
cmp rdx, 0                     ; ¿Es el residuo 0? (es el final de una fila)
jne continuar                  ; si no es el final de una fila, continuar

; Nueva línea
mov rax, 1                     ; syscall número para write
mov rdi, 1                     ; file descriptor (stdout)
mov rsi, newline               ; imprimir nueva línea
mov rdx, 1                     ; longitud de la nueva línea
syscall                        ; llamada al sistema para escribir

continuar:
cmp rcx, 49                    ; Verificar si hemos mostrado toda la matriz (49 elementos)
jl mostrar_matriz              ; si no, repetir el bucle

; Salir del programa
mov rax, 60                    ; syscall número para exit en x64
xor rdi, rdi                   ; exit code 0
syscall                        ; llamada al sistema para salir