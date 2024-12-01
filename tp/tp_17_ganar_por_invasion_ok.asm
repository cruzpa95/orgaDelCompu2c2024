global	main
extern 	printf
extern  gets

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
    casilleroInvalido db 'casillero invalido!',10,0
    msj_movimiento_oficial_invalido db 'movimiento_oficial_invalido! Vuelva a intentarlo',10,0
    msj_movimiento_soldado_invalido db 'movimiento_soldado_invalido! Vuelva a intentarlo',10,0

    msj_ganaron_soldados_por_falta_oficiales db 'Ganaron los soldados, no hay mas oficiales que puedan defender la fortaleza!',10,0
    msj_ganaron_soldados_por_invasion db 'Ganaron los soldados, invadieron la fortaleza!',10,0
    msj_ganaron_oficiales_por_falta_soldados db 'Ganaron los oficiales, ya no quedan mas soldados!',10,0

    endGame    db 'Fin del juego!',10,0
    turno db 1
    divisor db 2 
    
    matriz  db ' 1234567',0
            db '1 |XXX| ',0
            db '2_|XXX|_',0
            db '3O XXXXX',0
            db '4XXX XXX',0
            db '5XXXX XX',0
            db '6~|XXX|~',0
            db '7 |XXX| ',0

section .bss    
    buffer		resb	10
    cadena resb 2
    numero  resb 1

section .text
main:
    mov rbp, rsp; for correct debugging
    sub rsp, 8
    mov r14, 2 ;seteo cantidad de oficiales.
    call asignar_jugador_inicial
ciclo_juego:
    call clear_screen
    call mostrar_tablero
    call mostrar_jugador_actual
pedir_movimiento:
    call pedir_casillero_origen
pedir_movimiento_destino:
    call pedir_casillero_destino

    mov al, [turno]
    cmp al, 1
    je validar_movimiento_soldado
    call validar_movimiento_oficial ;hacer esto solo si es el turno del oficial.
    cmp r12, 0                  ; Si la validacion esta mal -> r12 != 0 -> volver a pedir origen-destin0
    jne pedir_movimiento         ; Si no es 0 -> back to pedir_movimiento
    jmp prox_turno

validar_movimiento_soldado:
    mov rax,0
    
    mov al, [posx_fin]
    mov ah, [posx_ini]
    sub al, ah

    cmp al, 0
    je validar_movimiento_soldado_horizontal
    cmp al,-1 
    je validar_movimiento_soldado_arriba
    cmp al, 1
    je validar_movimiento_soldado_abajo
    jmp movimiento_soldado_invalido
    
;fn terminada
validar_movimiento_soldado_horizontal:
    mov rax,0
    mov al, [posx_ini]

    cmp al, 7
    je validar_movimiento_soldado_horizontal_fila_siete_seis
    cmp al, 6
    je validar_movimiento_soldado_horizontal_fila_siete_seis
    cmp al, 5
    je validar_movimiento_soldado_horizontal_fila_cinco

    jmp movimiento_soldado_invalido

;fn terminada
validar_movimiento_soldado_horizontal_fila_siete_seis:
    mov rdx,0
    mov dl, [posy_ini]
    mov dh, [posy_fin]

    cmp dl, 3
    je validar_movimiento_soldado_horizontal_columna_tres_cinco
    cmp dl, 4
    je validar_movimiento_soldado_horizontal_columna_cuatro
    cmp dl, 5
    je validar_movimiento_soldado_horizontal_columna_tres_cinco
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_horizontal_columna_tres_cinco:
    cmp dh, 4
    je movimiento_soldado_valido
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_horizontal_columna_cuatro:
    cmp dh, 3
    je movimiento_soldado_valido
    cmp dh, 5
    je movimiento_soldado_valido
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_horizontal_fila_cinco:
    mov rdx,0
    mov dl, [posy_ini]
    mov dh, [posy_fin]
    
    cmp dl, 3
    jle movimiento_soldado_derecha
    cmp dl, 4
    je movimiento_soldado_derecha_izquierda
    cmp dl, 7
    jle movimiento_soldado_izquierda
    jmp movimiento_soldado_invalido

