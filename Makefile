qemu-system-i386="/mnt/c/Program Files/qemu/qemu-system-i386.exe"
args=-drive format=raw,if=floppy,file=

default:
	make img

ipl10.bin: ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

tail.bin: tail.asm Makefile
	nasm tail.asm -o tail.bin -l tail.lst

haribote.sys: haribote.asm Makefile
	nasm haribote.asm -o haribote.sys -l haribote.lst

haribote.img: ipl10.bin tail.bin haribote.sys Makefile
	#cat ipl.bin tail.bin > haribote.img
	#pacman -S mtools
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::


asm:
	make -r ipl10.bin

img:
	make -r haribote.img

run:
	make img
	$(qemu-system-i386) $(args)haribote.img
