rm -rf temps
as -32 pong.s -o pong.o
as -32 kernel.s -o kernel.o
ld -Ttext 0x7C00 --oformat binary -melf_i386 -o pong.bin pong.o
ld -Ttext 0x7E00 --oformat binary -melf_i386 -o kernel.bin kernel.o
dd if=/dev/zero of=pong.img bs=512 count=65
dd if=pong.bin of=pong.img bs=512 count=1 conv=notrunc
dd if=kernel.bin of=pong.img bs=512 count=64 seek=1 conv=notrunc
mkdir temps
mv *.o *.bin temps
