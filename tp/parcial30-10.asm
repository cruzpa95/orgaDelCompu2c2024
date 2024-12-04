global	main
extern 	printf
extern  gets
extern	sscanf
extern	puts

section .data

;    tabla times 1040 db 1
    tabla times 1040 dw 1, 0
    f db '4'
    tex db "AB"
    c   db "CD"
    cont db 0
section .text
main:

    mov rbp, rsp; for correct debugging
   
    mov rax, 0
    mov rcx, 0
    mov cl, [f] ;4ascii = 52decimal
    mov esi,0
foo:
    add ax, [tabla+esi] ; +esi=0 -> primer columna 
                        ; ax = 16bits -> 2 bytes
    add si, 40 ;-> me muevo a la columna de abajo -> 40 posiciones, pero 2byte por posicion -> 20 columnas.
    loop foo ; rcx = 52 -> 52 filas
;;;;;;;;;;;;;;;;;;;;;;;
;El mismo programa continúa con la siguiente porción de código:
;;;;;;;
    mov dl,al   ;dl hexa? dl = 34 hexa (despues de esta linea)
    imul rax,2  ;ax hexa? ax = 0068 hexa (2bytes)
    mov dh, al  ;dh hexa? dh = 68 hexa


;;;El mismo programa continúa con la siguiente porción de código:
    ;dx = 6834 hexa (2bytes)
    mov [tex],dx    ;dx= 6834, 
                    ;antes del mov ->   tex = 41 42
                    ;despues del mov -> tex = 34 68 (se copia usando little endian)
;[tex] = 34 68 -> "4h" ;x/8xb &tex (para ver 8bytes en hexa cada byte)
;para ver tex: x/4b &tex (en decimal)
     
    
    mov rcx,1       ;rcx: 0001
    mov rsi, cont   ;cont = 00 (1byte), rsi 8bytes
    mov rdi, c      ;rdi = "CD", c = "CD" -> 43 44; rdi 8bytes -> x/4b &c (muestra en decimal)
    inc rdi         ;rdi = "D" , c = "CD" -> 43 44; con el inc avanza 1 byte en c, ahora rdi apunta a la 2da posicion de c.
    rep movsb       ;rdi = 0   , c = "C0" -> 43 00 ; luego de esta linea: guarda en c: 43 00 (c estaba en rdi)
    
    mov rdi, tex    ;tex = "4h" -> 34 68 (2bytes), pero rdi = 8bytes -> 
                        ;rdi apunta a la direccion tex, tex = 34 68, pero sigue agregando bytes, 
                            ;ya que  puts imprime hasta encontrar un 0.
                            
                    ;en memoria al iniciar el programa tenia:    
                    ;   tex db "AB" -> 65 66 (en decimal)
                    ;   c   db "CD" -> 67 68 (en decimal)
                    ;   cont db 0
                    
                    ;en memoria ahora tengo:
                    ;   tex 34 68 (en hexa)
                    ;   c   43 00 (en hexa)
                    ;   cont 0

                    ;por lo tanto se deberia imprimir: 34 68 43 en hexa a ascii: 4hC
    sub rsp, 8
    call puts   ;que imprime? -> 4hC
    add rsp, 8

    ret
