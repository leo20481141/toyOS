[org 0x7c00]
[bits 16]

start:
    mov ax, 0x0013
    int 0x10

    mov ax, 0xA000
    mov es, ax
    mov di, 0
    mov cx, 320
    mov dx, 50
    mov bl, 5
    mov ah, 200
    mov al, 0

    loop1:
    test ah, ah
    jz halt
    test bl, bl
    jnz loop2
    inc al
    mov bl, 5
    loop2:
    mov [es:di], al
    inc di
    dec bl
    loop loop1
    loop3:
    mov cx, 320
    dec ah
    dec dx
    jz iszero
    sub al, 64
    jmp loop1
    iszero:
    mov dx, 50
    jmp loop1

    halt:
    cli
    hlt
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