movimiento_soldado_derecha:
    sub dh,dl
    cmp dh, 1
    je movimiento_soldado_valido
    jmp movimiento_soldado_invalido

movimiento_soldado_izquierda:
    sub dh,dl
    cmp dh,-1
    je movimiento_soldado_valido
    jmp movimiento_soldado_invalido

movimiento_soldado_derecha_izquierda:
    sub dh,dl
    cmp dh,-1
    je movimiento_soldado_valido
    cmp dh, 1
    je movimiento_soldado_valido
    jmp movimiento_soldado_invalido

;;fin validar movimientos horizontales
validar_movimiento_soldado_arriba:
    mov rax,0
    mov al, [posx_ini]
    
    cmp al, 6
    je validar_movimiento_soldado_arriba_en_fortaleza
    cmp al, 7
    je validar_movimiento_soldado_arriba_en_fortaleza
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_arriba_en_fortaleza:
    mov rdx,0
    mov dl, [posy_ini]
    mov dh, [posy_fin]

    cmp dl, 3
    je validar_movimiento_soldado_arriba_en_fortaleza_columna_tres
    cmp dl, 4
    je validar_movimiento_soldado_arriba_en_fortaleza_columna_cuatro
    cmp dl, 5
    je validar_movimiento_soldado_arriba_en_fortaleza_columna_cinco
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_arriba_en_fortaleza_columna_tres:
    cmp dh, 3
    je movimiento_oficial_ok
    cmp dh, 4
    je movimiento_oficial_ok
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_arriba_en_fortaleza_columna_cuatro:
    cmp dh, 3
    je movimiento_oficial_ok
    cmp dh, 4
    je movimiento_oficial_ok
    cmp dh, 5
    je movimiento_oficial_ok
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_arriba_en_fortaleza_columna_cinco:
    cmp dh, 4
    je movimiento_oficial_ok
    cmp dh, 5
    je movimiento_oficial_ok
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_abajo:
    mov rdx,0
    mov dl, [posy_ini]
    mov dh, [posy_fin]
    
    sub dh, dl
    cmp dh,-1
    je movimiento_soldado_valido
    cmp dh, 0
    je movimiento_soldado_valido
    cmp dh, 1
    je movimiento_soldado_valido
    jmp movimiento_soldado_invalido

;;fin validar_movimiento_soldado
    jmp prox_turno
    
prox_turno:
    call actualizar_turno
    call actualizar_tablero
    call eliminar_oficial_desentendido
    call verificar_ganador
    jmp ciclo_juego      ; Repite el bucle
        
    fin:
;    add rsp, 8             ; Restaura el espacio de la pila
    ;call clear_screen

    mov rdi, endGame
    sub rsp, 8
    call printf
    add rsp,8

    mov ah, 4Ch    ; Código de función para terminar el programa;    mov al, 0      ; Código de retorno (0 indica éxito)
    mov al, 0      ; Código de retorno (0 indica éxito)
    int 21h        ; Llamada a la interrupción 21h

    ret

mostrar_tablero:
    mov rax, 0
    mov [posicion], rax 
    mov rcx, cantidadColumnas
    sub rsp, 8
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
        add rsp, 8
        ret

actualizar_tablero:
    ;Posicionamiento en el elemento i,j de una matriz
    ;(i-1)*longitudFila + (j-1)*longitudElemento
    ;longitdFila= longitudElemento*cantidadColumnas
    sub rcx, rcx
    sub rax, rax
    sub rbx, rbx
    sub r10, r10
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
    
    mov rax, rsp
    and rax, 15
    je no_restar_rsp_1
    sub rsp, 8
no_restar_rsp_1:
    mov rdi, msjIngFilaColumnaOrigen
    call printf

    mov rdi, cadena      ; Dirección de 'cadena'
    call gets
    add rsp, 8

    ; Extraer el primer carácter (primer número)
    movzx rax, byte [cadena]     ; Cargar el primer carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posx_ini], al            ; Guardar el valor en 'posx_ini'
    
    cmp byte [posx_ini], 0
    je fin               ; Si es 0, salta a "fin de juego"
    
    ; Extraer el segundo carácter (segundo número)
    movzx rax, byte [cadena + 1] ; Cargar el segundo carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posy_ini], al            ; Guardar el valor en 'posy_ini'
    
    jmp validar_casillero_origen
    
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
    jmp es_destino_valido
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
    mov byte[turno], 0
    lea rax, [oficiales]          ; Cargar la dirección de 'soldados' en AX
    mov [jugadorActual], rax
    ret

