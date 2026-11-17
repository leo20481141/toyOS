[org 0x7c00]
[bits 16]

start:
    mov ax, 0x13
    int 0x10

    mov ax, 0x1130
    mov bh, 0x03
    int 0x10

    mov ax, 0xA000
    mov fs, ax
    mov di, 30844
    mov si, msg
    mov cl, 9
    gameoverLoop:
    lodsb
    xor ah, ah
    shl ax, 3
    add bp, ax
    push cx
    call drawLetter
    pop cx
    sub bp, ax
    loop gameoverLoop

    jmp $

drawLetter:
    mov cl, 8
    drawLetter_column:
    push cx
    mov cl, 8
    mov bl, [es:bp]
    inc bp
    inc ax
    drawLetter_column_row:
    mov dl, bl
    dec cx
    shr dl, cl
    inc cx
    and dl, 1
    jz drawLetter_column_row_end
    mov dl, 15
    mov [fs:di], dl
    drawLetter_column_row_end:
    inc di
    loop drawLetter_column_row
    add di, 312
    pop cx
    loop drawLetter_column
    add di, 62984
    ret

msg: db "GAME OVER"

%ifndef NOPAD
times 510 - ($ - $$) db 0
dw 0xAA55
%endif
