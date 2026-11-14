[org 0x7c00]
[bits 16]

start:
    push sp
    push ss
    push gs
    push fs
    push es
    push ds
    push bp
    push di
    push si
    push dx
    push cx
    push bx
    push ax

    mov ah, 0x0e
    mov cx, 13
    mov si, registers
    loop:
    lodsb
    int 0x10
    lodsb
    int 0x10
    mov al, ':'
    int 0x10
    mov al, ' '
    int 0x10
    pop bx
    mov al, bh
    shr al, 4
    cmp al, 0x0A
    jc skipAddition
    add al, 0x07
    skipAddition:
    add al, 0x30
    int 0x10
    mov al, bh
    and al, 0x0F
    cmp al, 0x0A
    jc skipAddition2
    add al, 0x07
    skipAddition2:
    add al, 0x30
    int 0x10
    mov al, bl
    shr al, 4
    cmp al, 0x0A
    jc skipAddition3
    add al, 0x07
    skipAddition3:
    add al, 0x30
    int 0x10
    mov al, bl
    and al, 0x0F
    cmp al, 0x0A
    jc skipAddition4
    add al, 0x07
    skipAddition4:
    add al, 0x30
    int 0x10
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    loop loop

registers: db "AXBXCXDXSIDIBPDSESFSGSSSSP", 0

%ifndef NOPAD
times 510 - ($ - $$) db 0
dw 0xAA55
%endif
