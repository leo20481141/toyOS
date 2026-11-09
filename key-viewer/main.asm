[org 0x7c00]
[bits 16]

%define string 0x8000

start:
    mov ax, 0x03
    int 0x10

    waitLoop:
    xor ax, ax
    inc ah
    int 0x16
    jz waitLoop
    xor ah, ah
    int 0x16
    xor cl, cl
    mov si, string
    mov di, si
    dec si
    std
    shr ax, 8
    mov bl, 10
    number2String:
    div bl
    add ah, 48
    push cx
    rep movsb
    pop cx
    mov [string], ah
    inc cl
    add si, cx
    add di, cx
    xor ah, ah
    test al, al
    jnz number2String

    cld
    mov si, string
    mov ah, 0x0e
    printString:
    lodsb
    int 0x10
    loop printString
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    jmp waitLoop

    halt:
    cli
    hlt
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
