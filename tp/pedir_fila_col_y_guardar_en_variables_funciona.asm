global	main
extern 	printf
extern  gets
extern	sscanf
extern  system

section .data
    matriz db ' 1234567',0
           db '1  XXX  ',0
           db '2  XXX  ',0
           db '3XXXXXXX',0
           db '4XXXXXXX',0
           db '5XX   XX',0
           db '6    O  ',0
           db '7  O    ',0
    saltoLinea  db 10, 0     ; Salto de línea al final de cada fila
    nuevoValor  db 'Z',0       
    posicion    db       0
    msjIngFilaColumna	db	'Ingrese un fila y columna [XY]: ',0
;    msjIngCol		db	'Ingrese un columna: ',0
;    msjImpNum		db	'Usted ingreso %i !!',10,0
    msjIndice		db	'indice: %li !!',10,0

;    numFormat		db	'%li',0	;%i 32 bits / %li 64 bits
    format	db	'%li', 0

    longitudElemento equ	1
    cantidadColumnas equ 8
    cantidadFilas    equ	9
    posx db 3
    posy db 3
    
    posx_ini db 1
    posy_ini db 1
    
    posx_fin db 1
    posy_fin db 1

    format2	db	'%li %li', 0
    cmd_clear db "clear",0

section .bss    
    buffer		resb	10
    cadena resb 2
    numero  resb 1

section .text
main:
    mov rbp, rsp; for correct debugging
    sub rsp, 8                ; Reserva espacio en la pila
    call mostrar_tablero
    call actualizar_tablero
    call clear_screen
    
    call mostrar_tablero
    call pedir_casillero_inicial
    fin:
    add rsp, 8             ; Restaura el espacio de la pila
    ret

mostrar_tablero:
    mov rax, 0
    mov [posicion], rax 
    mov rcx, cantidadColumnas
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
        add rax, cantidadFilas                 ; Suma 10 a rax
        mov [posicion], rax         ; Guarda el nuevo valor en "posicion"
        
        loop fila_loop
        
        mov rdi, saltoLinea
        xor rax, rax           ; Limpia rax para printf
        call printf
        
        ret

actualizar_tablero:
    ;Posicionamiento en el elemento i,j de una matriz
    ;(i-1)*longitudFila + (j-1)*longitudElemento
    ;longitdFila= longitudElemento*cantidadColumnas
    sub rcx, rcx
    mov al,[posx] ;guardo el valor de la fila, en AL(8bits) 
                    ;ya que posx es db (byte= 8bits) sino guarda cualquier cosa
;    sub rax,1 -> no es necesaria la resta ya que la matriz empieza en 1,1
    mov r8, cantidadFilas
    imul r8   ;me desplazo en la fila
    add rcx,rax
    
    mov al,[posy] ;guardo el valor de la col,
;    sub rax,1
    mov r8, longitudElemento ;guardo en r8 para darle longitud y poder multiplicar usando imul
    imul r8 ;me desplazo en la columna
    add rcx,rax ;sumo los desplazamientos
    
    mov rbx,matriz ;pongo el pto al inicio de la matriz
    add rbx,rcx ;me posicione en la matriz


    mov r9, [rbx+1] ;guardo en r9 lo que le sigue de matriz posterior al elemento a actualizar
    mov r8, "Z" ; lo muevo a un reg para darle (y estar seguro de su) longitud
    mov [rbx],r8 ;muevo el valor(de igual longitud). muevo a la posicion de la matriz a actualizar
    
    ;despues de agregar el nuevo valor, agregarle el resto de la matriz que estaba antes.
    mov [rbx+1],r9
    ret

clear_screen:
    mov rdi, cmd_clear
    sub rsp, 8
    call system
    add rsp, 8
    ret
    
pedir_casillero_inicial:
    sub rsp, 8
    mov rdi, msjIngFilaColumna
    call printf

    mov rdi, cadena      ; Dirección de 'cadena'
    call gets

    ; Extraer el primer carácter (primer número)
    movzx rax, byte [cadena]     ; Cargar el primer carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posx_ini], al            ; Guardar el valor en 'posx_ini'
    
    ; Extraer el segundo carácter (segundo número)
    movzx rax, byte [cadena + 1] ; Cargar el segundo carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posy_ini], al            ; Guardar el valor en 'posy_ini'
    
      ; Imprimir los resultados
;    movzx rsi, byte [posx_ini]    ; Cargar 'posx_ini' en rsi
;    movzx rdx, byte [posy_ini]    ; Cargar 'posy_ini' en rdx
;    lea rdi, [format2]            ; Formato de impresión
;    call printf
   
    add rsp, 8
    
    
    ; Finalizar el programa
    ret