es_impar:        
    mov byte[turno], 1
    lea rax, [soldados]          ; Cargar la dirección de 'soldados' en AX
    mov [jugadorActual], rax
    ret
    
asignar_jugador_inicial:
    lea rax, [soldados]          ; Cargar la dirección de 'soldados' en AX
    mov [jugadorActual], rax
    ret
    
validar_casillero_origen:
    ;;valido que este dentro del tablero
    sub rax, rax
    sub rbx, rbx
    mov al,[posx_ini]
    mov bl,[posy_ini]
    
    validar_dentro_x:
    cmp al, 1
    je validar_dentro_y
    cmp al, 2
    je validar_dentro_y
    cmp al, 6
    je validar_dentro_y
    cmp al, 7
    je validar_dentro_y
    jmp dentro_tablero_origen_ok
validar_dentro_y:
    cmp bl, 1
    je origen_invalido
    cmp bl, 2
    je origen_invalido
    cmp bl, 6
    je origen_invalido
    cmp bl, 7
    je origen_invalido
    jmp dentro_tablero_origen_ok
    
dentro_tablero_origen_ok:
    mov al, [turno]
    xor ah, ah        ; Limpiar AH para asegurar que AX está correcto

    ; Dividir AX entre el divisor (2)
    xor rbx, rbx        
    mov bl, [divisor]
    div bl            ; AX / BL -> AL = cociente, AH = resto

    ; Ahora, AH contiene el resto (turno % 2)
    cmp ah, 0         ; Compara el resto con 0
    je es_oficial_valido         ; Si el resto es 0, turno es par
    jmp es_soldado_valido ; Si no, turno es impar
    ret
    
es_soldado_valido:
;busco el elemento en la matriz; y lo guardo en r10 para comparar el elemento.
    sub rcx, rcx
    sub rax, rax
    sub rbx, rbx
    sub r10, r10
    mov al,[posx_ini] 
    mov r8, cantidadFilas
    imul r8
    add rcx,rax
    
    mov al,[posy_ini]
    mov r8, longitudElemento 
    imul r8
    add rcx,rax
    
    mov rbx,matriz 
    add rbx,rcx ;me posicione en la matriz

    mov r10, [rbx] ;guardo un elemento
    cmp r10b, 'X'
    je turno_soldado_ok
    ;sino fue un mal ingreso:
origen_invalido:
    mov rdi, casilleroInvalido
    sub rsp, 8
    call printf
    add rsp, 8
    jmp pedir_casillero_origen
turno_soldado_ok:
    ret
    
es_oficial_valido:
;busco el elemento en la matriz; y lo guardo en r10 para comparar el elemento.
    sub rcx, rcx
    sub rax, rax
    sub rbx, rbx
    sub r10, r10
    mov al,[posx_ini] 
    mov r8, cantidadFilas
    imul r8
    add rcx,rax
    
    mov al,[posy_ini]
    mov r8, longitudElemento 
    imul r8
    add rcx,rax
    
    mov rbx,matriz 
    add rbx,rcx ;me posicione en la matriz

    mov r10, [rbx] ;guardo un elemento
;;
    cmp r10b, 'O'
    je turno_oficial_ok
    ;sino fue un mal ingreso:
    mov rdi, casilleroInvalido
    sub rsp, 8
    call printf
    add rsp, 8
    jmp pedir_casillero_origen
    turno_oficial_ok:
    ret    
    
    
es_destino_valido:
    ;;valido que este dentro del tablero
    sub rax, rax
    sub rbx, rbx
    mov al,[posx_fin]
    mov bl,[posy_fin]
    
validar_dentro_x_fin:
    cmp al, 1
    je validar_dentro_y_fin
    cmp al, 2
    je validar_dentro_y_fin
    cmp al, 6
    je validar_dentro_y_fin
    cmp al, 7
    je validar_dentro_y_fin
    jmp dentro_tablero_destino_ok
