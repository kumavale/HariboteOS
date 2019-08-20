; haribote-os
; TAB=4

; BOOT_INFO
CYLS     EQU        0x0ff0
LEDS     EQU        0x0ff1
VMODE    EQU        0x0ff2
SCRNX    EQU        0x0ff4
SCRNY    EQU        0x0ff6
VRAM     EQU        0x0ff8

         ORG        0xc200    ; 0xc200 <- 0x8000 + 0x4200
                              ; Where on memory this program will be loaded

         MOV        AL, 0x13  ; VGA graphics, 320x200x8bit
         MOV        AH, 0x00
         INT        0x10

         MOV        BYTE    [VMODE], 8
         MOV        WORD    [SCRNX], 320
         MOV        WORD    [SCRNY], 200
         MOV        DWORD    [VRAM], 0x000a0000

; LED state on keyboard from BIOS
         MOV        AH, 0x02
         INT        0x16      ; keyboard BIOS
         MOV        [LEDS], AL

fin:
         HLT
         JMP        fin
