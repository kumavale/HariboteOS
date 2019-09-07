qemu-system-i386="/mnt/c/Program Files/qemu/qemu-system-i386.exe"
VBoxManage=VBoxManage.exe
args=-drive format=raw,if=floppy,file=
CFLAGS=-fno-pie -march=i486 -m32 -nostdlib -fno-builtin -fno-stack-protector -Wall
OBJS_BOOTPACK=nasmfunc.o hankaku.o mystd.o graphic.o dsctbl.o int.o fifo.o \
			  keyboard.o mouse.o memory.o sheet.o timer.o mtask.o window.o \
			  console.o file.o

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

%.o : %.c Makefile
	gcc $(CFLAGS) \
		-c -o $*.o $*.c

bootpack.hrb : bootpack.o har.ld $(OBJS_BOOTPACK)  Makefile
	@echo -e "[\033[35mIf an error occurs in the next gcc, check if you specified an object file.\033[m]"
	gcc $(CFLAGS) \
		$(OBJS_BOOTPACK) \
		-Wl,-Map=bootpack.map -T har.ld bootpack.o -o bootpack.hrb

haribote.sys : nasmhead.bin bootpack.hrb Makefile
	cat nasmhead.bin bootpack.hrb > haribote.sys

a_nasm.o : a_nasm.asm Makefile
	nasm -f elf32 -o $@ $<

%.hrb : %.asm Makefile
	nasm -o $@ $<

%.hrb : %.c a_nasm.o api.ld Makefile
	gcc $(CFLAGS) \
		-T api.ld -o $@ $< a_nasm.o

stars.hrb : stars.c a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) \
		-T api.ld -o $@ $< a_nasm.o mystd.o

stars2.hrb : stars2.c a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) \
		-T api.ld -o $@ $< a_nasm.o mystd.o

noodle.hrb : noodle.o a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) -Wl,-Map=noodle.map -T api.ld -o $@ $< a_nasm.o mystd.o
	@#gcc $(CFLAGS) -Wl,-Map=noodle.map -o noodle.o $< -c
	@#ld -T api.ld -m elf_i386 -o $@ mystd.o noodle.o a_nasm.o --defsym stack=256k --defsym heap=1024k

haribote.img : ipl10.bin haribote.sys hello.hrb hello2.hrb hello3.hrb hello4.hrb a.hrb winhelo.hrb winhelo2.hrb winhelo3.hrb star1.hrb stars.hrb stars2.hrb lines.hrb walk.hrb noodle.hrb Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::
	mcopy -i haribote.img mystd.c ::
	mcopy -i haribote.img hello.hrb ::
	mcopy -i haribote.img hello2.hrb ::
	mcopy -i haribote.img hello3.hrb ::
	mcopy -i haribote.img hello4.hrb ::
	mcopy -i haribote.img a.hrb ::
	mcopy -i haribote.img winhelo.hrb ::
	mcopy -i haribote.img winhelo2.hrb ::
	mcopy -i haribote.img winhelo3.hrb ::
	mcopy -i haribote.img star1.hrb ::
	mcopy -i haribote.img stars.hrb ::
	mcopy -i haribote.img stars2.hrb ::
	mcopy -i haribote.img lines.hrb ::
	mcopy -i haribote.img walk.hrb ::
	mcopy -i haribote.img noodle.hrb ::
	@echo -e "\033[36mCompiled complete!\033[m"
	@echo


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
