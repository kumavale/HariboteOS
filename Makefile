qemu-system-i386="/mnt/c/Program Files/qemu/qemu-system-i386.exe"
VBoxManage=VBoxManage.exe
args=-drive format=raw,if=floppy,file=
CFLAGS=-fno-pie -march=i486 -m32 -nostdlib -fbuiltin -fno-stack-protector -Wall
OBJS_BOOTPACK=nasmfunc.o hankaku.o mystd.o graphic.o dsctbl.o int.o fifo.o \
			  keyboard.o mouse.o memory.o sheet.o timer.o mtask.o window.o \
			  console.o file.o tek.o
HRBS=hello.hrb hello2.hrb hello3.hrb hello4.hrb a.hrb winhelo.hrb winhelo2.hrb \
	 winhelo3.hrb star1.hrb stars.hrb stars2.hrb lines.hrb walk.hrb noodle.hrb \
	 beepdown.hrb color.hrb color2.hrb sosu.hrb sosu2.hrb catipl.hrb cat.hrb \
	 iroha.hrb notrec.hrb bball.hrb invader.hrb

default:
	make img

ipl20.bin : ipl20.asm Makefile
	nasm -o $@ $< -l ipl20.lst

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
	gcc $(CFLAGS) -T api.ld -o $@ $< a_nasm.o

stars.hrb : stars.c a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) -T api.ld -o $@ $< a_nasm.o mystd.o

stars2.hrb : stars2.c a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) -T api.ld -o $@ $< a_nasm.o mystd.o

noodle.hrb : noodle.o a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) -Wl,-Map=noodle.map -T api.ld -o $@ $< a_nasm.o mystd.o

sosu.hrb : sosu.c a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) -T api.ld -o $@ $< a_nasm.o mystd.o

sosu2.hrb : sosu2.c a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) -Wl,--defsym,stack=128k -T api.ld -o $@ $< a_nasm.o mystd.o

invader.hrb : invader.c a_nasm.o api.ld mystd.o Makefile
	gcc $(CFLAGS) -Wl,--defsym,stack=128k -Wl,-Map=invader.map -T api.ld -o $@ $< a_nasm.o mystd.o

haribote.img : ipl20.bin haribote.sys $(HRBS) sjis.txt euc.txt Makefile
	mformat -f 1440 -C -B ipl20.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::
	mcopy -i haribote.img nihongo.fnt ::
	mcopy -i haribote.img sjis.txt ::
	mcopy -i haribote.img euc.txt ::
	mcopy -i haribote.img $(HRBS) ::
	@echo -e "\033[36mCompiled complete!\033[m"
	@echo


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

clean:
	-rm -f *.bin
	-rm -f *.lst
	-rm -f *.map
	-rm -f *.lst
	-rm -f *.o
	-rm -f *.sys
	-rm -f haribote.img

