global	main
extern 	printf
extern  gets

extern  system

section .data
    msjIngFilaColumnaOrigen	db	'Ingrese Origen (0 para finalizar) [XY]: ',0
    msjIngFilaColumnaDestino	db	'Ingrese Destino [XY]: ',0

    esTurnoDe	db	'Es turno de los %s!',10,0
    oficiales   db 'oficiales',0
    soldados    db 'soldados',0
    jugadorActual db 'soldados',0
    casilleroInvalido db 'casillero invalido!',10,0
    msj_movimiento_oficial_invalido db 'movimiento de oficial invalido! Vuelva a intentarlo',10,0
    msj_movimiento_soldado_invalido db 'movimiento de soldado invalido! Vuelva a intentarlo',10,0

    msj_movimiento_oficial_desatendido db 'los oficiales no cumplieron con su deber! Se retira el oficial que no capturo.',10,0

    msj_ganaron_soldados_por_falta_oficiales db 'Ganaron los soldados, no hay mas oficiales que puedan defender la fortaleza!',10,0
    msj_ganaron_soldados_por_invasion db 'Ganaron los soldados, invadieron la fortaleza!',10,0
    msj_ganaron_oficiales_por_falta_soldados db 'Ganaron los oficiales, ya no quedan mas soldados!',10,0

    endGame    db 'Fin del juego!',10,0
    cmd_clear db "clear",0
    matriz  db '~1234567',0
            db '1~|XXX|~',0
            db '2~|XXX|~',0
            db '3XXXXXXX',0
            db '4XXXXXXX',0
            db '5XX   XX',0
            db '6~|  O|~',0
            db '7~|O  |~',0
            db '--------',0
            
    turno db 1
    divisor db 2 
    
    saltoLinea  db 10, 0     ; Salto de línea al final de cada fila     
    posicion    db 0

    longitudElemento equ	1
    cantidadColumnas equ 8
    cantidadFilas    equ	9
    
    posx_ini db 1
    posy_ini db 1
    
    posx_fin db 1
    posy_fin db 1

section .bss    
    cadena resb 2

section .text
main:
    mov rbp, rsp; for correct debugging
    mov r11, 0 ;seteo flag de que no eliminaron oficiales
    push r11   ;lo guardo porque el r11 se pisa en algunas funciones.
    mov r14, 2 ;seteo cantidad de oficiales.
    jmp asignar_jugador_inicial
ciclo_juego:
    call mostrar_tablero
    jmp mostrar_jugador_actual
pedir_movimiento:
    jmp pedir_casillero_origen
pedir_movimiento_destino:
    jmp pedir_casillero_destino
validar_movimiento:
    mov al, [turno]
    cmp al, 1
    je validar_movimiento_soldado
    jmp validar_movimiento_oficial ;hace esto solo si es el turno del oficial.
fin_validacion_movimiento_oficial:
    cmp r12, 0                  ; Si la validacion esta mal -> r12 != 0 -> volver a pedir origen-destin0
    jne pedir_movimiento         ; Si no es 0 -> back to pedir_movimiento
    jmp validar_desatendido     ;si el movimiento esta oka, valida que no haya desatendidos
;preparo proximo turno.
prox_turno:
    jmp actualizar_tablero
fin_actualizar_tablero:
    jmp actualizar_turno
fin_actualizar_turno:
    jmp verificar_ganador
fin_verificar_ganador:
    jmp ciclo_juego      ;Repite el bucle principal del juego.
        
fin:
    mov rdi, endGame
    sub rsp, 8
    call printf
    add rsp,8
    ret

mostrar_tablero:
;clear_screen:
    mov rax, rsp
    and rax, 15
    je no_restar_rsp_3
    ;aca al hacer un call a funciones, el rsp no quedaba bien y el ret volvio a cualquier lado o rompia
    ;por lo tanto tenia que verificar que el rsp sea multiplo de 16 antes de restar.
    ;se decidio eliminar los calls a funciones que se llaman una sola vez y algunos "no_restar_rsp" quedaron en el codigo.
    sub rsp, 8
    mov rdi, cmd_clear
    call system
    add rsp, 8
    jmp saltar_a_mostrar_tablero
