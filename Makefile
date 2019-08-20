qemu-system-i386="/mnt/c/Program Files/qemu/qemu-system-i386.exe"
VBoxManage=VBoxManage.exe
args=-drive format=raw,if=floppy,file=

default:
	make img

ipl10.bin : ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

nasmhead.bin : nasmhead.asm Makefile
	nasm nasmhead.asm -o nasmhead.bin -l nasmhead.lst

nasmfunc.o : nasmfunc.asm Makefile
	nasm -g -f elf nasmfunc.asm -o nasmfunc.o

bootpack.hrb : bootpack.c har.ld nasmfunc.o Makefile
	gcc -fno-pie -march=i486 -m32 -nostdlib -T har.ld -g bootpack.c nasmfunc.o -o bootpack.hrb

haribote.sys : nasmhead.bin bootpack.hrb Makefile
	cat nasmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::


asm:
	make -r ipl10.bin

img:
	make -r haribote.img

run:
	make img
	#$(qemu-system-i386) $(args)haribote.img
	$(VBoxManage) storagectl hariboteos --name Floppy --remove
	$(VBoxManage) storagectl hariboteos --name Floppy --add floppy
	$(VBoxManage) storageattach hariboteos --storagectl Floppy --device 0 --port 0 --type fdd --medium ./haribote.img
	$(VBoxManage) startvm hariboteos
