#include "bootpack.h"

extern int sprintf_(char *str, char *fmt, ...);


void HariMain(void)
{
    struct BOOTINFO *binfo = (struct BOOTINFO *) 0x0ff0;
    char s[64], mcursor[256];
    int mx, my;

    init_gdtidt();
    init_pic();
    io_sti();

    init_palette();
    init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
    mx = (binfo->scrnx - 16) / 2;
    my = (binfo->scrny - 28 - 16) / 2;
    init_mouse_cursor8(mcursor, COL8_008484);

    putfonts8_asc(binfo->vram, binfo->scrnx, 9, 9, COL8_000000, "Haribote OS.");
    putfonts8_asc(binfo->vram, binfo->scrnx, 8, 8, COL8_FFFFFF, "Haribote OS.");

    sprintf_(s, "(%d, %d)", mx, my);
    putfonts8_asc(binfo->vram, binfo->scrnx, 8, 32, COL8_FFFFFF, s);

    putblock8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);

    io_out8(PIC0_IMR, 0xf9);  /* Arrow PIC1 and Keyboard (11111001) */
    io_out8(PIC1_IMR, 0xef);  /* Arrow Mouse */

    for(;;) {
        io_hlt();
    }
}