validar_dentro_y_fin:
    cmp bl, 1
    je destino_invalido
    cmp bl, 2
    je destino_invalido
    cmp bl, 6
    je destino_invalido
    cmp bl, 7
    je destino_invalido
    jmp dentro_tablero_destino_ok
    
dentro_tablero_destino_ok:
;busco el elemento en la matriz; y lo guardo en r10 para comparar el elemento.
    sub rcx, rcx
    sub rax, rax
    sub rbx, rbx
    sub r10, r10
    mov al,[posx_fin] 
    mov r8, cantidadFilas
    imul r8
    add rcx,rax
    
    mov al,[posy_fin]
    mov r8, longitudElemento 
    imul r8
    add rcx,rax
    
    mov rbx,matriz 
    add rbx,rcx ;me posicione en la matriz

    mov r10, [rbx] ;guardo un elemento
;;
    cmp r10b, ' '
    je destino_ok
    ;sino fue un mal ingreso:
destino_invalido:
    mov rdi, casilleroInvalido
    sub rsp, 8
    call printf
    add rsp, 8
    jmp pedir_casillero_destino
destino_ok:
    ret    
validar_movimiento_oficial:
;;falta resolver esto -> solo de a 1 en cualqeuir dir.
    mov r12,0
    mov rax,0
    mov al, [posx_ini]
    mov ah, [posx_fin]
    sub al,ah

    mov rdx,0
    mov dl, [posy_ini]
    mov dh, [posy_fin]
    sub dl,dh

    cmp al, 0
    je validar_movimientos_oficial_horizontal ;;listo
    cmp al, 1
    je validar_movimiento_simple_oficial_arriba_abajo ;;listo
    cmp al,-1
    je validar_movimiento_simple_oficial_arriba_abajo ;;listo
    
    cmp al, 2
    je validar_movimiento_doble_oficial_superiores ;;voy a validar esto
    cmp al,-2
    je validar_movimiento_doble_oficial_inferiores ;;falta validar
    
;;esto valida OK movimientos simples y dobles horizontales (falta validar dobles horizontales)
validar_movimientos_oficial_horizontal:
    ;;movimiento simple
    cmp dl, 1
    je movimiento_oficial_ok
    cmp dl,-1
    je movimiento_oficial_ok
    ;;movimiento doble (comio)
    cmp dl, 2
    je validar_movimiento_doble_izquierda ;; aca falta validar que haya X en el medio
    cmp dl,-2
    je validar_movimiento_doble_derecha ;; aca falta validar que haya X en el medio
;funcion ready (no necesita nada mas)
validar_movimiento_simple_oficial_arriba_abajo:
    ;;si se movio 1 en x, solo puede ser movimiento simple
    cmp dl, 1
    je movimiento_oficial_ok
    cmp dl,-1
    je movimiento_oficial_ok
    cmp dl, 0
    je movimiento_oficial_ok
    jmp movimiento_oficial_invalido

;;movimientos dobles!
validar_movimiento_doble_oficial_superiores:
    cmp dl, 2
    je validar_movimiento_doble_izquierda_superior
    cmp dl,-2
    je validar_movimiento_doble_derecha_superior
    cmp dl, 0
    je validar_movimiento_doble_superior
    jmp movimiento_oficial_invalido

validar_movimiento_doble_oficial_inferiores:
    cmp dl, 2
    je validar_movimiento_doble_izquierda_inferior
    cmp dl,-2
    je validar_movimiento_doble_derecha_inferior
    cmp dl, 0
    je validar_movimiento_doble_inferior
    jmp movimiento_oficial_invalido
    
;;tengo que validar que haya una X en los movimientos dobles
;;voy a setear una posicion posx - posy para buscar elemento en la matriz
;;si hay una X efectivamente habia un soldado -> eliminar soldado -> movimiento ok!
;;else invalido.

;;hasta este momento en ah y dh estan los valores x y destino respectivamente
validar_movimiento_doble_izquierda:
    inc dh
    jmp validar_habia_soldado_en_movimiento_doble
validar_movimiento_doble_derecha:
    dec dh
    jmp validar_habia_soldado_en_movimiento_doble
validar_movimiento_doble_izquierda_superior:
    inc dh
    inc ah
    jmp validar_habia_soldado_en_movimiento_doble
