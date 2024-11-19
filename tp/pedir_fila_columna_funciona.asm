global main
extern gets
extern printf
extern sscanf

section .data
    msjIngFila		db	'Ingrese fila origen: ',0
    msjIngCol		db	'Ingrese columna origen: ',0
    msj2		db	'Casillero origen: %li,%li !!',10,0
    format	db	'%li',0
    
section .bss
    filaStr resb 100
    columnaStr resb 100

    filaOrigen resq 1
    columnaOrigen resq 1
    
section .text
main:
    sub rsp, 8            ; Align stack for calling conventions
    
ingresar_fila:
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
    
ingresar_columna:
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
    
;mostrar ingreso
    mov rdi, msj2
    mov rsi, [filaOrigen]
    mov rdx, [columnaOrigen]
    call printf
    
    add rsp, 8            ; Restore stack alignment
    ret

