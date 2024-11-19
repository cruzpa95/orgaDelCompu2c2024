global main
extern gets
extern printf
extern sscanf

section .data
    msjIngFila		db	'Ingrese fila: ',0
    msjIngCol		db	'Ingrese columna: ',0
    msj2		db	'Casillero origen: %li,%li !!',10,0
    msj3    	db	'Casillero destino: %li,%li !!',10,0
    format	db	'%li',0
    
section .bss
    filaStr resb 100
    columnaStr resb 100

    filaOrigen resq 1
    columnaOrigen resq 1

    filaDestino resq 1
    columnaDestino resq 1
    
section .text
main:
    sub rsp, 8            ; Align stack for calling conventions
    
ingresar_fila_origen:
    mov rdi, msjIngFila
    xor rax, rax           ; Limpia rax para printf
    call printf
    
    mov rdi, filaStr
    call gets    

    ;scanf
    mov rdi, filaStr
    mov rsi, format
    mov rdx, filaOrigen    
    call sscanf
    
ingresar_columna_origen:
    mov rdi, msjIngCol
    xor rax, rax           ; Limpia rax para printf
    call printf
    
    mov rdi, columnaStr
    call gets    
       
    ;scanf
    mov rdi, columnaStr
    mov rsi, format
    mov rdx, columnaOrigen    
    call sscanf


    
ingresar_fila_destino:
    mov rdi, msjIngFila
    xor rax, rax           ; Limpia rax para printf
    call printf
    
    mov rdi, filaStr
    call gets    

    ;scanf
    mov rdi, filaStr
    mov rsi, format
    mov rdx, filaDestino    
    call sscanf
    
ingresar_columna_destino:
    mov rdi, msjIngCol
    xor rax, rax           ; Limpia rax para printf
    call printf
    
    mov rdi, columnaStr
    call gets    
       
    ;scanf
    mov rdi, columnaStr
    mov rsi, format
    mov rdx, columnaDestino    
    call sscanf


;mostrar ingreso
    mov rdi, msj2
    mov rsi, [filaOrigen]
    mov rdx, [columnaOrigen]
    call printf
    
    mov rdi, msj3
    mov rsi, [filaDestino]
    mov rdx, [columnaDestino]
    call printf
    
    add rsp, 8            ; Restore stack alignment
    ret