no_restar_rsp_3:
    mov rdi, cmd_clear
    call system
saltar_a_mostrar_tablero:
    mov rax, 0
    mov [posicion], rax 
    mov rcx, cantidadColumnas
    sub rsp, 8
    fila_loop:
        push rcx ;es necesario para loop, sino el registro rcx se pisa y loopea infinito
        ; Carga la dirección de la fila actual en la matriz e imprime la fila
        mov rdi, matriz
        add rdi, [posicion]
        sub rax, rax           ; Limpia rax para printf, evita seg fault
        call printf
        ; Imprime salto de línea después de cada fila
        mov rdi, saltoLinea
        xor rax, rax           ; Limpia rax para printf, evita seg fault
        call printf
        pop rcx ;es necesario para loop, sino el registro rcx se pisa y loopea infinito
        
        mov rax, [posicion]         
        add rax, cantidadFilas
        mov [posicion], rax         ; posicion apunta a la siguiente fila
        
        loop fila_loop
        
        mov rdi, saltoLinea
        xor rax, rax           ; Limpia rax para printf, evita seg fault
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
                    ;ya que posx es db (byte= 8bits) sino guarda mal
;    sub rax,1 -> no es necesaria la resta ya que la matriz empieza en 1,1
    mov r8, cantidadFilas
    imul r8   ;me desplazo en la fila
    add rcx,rax
    
    mov al,[posy_ini] ;guardo el valor de la col,
;    sub rax,1 -> no es necesaria la resta ya que la matriz empieza en 1,1
    mov r8, longitudElemento ;guardo en r8 para darle longitud y poder multiplicar usando imul
    imul r8 ;me desplazo en la columna
    add rcx,rax ;sumo los desplazamientos
    
    
    mov rbx,matriz ;pongo el pto al inicio de la matriz
    add rbx,rcx ;me posicione en la matriz

    mov r10, [rbx] ;guardo un elemento
    mov r9, [rbx+1] ;guardo en r9 lo que le sigue de matriz posterior al elemento a actualizar
    mov r8, " " ; lo muevo a un reg para darle (y estar seguro de su) longitud
    mov [rbx],r8 ;muevo el valor(de igual longitud). muevo a la posicion de la matriz a actualizar (guardo un " " en el origen ya que el elemento se va del origen)
    
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
;    sub rax,1 -> no es necesaria la resta ya que la matriz empieza en 1,1
    mov r8, longitudElemento ;guardo en r8 para darle longitud y poder multiplicar usando imul
    imul r8 ;me desplazo en la columna
    add rcx,rax ;sumo los desplazamientos
    
    
    mov rbx,matriz ;pongo el pto al inicio de la matriz
    add rbx,rcx ;me posicione en la matriz

    mov r9, [rbx+1] ;guardo en r9 lo que le sigue de matriz posterior al elemento a actualizar
    mov r8, r10 ; lo muevo a un reg para darle (y estar seguro de su) longitud
    mov [rbx],r8 ;muevo el valor(de igual longitud). muevo a la posicion de la matriz a actualizar (el elemento origen se guarda en el casillero destino)
    
    ;despues de agregar el nuevo valor, agregarle el resto de la matriz que estaba antes.
    mov [rbx+1],r9

    ;logica de borrar_oficial solo si fue turno de oficiales!
    mov al, [turno]
    cmp al, 1 ; =1 -> estamos en turno de soldados
    je validar_si_oficial_debe_comer_prox_turno ;esto deja en r13: 1 si pueden comer, 0 si no pueden comer.
    jmp fin_actualizar_tablero

