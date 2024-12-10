        .text                            @ Indica que los siguientes
                                          @ ítems en memoria son 
                                        @ instrucciones
start:
        mov     r0, #15                 @ Seteo de parámetros
        mov     r1, #20
        bl      func                    @ Llamado a subrutina
        swi     0x11                    @ Fin de programa
func:                                    @ Subrutina
        add     r0, r0, r1              @ r0 = r0 + r1
        mov     pc, lr                  @ Retornar desde subrutina
        .end                             @ Marcar fin de archivo
