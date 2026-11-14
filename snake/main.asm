[org 0x7c00]
[bits 16]

%define drawingSums 0x7E00
%define direction 0x7FFA
%define fruit 0x7FFC
%define snakeParts_len 0x7FFE
%define snakeParts 0x8000
%define directionSums 0x9D40

start:
    xor ax, ax
    mov di, directionSums
    mov cl, 0xFF
    rep stosw

    mov di, directionSums + 0x90
    mov ax, 64256
    stosw
    stosw
    add ax, 1276
    stosw
    stosw
    mov ax, 4
    stosw
    add di, 6
    mov ax, 1280
    stosw

    mov ax, 0x13
    int 0x10

    mov al, 0x34
    out 0x43, al
    mov al, 0x55
    out 0x40, al
    mov al, 0x01
    out 0x40, al

    mov di, drawingSums
    mov cl, 4
    initDrawingSums:
    mov ax, 1
    stosw
    stosw
    stosw
    mov ax, 317
    stosw
    loop initDrawingSums

    startGame:
    mov ax, 0xA000
    mov es, ax
    xor di, di
    mov al, 24
    mov cx, 64000
    rep stosb

    xor ax, ax
    mov cl, 192
    mov di, 1284
    fillBlack:
    push cx
    mov cl, 156
    rep stosw
    add di, 8
    pop cx
    loop fillBlack

    out 0x43, al
    in al, 0x40
    mov ah, al
    in al, 0x40

    call numberToPosition
    push ax
    inc ax
    call numberToPosition

    mov [snakeParts], ax
    mov word [snakeParts_len], 1
    pop ax
    mov [fruit], ax
    mov word [direction], 4

    draw:
    mov ax, 0xA000
    mov es, ax
    mov cx, [snakeParts_len]
    mov si, snakeParts
    draw_snakePart:
    lodsw
    mov di, ax
    mov al, 15
    call drawSquare
    loop draw_snakePart

    mov al, 4
    mov di, [fruit]
    call drawSquare

    xor ax, ax
    int 0x1A
    mov bx, dx
    waitLoop:
    int 0x1A
    sub dx, bx
    sub dh, 0x03
    jc waitLoop

    mov ah, 1
    int 0x16
    jz after
    xor ax, ax
    int 0x16
    mov si, directionSums
    shr ax, 9
    shl ax, 2
    add si, ax
    lodsw
    test ax, ax
    jz after
    mov [direction], ax

    after:
    mov di, [snakeParts]
    add di, [direction]
    mov ax, di
    xor ax, [fruit]
    jz eatFruit
    mov al, [es:di]
    xor al, 24
    jz startGame
    mov cx, [snakeParts_len]
    mov si, snakeParts
    colissionWithItself:
    lodsw
    xor ax, di
    jz startGame
    loop colissionWithItself

    push di
    xor di, ax
    xor al, al
    call drawSquare
    jmp moveMemory

    eatFruit:
    int 0x1A
    mov ax, dx
    call numberToPosition
    mov [fruit], ax

    push di
    inc word [snakeParts_len]

    moveMemory:
    pop ax

    mov cx, [snakeParts_len]
    dec cx
    mov di, snakeParts
    add di, cx
    add di, cx
    mov si, di
    dec si
    dec si

    xor dx, dx
    mov es, dx
    std
    rep movsw
    stosw
    cld
    jmp draw

    halt:
    cli
    hlt
    jmp $

drawSquare:
    pusha
    push ax
    mov si, drawingSums
    mov cx, 16
    drawSquare_pixel:
    pop ax
    mov [es:di], al
    push ax
    lodsw
    add di, ax
    loop drawSquare_pixel

    pop ax
    popa
    ret

numberToPosition:
    test ax, ax
    jnz numbersToPosition_skipIncremment
    inc ax
    numbersToPosition_skipIncremment:
    mov bx, 3496
    xor dx, dx
    div bx
    xor ax, ax
    mov bx, 76
    add dx, bx
    add dx, bx
    numberToPosition_lineCount:
    sub dx, bx
    jc numberToPosition_lineCount_end
    add ax, 1280
    jmp numberToPosition_lineCount
    numberToPosition_lineCount_end:
    add dx, bx
    inc dx
    inc dx
    shl dx, 2
    add ax, dx
    ret

test:
    mov ax, 0xA000
    mov es, ax
    xor di, di
    mov cx, 64000
    rep stosb
    jmp halt

%ifndef NOPAD
times 510 - ($ - $$) db 0
dw 0xAA55
%endif