validar_desatendido:
    ;r15 
        ;1 si oficial capturo en el turno en curso, 
        ;0 si oficial no capturo
    ;r13
        ;1 si oficiales podian capturar
        ;0 si oficiales no podian capturar
    ;r13+r15
    ;0+0=0       ok -> no hay desatendidos 
    ;0+1=1       eliminar oficial -> solo en este caso se borrara el oficial que se movio y no capturo.
    ;1+0=1       no deberia darse nunca este caso, ya que no podian capturar
    ;1+1=2       ok -> no hay desatendidos

    add r15, r13
    cmp r15, 1
    je borrar_oficial
    mov r11, 0 ;reseteo r11, indicador de que eliminaron un oficial ya que no lo hicieron este turno.
    push r11
    jmp actualizar_tablero  ;como no borra oficiales, tiene que actualizar el tablero (mover el elemento origen a destino, en este caso al oficial)
fin_validar_desatendido:
    jmp fin_actualizar_tablero ;luego de borrar no necesita actualizar tablero, ya que borrar_oficial cumple esa funcion
    
pedir_casillero_origen:
    mov rax, rsp
    and rax, 15
    je no_restar_rsp_1
    sub rsp, 8
no_restar_rsp_1:
    mov rdi, msjIngFilaColumnaOrigen
    call printf
    mov rdi, cadena
    call gets
    add rsp, 8

    ; Extraer el primer carácter (primer número)
    movzx rax, byte [cadena]     ; Cargar el primer carácter (8bits) de 'cadena' en rax y completa rax con 0 (menos el bit menos significativo).
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posx_ini], al           ; Guardar el valor en 'posx_ini'
    
    cmp byte [posx_ini], 0
    je fin               ; Si es 0, salta a "fin de juego"
    
    ; Extraer el segundo carácter (segundo número)
    movzx rax, byte [cadena + 1] ; Cargar el segundo carácter de 'cadena' en rax
    sub rax, '0'                 ; Convertir de ASCII a valor numérico
    mov [posy_ini], al           ; Guardar el valor en 'posy_ini'
    
    jmp validar_casillero_origen
    
pedir_casillero_destino:
    sub rsp, 8
    mov rdi, msjIngFilaColumnaDestino
    call printf
    add rsp, 8

    mov rdi, cadena
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
    
mostrar_jugador_actual:
    pop r11     
    cmp r11, 1  ;si r11=1 -> en el turno anterior se elimino a un oficial.
    je mostrar_eliminacion_de_oficial ;imprime mensaje
fin_mostrar_eliminacion_de_oficial:
    ;mostrar de quien es el turno
    sub rsp, 8
    mov rdi, esTurnoDe
    mov rsi, [jugadorActual]
    call printf
    add rsp, 8
    jmp pedir_movimiento
    
mostrar_eliminacion_de_oficial:
    sub rsp, 8
    mov rdi, msj_movimiento_oficial_desatendido
    call printf
    add rsp, 8
    jmp fin_mostrar_eliminacion_de_oficial

actualizar_turno:
    mov al, [turno]
    add byte [turno], 1
    mov al, [turno]
    xor ah, ah

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
    lea rax, [oficiales]          ; Cargar la dirección de 'oficiales' en AX
    mov [jugadorActual], rax
    jmp fin_actualizar_turno

es_impar:        
    mov byte[turno], 1
    lea rax, [soldados]          ; Cargar la dirección de 'soldados' en AX
    mov [jugadorActual], rax
    jmp fin_actualizar_turno
    
asignar_jugador_inicial:
    lea rax, [soldados]          ; Cargar la dirección de 'soldados' en AX, ya que empiezan ellos
    mov [jugadorActual], rax
    jmp ciclo_juego
    
validar_casillero_origen:
    ;;valido que este dentro del tablero
    sub rax, rax
    sub rbx, rbx
    mov al,[posx_ini]
    mov bl,[posy_ini]
    
    ;podria usar jge, jle
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
    jmp es_soldado_valido        ; Si no, turno es impar
    
es_soldado_valido: ;hay una X en el origen?
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
    add rbx,rcx 

    mov r10, [rbx] ;guardo un elemento
    cmp r10b, 'X'  ;hay un soldado en el origen?
    je turno_soldado_ok
    ;sino fue un mal ingreso:
