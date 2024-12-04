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
;en el loop se hace la sumatoria de los elementos de la primer fila a partir de la columna? -> 5
;4bytes por elemento.
;16 + 20 + 24 + 28 + 32 -> 9 columnas



;falta un dato: hay 15 filas.

;eax = 5
;segun esta lineas todavia estoy dentro de la tabla, por lo tanto estoy sumando 1 a eax.
    inc rcx
    mov ebx, tabla
    add eax, [tabla+560]

;eax = 6    
;2da parte. aca se arrastra el error!!
    add eax,59  ;59 ES DECIMAL = 3B hexa; eax = 6+3B= 41 (4bytes)
    mov ah,[tz] ;ah = 123 ascii = 31 32 33 
                ;esto pudo haber dado esto:
                    ;eax; 00 00 00 41
                    ;eax; 31 32 33 41
                ;pero dio esto:
                    ;eax; 00 00 00 41
                    ;eax; 00 00 31 41
        
    ;ax = 31 41 -> [tx] =    'hola','0'
    mov [tx],ax ;que habra en tx? tx = 41 31 l a 0 -> A 1 l a 0
    mov rdi, tx ; mueve tx a rdi, e imprime A 1 l a 0 pero sigue leyendo en la memoria hasta encontrar un 0.
                ;por lo tanto agrega: 1 2 3
    sub rsp, 8
    call puts ;-> imprime:A1la0123
    add rsp, 8
    
    ;ty=chaucha -> 63 68 65 75 63 68 65

    sub byte[ty+1], 104 ;-> avanza una posicion en ty y le resta 104 decimal = 68 hexa,
    ;ty=chaucha -> 63 0 65 75 63 68 65
    mov rdi,ty  
    sub rsp, 8  ;imprime hasta encontrar un 0, osea hasta la 2da posicion.
    call puts        
    add rsp, 8
    ret