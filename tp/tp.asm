global main
extern printf

section .data
    msjSal         db '%c ', 0   ; Format for printing a single character with space
    msjNewLine     db 10, 0      ; Newline for each row

    ; Define a 7x7 matrix filled with 'X' (ASCII 88)
    matriz times 49 db 'X'  ; 7 * 7 = 49 characters

    CANT_FIL       db 7
    CANT_COL       db 7

section .text
main:
    sub rsp, 8                ; Reserve stack space if necessary

    mov rcx, 0                ; rcx = row index
outer_loop:
    cmp rcx, CANT_FIL         ; Check if we've processed all rows
    jge end_program           ; Exit if we've finished all rows

    mov rdx, 0                ; rdx = column index
inner_loop:
    cmp rdx, CANT_COL         ; Check if we've processed all columns in this row
    jge end_row               ; Move to the next row if we've finished this row

    ; Calculate the offset in the matrix: offset = (row * CANT_COL) + col
    mov rax, rcx              ; rax = row index
    imul rax, CANT_COL        ; rax = row * CANT_COL
    add rax, rdx              ; rax = (row * CANT_COL) + col (final offset)

    ; Print the character at matriz[rax]
    mov rdi, msjSal           ; Format string for single character
    movzx rsi, byte [matriz + rax] ; Get character 'X' from the matrix
    call printf

    inc rdx                   ; Move to the next column
    jmp inner_loop            ; Repeat inner loop

end_row:
    ; Print newline after each row
    mov rdi, msjNewLine
    call printf

    inc rcx                   ; Move to the next row
    jmp outer_loop            ; Repeat outer loop

end_program:
    add rsp, 8                ; Restore stack space
    ret