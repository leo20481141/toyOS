nasm -f bin main.asm -o main.bin
dd if=/dev/zero of=floppy.img bs=512 count=2880
dd if=main.bin of=floppy.img conv=notrunc
rm main.bin
qemu-system-i386 -drive file=floppy.img,if=floppy,format=raw