origen_invalido:
    mov rdi, casilleroInvalido
    sub rsp, 8
    call printf
    add rsp, 8
    jmp pedir_casillero_origen
turno_soldado_ok:
    jmp pedir_movimiento_destino
    
es_oficial_valido: ;hay una O en el origen?
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
    cmp r10b, 'O' ;hay una X en el origen?
    je turno_oficial_ok
    ;sino fue un mal ingreso:
    mov rdi, casilleroInvalido
    sub rsp, 8
    call printf
    add rsp, 8
    jmp pedir_casillero_origen
turno_oficial_ok:
    jmp pedir_movimiento_destino    
    
    
es_destino_valido:
    ;;valido que este dentro del tablero
    sub rax, rax
    sub rbx, rbx
    mov al,[posx_fin]
    mov bl,[posy_fin]
    
    ;podria usar jge, jle
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
    cmp r10b, ' ' ;el casillero destino tiene que ser un espacio en blanco.
    je destino_ok
    ;sino fue un mal ingreso:
destino_invalido:
    mov rdi, casilleroInvalido
    sub rsp, 8
    call printf
    add rsp, 8
    jmp pedir_casillero_destino
destino_ok:
    jmp validar_movimiento    
validar_movimiento_oficial:
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
    je validar_movimientos_oficial_horizontal
    cmp al, 1
    je validar_movimiento_simple_oficial_arriba_abajo 
    cmp al,-1
    je validar_movimiento_simple_oficial_arriba_abajo 
    
    cmp al, 2
    je validar_movimiento_doble_oficial_superiores 
    cmp al,-2
    je validar_movimiento_doble_oficial_inferiores 
    
;;esto valida OK movimientos simples y dobles horizontales
validar_movimientos_oficial_horizontal:
    ;;movimiento simple
    cmp dl, 1
    je movimiento_oficial_ok
    cmp dl,-1
    je movimiento_oficial_ok
    ;;movimiento doble (captura)
    cmp dl, 2
    je validar_movimiento_doble_izquierda 
    cmp dl,-2
    je validar_movimiento_doble_derecha 

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
    add rbx,rcx 

    mov r10, [rbx] ;guardo un elemento
    cmp r10b, 'X' ;habia una X en el medio?
    je oficial_realizo_captura
    jmp movimiento_oficial_invalido ;si no capturo, el movimiento doble es invalido

oficial_realizo_captura:
    mov r15, 1 ;seteo r15=1, es decir que capturo en su turno.
    jmp movimiento_oficial_ok
;;fin validacion movimientos dobles del oficial

movimiento_oficial_ok:
    
    mov r9, [rbx+1] ;guardo en r9 lo que le sigue de matriz posterior al elemento a actualizar
    mov r8, " " ; lo muevo a un reg para darle (y estar seguro de su) longitud
    mov [rbx],r8 ;muevo el valor(de igual longitud). muevo a la posicion de la matriz a actualizar
    
    ;despues de agregar el nuevo valor, agregarle el resto de la matriz que estaba antes.
    mov [rbx+1],r9
    mov r12,0 ;si r12=0, movimiento OK

termina_turno_oficiales:
    jmp fin_validacion_movimiento_oficial
borrar_oficial:
;voy a la posicion destino y borro el "O"
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
    
    dec r14 ;descuento un oficial
    mov r11, 1 ;r11=1 -> indicar que tengo que imprimir mensaje que borre un oficial.
    push r11
    jmp fin_validar_desatendido

movimiento_oficial_invalido:
    mov rdi,msj_movimiento_oficial_invalido
    sub rsp, 8
    call printf
    add rsp,8
    
    mov r12,1
    jmp fin_validacion_movimiento_oficial

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
    mov r15, 0 ;reseteo r15 antes que jueguen los oficiales
    mov r11, 0 ;reseteo r11, indicador de que eliminaron un oficial ya que no lo hicieron este turno.
    push r11   ;guardo r11 ya que se pisa entre funciones.
    jmp prox_turno