validar_movimiento_doble_superior:
    inc ah
    jmp validar_habia_soldado_en_movimiento_doble
validar_movimiento_doble_derecha_superior:
    dec dh
    inc ah
    jmp validar_habia_soldado_en_movimiento_doble
validar_movimiento_doble_izquierda_inferior:
    inc dh
    dec ah
    jmp validar_habia_soldado_en_movimiento_doble
validar_movimiento_doble_inferior:
    dec ah
    jmp validar_habia_soldado_en_movimiento_doble
validar_movimiento_doble_derecha_inferior:
    dec dh
    dec ah
    jmp validar_habia_soldado_en_movimiento_doble


;;falta estar seguro de lo que hago aca. (validar X e Y..)
validar_habia_soldado_en_movimiento_doble:
    
    sub rbx, rbx
    mov bl, ah      
    sub rax, rax      
    mov al, bl

    sub rbx, rbx
    mov bl, dh
                
    sub rcx, rcx
    sub rdx, rdx
    sub r8, r8
    sub r10, r10
    
 
    mov r8, cantidadFilas
    imul r8
    add rcx,rax
    
    mov al, bl
    mov r8, longitudElemento 
    imul r8
    add rcx,rax
    
    sub rbx, rbx   
    mov rbx,matriz 
    add rbx,rcx ;me posicione en la matriz

    mov r10, [rbx] ;guardo un elemento
    cmp r10b, 'X'
    je movimiento_oficial_ok
    jmp movimiento_oficial_invalido

;;fin;; validaciones terminan en estas 2 funciones.
movimiento_oficial_ok:
    
    mov r9, [rbx+1] ;guardo en r9 lo que le sigue de matriz posterior al elemento a actualizar
    mov r8, " " ; lo muevo a un reg para darle (y estar seguro de su) longitud
    mov [rbx],r8 ;muevo el valor(de igual longitud). muevo a la posicion de la matriz a actualizar
    
    ;despues de agregar el nuevo valor, agregarle el resto de la matriz que estaba antes.
    mov [rbx+1],r9

    mov r12,0
    ret
movimiento_oficial_invalido:
    mov rdi,msj_movimiento_oficial_invalido
    sub rsp, 8
    call printf
    add rsp,8
    
    mov r12,1
    ret

movimiento_soldado_invalido:
    mov rax, rsp
    and rax, 15
    je no_restar_rsp
    sub rsp, 8
no_restar_rsp:
    mov rdi,msj_movimiento_soldado_invalido
    call printf
    add rsp,8
    jmp pedir_movimiento

movimiento_soldado_valido:
    jmp prox_turno

eliminar_oficial_desentendido:
    ;dec r14
    ret

verificar_ganador:
    cmp r14, 0
    je ganaron_soldados_por_falta_oficiales
verificar_invasion:
    sub rcx, rcx
    sub rax, rax
    sub rbx, rbx
    sub r10, r10
    mov al, 5
    mov r8, cantidadFilas
    imul r8
    add rcx,rax
    
    mov al, 3
    mov r8, longitudElemento 
    imul r8
    add rcx,rax
    
    mov rbx,matriz 
    add rbx,rcx ;me posicione en la matriz

;fila_5_fortaleza
    mov r10, [rbx] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza
    mov r10, [rbx+1] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza
    mov r10, [rbx+2] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza
;fila_6_fortaleza
    mov r10, [rbx+9] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza
    mov r10, [rbx+10] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza
    mov r10, [rbx+11] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza
;fila_7_fortaleza
    mov r10, [rbx+18] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza
    mov r10, [rbx+19] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza
    mov r10, [rbx+20] ;guardo un elemento
    cmp r10b, 'X'
    jne no_invadieron_la_fortaleza

    jmp ganaron_soldados_por_invasion
    
no_invadieron_la_fortaleza:
    ret

ganaron_soldados_por_falta_oficiales:
    mov rdi,msj_ganaron_soldados_por_falta_oficiales
    sub rsp, 8
    call printf
    add rsp,8
    jmp fin

ganaron_soldados_por_invasion:
    mov rdi,msj_ganaron_soldados_por_invasion
    sub rsp, 8
    call printf
    add rsp,8
    jmp fin