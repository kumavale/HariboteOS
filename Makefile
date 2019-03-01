qemu-system-i386="/mnt/c/Program Files/qemu/qemu-system-i386.exe"
args=-drive format=raw,if=floppy,file=

default:
	make img

nasmhead.bin: nasmhead.asm
	nasm -o nasmhead.bin nasmhead.asm

nasmfunc.o: nasmfunc.asm
	nasm -f elf32 -o nasmfunc.o nasmfunc.asm

bootpack.o: bootpack.c
	gcc -c -m32 -fno-pic -o bootpack.o bootpack.c

bootpack.bin: bootpack.o nasmfunc.o
	ld -m elf_i386 -e HariMain -o bootpack.bin -Tos.ls bootpack.o nasmfunc.o

os.sys: nasmhead.bin bootpack.bin
	cat nasmhead.bin bootpack.bin > os.sys

ipl10.bin: ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

tail.bin: tail.asm Makefile
	nasm tail.asm -o tail.bin -l tail.lst

haribote.sys: haribote.asm Makefile
	nasm haribote.asm -o haribote.sys -l haribote.lst

haribote.img: ipl10.bin tail.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::


asm:
	make -r ipl10.bin

img:
	make -r haribote.img

run:
	make img
	$(qemu-system-i386) $(args)haribote.img