validar_si_oficial_debe_comer_prox_turno:
    ;encontrar oficiales (solo con el desplazamiento)
    sub rcx, rcx
    sub rdx, rdx ;voy a guardar la cantidad de oficiales a buscar/encontrados
    sub rax, rax
    sub rbx, rbx
    sub r10, r10

    cmp r14, 1
    je buscar_un_solo_oficial ;si hay un solo oficial modifico rdx
buscar_oficial_en_matriz:
    mov rbx,matriz ;pongo el pto al inicio de la matriz
actualizo_indice:
    mov r10, [rbx] ;guardo el elemento
    cmp r10b, 'O'  ;verifico si es un oficial
    je revisar_si_oficial_puede_comer ;valido si puede comer en alguna direccion
buscar_proximo_oficial:
    cmp rdx, 2 ;si ya encontre a los 2.
    je fin_actualizar_tablero ;funcion dentro de actualizar tablero, al terminar va a fin_actualizar_tablero.

    inc rbx
    jmp actualizo_indice ;sigo buscando por oficiales 'O'
buscar_un_solo_oficial:
    inc rdx 
    jmp buscar_oficial_en_matriz

;valido si puede comer en alguna direccion (de todas las disponibles)
revisar_si_oficial_puede_comer:
    inc rdx
    ;tengo en rbx la matriz en el indice del oficial.
revisar_celda_derecha:
    mov r10, [rbx+1]; +1 = a la derecha de la posicion actual
    cmp r10b, 'X' ;tiene que haber una X a distancia 1
    je revisar_captura_derecha
    jmp revisar_celda_abajo_derecha
revisar_captura_derecha:
    mov r10, [rbx+2] ;+2 = a la derecha 2posiciones de la posicion actual
    cmp r10b, ' ' ;tiene que haber un espacio a distancia 2
    je oficiales_pueden_comer

revisar_celda_abajo_derecha:
    mov r10, [rbx+10]; +10 = a la derecha abajo de la posicion actual
    cmp r10b, 'X'
    je revisar_captura_abajo_derecha
    jmp revisar_celda_abajo
revisar_captura_abajo_derecha:
    mov r10, [rbx+20] ;+20 = a la derecha abajo 2posiciones de la posicion actual
    cmp r10b, ' '
    je oficiales_pueden_comer

revisar_celda_abajo:
    mov r10, [rbx+9]; +9 = abajo de la posicion actual
    cmp r10b, 'X'
    je revisar_captura_abajo
    jmp revisar_celda_abajo_izquierda
revisar_captura_abajo:
    mov r10, [rbx+18] ;+18 = abajo 2posiciones de la posicion actual
    cmp r10b, ' '
    je oficiales_pueden_comer

revisar_celda_abajo_izquierda:
    mov r10, [rbx+8]
    cmp r10b, 'X'
    je revisar_captura_abajo_izquierda
    jmp revisar_celda_izquierda
revisar_captura_abajo_izquierda:
    mov r10, [rbx+16]
    cmp r10b, ' '
    je oficiales_pueden_comer

revisar_celda_izquierda:
    mov r10, [rbx-1]
    cmp r10b, 'X'
    je revisar_captura_izquierda
    jmp revisar_celda_arriba_izquierda
revisar_captura_izquierda:
    mov r10, [rbx-2]
    cmp r10b, ' '
    je oficiales_pueden_comer

revisar_celda_arriba_izquierda:
    mov r10, [rbx-10]
    cmp r10b, 'X'
    je revisar_captura_arriba_izquierda
    jmp revisar_celda_arriba
revisar_captura_arriba_izquierda:
    mov r10, [rbx-20]
    cmp r10b, ' '
    je oficiales_pueden_comer

revisar_celda_arriba:
    mov r10, [rbx-9]
    cmp r10b, 'X'
    je revisar_captura_arriba
    jmp revisar_celda_arriba_derecha
