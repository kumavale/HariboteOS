qemu-system-i386="/mnt/c/Program Files/qemu/qemu-system-i386.exe"
VBoxManage=VBoxManage.exe
args=-drive format=raw,if=floppy,file=
CFLAGS=-fno-pie -march=i486 -m32 -nostdlib -fno-stack-protector
OBJS_BOOTPACK=nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o int.o fifo.o \
			  keyboard.o mouse.o memory.o

default:
	make img

ipl10.bin : ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

nasmhead.bin : nasmhead.asm Makefile
	nasm nasmhead.asm -o nasmhead.bin -l nasmhead.lst

nasmfunc.o : nasmfunc.asm Makefile
	nasm -g -f elf nasmfunc.asm -o nasmfunc.o

makefont : makefont.c Makefile
	gcc makefont.c -o makefont

bin2ary : bin2ary.c Makefile
	gcc bin2ary.c -o bin2ary

hankaku.bin : makefont hankaku.txt Makefile
	./makefont hankaku.txt hankaku.bin

hankaku.o : bin2ary hankaku.bin Makefile
	./bin2ary hankaku.bin hankaku.c hankaku
	gcc -c -m32 -o hankaku.o hankaku.c

mysprintf.o : mysprintf.c Makefile
	gcc $(CFLAGS) -fno-stack-protector -c -o mysprintf.o mysprintf.c

%.o : %.c Makefile
	gcc $(CFLAGS) -c -o $*.o $*.c

bootpack.hrb : bootpack.c har.ld $(OBJS_BOOTPACK)  Makefile
	@echo -e "\033[35mIf an error occurs in the next gcc, check if you specified an object file.\033[m"
	gcc $(CFLAGS) $(OBJS_BOOTPACK) -T har.ld -g bootpack.c -o bootpack.hrb

haribote.sys : nasmhead.bin bootpack.hrb Makefile
	cat nasmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::
	@echo -e "\033[36mCompiled complete!\033[m"


asm:
	make -r ipl10.bin

img:
	make -r haribote.img

run:
	make img
	@#$(qemu-system-i386) $(args)haribote.img
	@#$(VBoxManage) storagectl hariboteos --name Floppy --remove
	@#$(VBoxManage) storagectl hariboteos --name Floppy --add floppy
	$(VBoxManage) storageattach hariboteos \
		--storagectl Floppy \
		--device 0 \
		--port 0 \
		--type fdd \
		--medium ./haribote.img
	$(VBoxManage) startvm hariboteos
