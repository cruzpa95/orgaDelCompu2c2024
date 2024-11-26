global	main
extern 	printf
extern  gets
extern	sscanf
extern  system

section .data
    msjIngFilaColumnaOrigen	db	'Ingrese Origen [XY]: ',0
    msjIngFilaColumnaDestino	db	'Ingrese Destino [XY]: ',0

    saltoLinea  db 10, 0     ; Salto de línea al final de cada fila     
    posicion    db       0
    format	db	'%li', 0

    longitudElemento equ	1
    cantidadColumnas equ 8
    cantidadFilas    equ	9
    
    posx_ini db 1
    posy_ini db 1
    
    posx_fin db 1
    posy_fin db 1
    
    elemento_inicial db 1

    format2	db	'%li %li', 0
    cmd_clear db "clear",0
    
    esTurnoDe	db	'Es turno de los %s!',10,0
    oficiales   db 'oficiales',0
    soldados    db 'soldados',0
    jugadorActual db 'soldados',0

    endGame    db 'Fin del juego!',10,0
    turno db 1
    divisor db 2 
    
    matriz  db ' 1234567',0
            db '1  XXX  ',0
            db '2  XXX  ',0
            db '3XXXXXXX',0
            db '4XXXXXXX',0
            db '5XX   XX',0
            db '6    O  ',0
            db '7  O    ',0

section .bss    
    buffer		resb	10
    cadena resb 2
    numero  resb 1

section .text
main:
    mov rbp, rsp; for correct debugging
    sub rsp, 8                ; Reserva espacio en la pila
    
    call asignar_jugador_inicial
ciclo_juego:
    call clear_screen
    call mostrar_tablero
    call mostrar_jugador_actual

    call pedir_casillero_origen
 
    cmp byte [posx_ini], 0
    je fin               ; Si es 0, salta a "fin"
    
    call pedir_casillero_destino

    call actualizar_turno
    call actualizar_tablero
    jmp ciclo_juego      ; Repite el bucle
        
    fin:
    add rsp, 8             ; Restaura el espacio de la pila
    sub rsp, 8
    call clear_screen
    mov rdi, endGame
    call printf
    add rsp,8
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
    sub rax, rax
    mov al,[posx_ini] ;guardo el valor de la fila, en AL(8bits) 
                    ;ya que posx es db (byte= 8bits) sino guarda cualquier cosa
;    sub rax,1 -> no es necesaria la resta ya que la matriz empieza en 1,1
    mov r8, cantidadFilas
    imul r8   ;me desplazo en la fila
    add rcx,rax
    
    mov al,[posy_ini] ;guardo el valor de la col,
;    sub rax,1
    mov r8, longitudElemento ;guardo en r8 para darle longitud y poder multiplicar usando imul
    imul r8 ;me desplazo en la columna
    add rcx,rax ;sumo los desplazamientos
    
    
    mov rbx,matriz ;pongo el pto al inicio de la matriz
    add rbx,rcx ;me posicione en la matriz

    mov r10, [rbx] ;guardo un elemento
    mov r9, [rbx+1] ;guardo en r9 lo que le sigue de matriz posterior al elemento a actualizar
    mov r8, " " ; lo muevo a un reg para darle (y estar seguro de su) longitud
    mov [rbx],r8 ;muevo el valor(de igual longitud). muevo a la posicion de la matriz a actualizar
    
    ;despues de agregar el nuevo valor, agregarle el resto de la matriz que estaba antes.
    mov [rbx+1],r9
    
    
    ;;repito con casillero_destino
    ;;y guardo en el destino lo que guarde en r10 (el elemento origen)
    
    
    ;Posicionamiento en el elemento i,j de una matriz
    ;(i-1)*longitudFila + (j-1)*longitudElemento
    ;longitdFila= longitudElemento*cantidadColumnas
    sub rcx, rcx
    mov al,[posx_fin] ;guardo el valor de la fila, en AL(8bits) 
                    ;ya que posx es db (byte= 8bits) sino guarda cualquier cosa
;    sub rax,1 -> no es necesaria la resta ya que la matriz empieza en 1,1
    mov r8, cantidadFilas
    imul r8   ;me desplazo en la fila
    add rcx,rax
    
    mov al,[posy_fin] ;guardo el valor de la col,
;    sub rax,1
    mov r8, longitudElemento ;guardo en r8 para darle longitud y poder multiplicar usando imul
    imul r8 ;me desplazo en la columna
    add rcx,rax ;sumo los desplazamientos
    
    
    mov rbx,matriz ;pongo el pto al inicio de la matriz
    add rbx,rcx ;me posicione en la matriz

    mov r9, [rbx+1] ;guardo en r9 lo que le sigue de matriz posterior al elemento a actualizar
    mov r8, r10 ; lo muevo a un reg para darle (y estar seguro de su) longitud
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
    
pedir_casillero_origen:
    
    sub rsp, 8
    mov rdi, msjIngFilaColumnaOrigen
    call printf
    add rsp, 8

    mov rdi, cadena      ; Dirección de 'cadena'
    sub rsp, 8
    call gets
    add rsp, 8

    ; Extraer el primer carácter (primer número)
    movzx rax, byte [cadena]     ; Cargar el primer carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posx_ini], al            ; Guardar el valor en 'posx_ini'
    
    ; Extraer el segundo carácter (segundo número)
    movzx rax, byte [cadena + 1] ; Cargar el segundo carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posy_ini], al            ; Guardar el valor en 'posy_ini'
    ret
    
pedir_casillero_destino:
    sub rsp, 8
    mov rdi, msjIngFilaColumnaDestino
    call printf
    add rsp, 8

    mov rdi, cadena      ; Dirección de 'cadena'
    sub rsp, 8
    call gets
    add rsp, 8

    ; Extraer el primer carácter (primer número)
    movzx rax, byte [cadena]     ; Cargar el primer carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posx_fin], al            ; Guardar el valor en 'posx_ini'
    
    ; Extraer el segundo carácter (segundo número)
    movzx rax, byte [cadena + 1] ; Cargar el segundo carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posy_fin], al            ; Guardar el valor en 'posy_ini'
    ret
    
mostrar_jugador_actual:    
    sub rsp, 8
    mov rdi, esTurnoDe
    mov rsi, [jugadorActual]
    call printf
    add rsp, 8
    ret
    
actualizar_turno:
    mov al, [turno]
    add byte [turno], 1
    mov al, [turno]
    xor ah, ah        ; Limpiar AH para asegurar que AX está correcto

    ; Dividir AX entre el divisor (2)
    xor rbx, rbx        
    mov bl, [divisor]
    div bl            ; AX / BL -> AL = cociente, AH = resto

    ; Ahora, AH contiene el resto (turno % 2)
    cmp ah, 0         ; Compara el resto con 0
    je es_par         ; Si el resto es 0, turno es par
    jmp es_impar      ; Si no, turno es impar

es_par:          
    lea rax, [oficiales]          ; Cargar la dirección de 'soldados' en AX
    mov [jugadorActual], rax
    ret

es_impar:        
    lea rax, [soldados]          ; Cargar la dirección de 'soldados' en AX
    mov [jugadorActual], rax
    ret
    
asignar_jugador_inicial:
    lea rax, [soldados]          ; Cargar la dirección de 'soldados' en AX
    mov [jugadorActual], rax
    ret 