revisar_captura_arriba:
    mov r10, [rbx-18]
    cmp r10b, ' '
    je oficiales_pueden_comer

revisar_celda_arriba_derecha:
    mov r10, [rbx-8]
    cmp r10b, 'X'
    je revisar_captura_arriba_derecha
    jmp oficiales_no_pueden_comer ;fin de validaciones
revisar_captura_arriba_derecha:
    mov r10, [rbx-16]
    cmp r10b, ' '
    je oficiales_pueden_comer

oficiales_no_pueden_comer:
    cmp rdx, 1
    je buscar_proximo_oficial ;si rdx=1 tengo que buscar otro oficial
    mov r13, 0 ;se resetea siempre antes que jueguen oficiales
    jmp fin_actualizar_tablero
    
oficiales_pueden_comer:
    mov r13, 1 ;seteo r13=1 porque pueden comer en el proximo turno. (se resetea siempre antes que jueguen oficiales)
    jmp fin_actualizar_tablero

verificar_ganador:
    cmp r14, 0 ;r14 contiene la cantidad de oficiales en el tablero.
    je ganaron_soldados_por_falta_oficiales
verificar_invasion: ;chequeo si la fortaleza esta llena de soldados
    sub rcx, rcx
    sub rax, rax
    sub rbx, rbx
    sub r10, r10
    mov al, 5 ;inicio de fortaleza X
    mov r8, cantidadFilas
    imul r8
    add rcx,rax
    
    mov al, 3 ;inicio de fortaleza Y
    mov r8, longitudElemento 
    imul r8
    add rcx,rax
    
    mov rbx,matriz 
    add rbx,rcx 

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

;verificar_falta_soldados:
    sub rcx, rcx
    sub rdx, rdx
    sub rax, rax
    sub rbx, rbx
    sub r10, r10

buscar_soldados_en_matriz:
    mov rbx,matriz 
actualizo_indice_2:
    mov r10, [rbx] 
    cmp r10b, 'X' ;si matchea una X, aun quedan soldados
    je aun_quedan_soldados
    cmp rdx, 69 ;indice de fin de fortaleza (pasando 73)
    jge ganaron_oficiales_por_falta_soldados
    inc rbx
    inc rdx
    jmp actualizo_indice_2
;;
aun_quedan_soldados:
    jmp fin_verificar_ganador

ganaron_soldados_por_falta_oficiales:
    call mostrar_tablero
    mov rax, rsp
    and rax, 15
    je no_restar_rsp_fin_falta
    sub rsp, 8
no_restar_rsp_fin_falta:
    mov rdi, msj_movimiento_oficial_desatendido
    call printf
    
    mov rdi,msj_ganaron_soldados_por_falta_oficiales
    call printf
    add rsp,8
    jmp fin

ganaron_soldados_por_invasion:
    call mostrar_tablero
    mov rax, rsp
    and rax, 15
    je no_restar_rsp_fin_invasion
    sub rsp, 8
no_restar_rsp_fin_invasion:
    mov rdi,msj_ganaron_soldados_por_invasion
    call printf
    add rsp,8
    jmp fin

ganaron_oficiales_por_falta_soldados:
    call mostrar_tablero
    mov rax, rsp
    and rax, 15
    je no_restar_rsp_falta_soldados
    sub rsp, 8
no_restar_rsp_falta_soldados:
    mov rdi, msj_ganaron_oficiales_por_falta_soldados
    call printf
    add rsp,8
    jmp fin



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
    je movimiento_soldado_valido
    cmp dh, 4
    je movimiento_soldado_valido
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_arriba_en_fortaleza_columna_cuatro:
    cmp dh, 3
    je movimiento_soldado_valido
    cmp dh, 4
    je movimiento_soldado_valido
    cmp dh, 5
    je movimiento_soldado_valido
    jmp movimiento_soldado_invalido

validar_movimiento_soldado_arriba_en_fortaleza_columna_cinco:
    cmp dh, 4
    je movimiento_soldado_valido
    cmp dh, 5
    je movimiento_soldado_valido
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