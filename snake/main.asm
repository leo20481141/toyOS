[org 0x7c00]
[bits 16]

%define drawingSums 0x7E00
%define directionSums 0x7E20
%define direction 0x7FFA
%define fruit 0x7FFC
%define snakeParts_len 0x7FFE
%define snakeParts 0x8000

start:
    mov di, directionSums
    mov cx, 0xFF
    rep stosw

    sub di, 0x16E
    mov ax, 64256
    stosw
    add di, 4
    mov ax, 65532
    stosw
    inc di
    inc di
    mov ax, 4
    stosw
    add di, 4
    mov ax, 1280
    stosw

    mov ax, 0x13
    int 0x10

    mov al, 0x34
    out 0x43, al
    mov ax, 341
    out 0x40, al
    mov al, ah
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
    mov sp, 0x7C00

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
    add al, 2
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
    sub dx, 800
    jc waitLoop

    inc ah
    int 0x16
    jz after
    xor ax, ax
    int 0x16
    mov si, directionSums
    shr ax, 8
    shl al, 1
    add si, ax
    lodsw
    test ax, ax
    jz after
    mov [direction], ax

    after:
    mov ax, [snakeParts]
    add ax, [direction]
    mov di, ax
    xor di, [fruit]
    jz eatFruit
    mov di, ax
    mov dl, [es:di]
    xor dl, 24
    jz startGame
    mov dx, ax
    mov cx, [snakeParts_len]
    mov si, snakeParts
    colissionWithItself:
    push dx
    lodsw
    xor dx, ax
    pop dx
    jz startGame
    loop colissionWithItself

    mov di, ax
    xor al, al
    call drawSquare

    dec si
    dec si
    mov di, si
    dec si
    dec si
    mov cx, [snakeParts_len]
    dec cx
    jmp moveMemory

    eatFruit:
    push ax
    xor ax, ax
    int 0x1A
    mov ax, dx
    call numberToPosition
    mov [fruit], ax
    pop ax

    mov cx, [snakeParts_len]
    mov di, snakeParts
    add di, cx
    add di, cx
    mov si, di
    dec si
    dec si
    mov dx, ax
    inc word [snakeParts_len]
    jmp moveMemory

    halt:
    cli
    hlt
    jmp $

drawSquare:
    push si
    push cx
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
    pop cx
    pop si
    ret

numberToPosition:
    test al, al
    jnz numbersToPosition_skipIncremment
    inc al
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

moveMemory:
    xor ax, ax
    mov es, ax
    std
    rep movsw
    mov ax, dx
    stosw
    cld
    jmp draw

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
