OUTPUT_FORMAT("binary");

/*
 * You can overwrite these settings using '--defsym' command line option:
 *   $ ld --defsym stack=256K --defsym heap=1024K -T hrbapp.ls ...
 *   $ gcc -Wl,--defsym,stack=256k -Wl,--defsym,heap=1024k
 */

stack = DEFINED(stack) ? stack : 64K;
heap = DEFINED(heap) ? heap : 1024K;

MEMORY {
  rom (rx) : ORIGIN = 0, LENGTH = 1024K
  ram (rwx) : ORIGIN = 64K, LENGTH = 1024K
}

SECTIONS {
    .head 0x0 : {
        LONG((stack + SIZEOF(.data) + SIZEOF(.bss) + heap + 0xfff) & ~ 0xfff)      /*  0 : Size of data segment (4KB align) */
        LONG(0x69726148)      /*  4 : Signature "Hari" */
        LONG(0)               /*  8 : Size of mmarea (4KB align) */
        LONG(stack)      /* 12 : Stack address and .data destination address */
        LONG(SIZEOF(.data))   /* 16 : Size of .data */
        LONG(LOADADDR(.data))     /* 20 : Address of .data */
        LONG(0xE9000000)      /* 24 : 0xE9000000 (jump) */
        LONG(HariMain - 0x20) /* 28 : Entry address - 0x20 */
        LONG((ADDR(.bss) + SIZEOF(.bss) + 0xf) & ~ 0xf)       /* 32 : heap space (malloc) start address */
    } > rom

    .text : { *(.text) }

    .data : {
        *(.data)
        *(.rodata*)
        *(.bss*)
    } > ram AT > rom

    .bss : AT(LOADADDR(.data) + SIZEOF(.data)) SUBALIGN(4) {
        *(.bss)
        . = ALIGN(16);
    } > ram

    /DISCARD/ : { *(.eh_frame) }
}

