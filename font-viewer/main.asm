[org 0x7c00]
[bits 16]

start:
    mov ax, 0x13
    int 0x10

    mov ax, 0x1130
    mov bh, 0x03
    int 0x10

    mov bh, 128
    mov cx, 25
    mov ax, es
    mov ds, ax
    mov si, bp
    mov ax, 0xA000
    mov es, ax
    loop:
    push cx
    mov cx, 40
    loop_line:
    push cx
    mov cx, 8
    loop_line_row:
    push cx
    mov cx, 8
    mov bl, 7
    lodsb
    loop_line_row_pixel:
    push cx
    mov cl, bl
    mov dl, al
    shr dl, cl
    and dl, 1
    jz loop_line_row_pixel_end
    mov cl, 15
    mov [es:di], cl
    loop_line_row_pixel_end:
    dec bl
    inc di
    pop cx
    loop loop_line_row_pixel
    add di, 312
    pop cx
    loop loop_line_row
    add di, 62984
    dec bh
    jz halt
    pop cx
    loop loop_line
    add di, 2240
    pop cx
    loop loop

    halt:
    cli
    hlt
    jmp $

%ifndef NOPAD
times 510 - ($ - $$) db 0
dw 0xAA55
%endif
