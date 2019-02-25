; haribote-ipl
; TAB=4

CYLS EQU 10                     ; #define CYLS 10

        ORG     0x7c00          ; メモリ上の開始位置

        JMP     entry
        DB      0x90
        DB      "HARIBOTE"      ; ブートセレクタの名前を自由にかいていよい  (8Byte)
        DW      512             ; 1セクタの大きさ                           (512にしなければならない)
        DB      1               ; クラスタの大きさ                          (1セクタにしなければならない)
        DW      1               ; FATがどこから始まるか                     (普通は1セクタ目からにする)
        DB      2               ; FATの個数                                 (2にしなければならない)
        DW      224             ; ルートディレクトリ領域の大きさ            (普通は224エントリにする)
        DW      2880            ; このドライブの大きさ                      (2880セクタにしなければならない)
        DB      0xf0            ; メディアタイプ                            (0xf0にしなければならない)
        DW      9               ; FAT領域の長さ                             (9セクタにしなければならない)
        DW      18              ; 1トラックにいくつのセクタがあるか         (18にしなければならない)
        DW      2               ; ヘッドの数                                (2にしなければならない)
        DD      0               ; パーティションを使っていないのでここは必ず0
        DD      2880            ; このドライブの大きさをもう一度書く
        DB      0, 0, 0x29      ; よくわからないけどこの値にしておくといいらしい
        DD      0xffffffff      ; たぶんボリュームシリアル番号
        DB      "HARIBOTEOS "   ; ディスクの名前                            (11Byte)
        DB      "FAT12   "      ; フォーマットの名前                        (8Byte)
        TIMES   18  DB 0        ; とりあえず18バイト開けておく

; Program Main Body
entry:
        MOV     AX, 0           ; レジスタの初期化
        MOV     SS, AX
        MOV     SP, 0x7c00
        MOV     DS, AX

; Read Disk
				MOV			AX, 0x0820
				MOV			ES, AX
				MOV			CH, 0           ; シリンダ番号0
				MOV			DH, 0						; ヘッド番号0
				MOV			CL, 2						; セクタ番号2

readloop:
				MOV			SI, 0           ; 失敗回数のリセット

retry:
				MOV			AH, 0x02				; INT命令用
				MOV			AL, 1
				MOV			BX, 0
				MOV			DL, 0x00				; ドライブ番号0 <--①
				INT			0x13    				; disk BIOSコール(AH=0x02) <--②-1
				JNC			next						; エラーがなければnextへ
				ADD			SI, 1						; SIレジスタ(失敗回数) + 1
				CMP			SI, 5						; SIと5を比較
				JAE			error						; SI >= 5のときerrorへ
				MOV			AH, 0x00				; INT命令用
				MOV			DL, 0x00				; ドライブ番号0
				INT			0x13						; disk BIOSコール(AH=0x00) <--②-2
				JMP			retry


next:
				MOV			AX, ES					; アドレスを0x200(=512=1セクタ)進める
				ADD			AX, 0x20
				MOV			ES, AX					; ADD ES, 0x20という命令が無い
				ADD			CL, 1						; CL(セクタ番号)を1増やす
				CMP			CL, 18					; CLと18を比較
				JBE			readloop				; CL <= 18の時readloopへ
				MOV			CL, 1						; CL=1
				ADD			DH, 1						; DH(ヘッダ番号)を1増やす
				CMP			DH, 2						; DHと2を比較
				JB			readloop				; DH < 2の時readloopへ
				MOV			DH, 0						; DH=0
				ADD			CH, 1						; CH(シリンダ番号)を1増やす
				CMP			CH, CYLS				; CHとCYLS(=10)を比較
				JB			readloop				; CH < CYLSの時readloopへ

				MOV			[0x0ff0], CH    ; IPLがどこまで読んだのかをメモ
				JMP			0xc200

fin:
				HLT
				JMP			fin

error:
				MOV			SI, msg					; SIにmsgのメモリ番地を代入

putloop:
        MOV     AL, [SI]        ; BYTE (accumulator low)
        ADD     SI, 1           ; increment
        CMP     AL, 0           ; compare (<end msg>)
        JE      fin             ; jump to fin if equal to 0
        MOV     AH, 0x0e        ; AH = 0x0e
        MOV     BX, 15          ; BH = 0, BL = <color code>
        INT     0x10            ; interrupt BIOS
        JMP     putloop

msg:
        DB      0x0a, 0x0a
        DB      "load error"    ; Error message
        DB      0x0a
        DB      0               ; end msg

        TIMES   0x7dfe-0x7c00-($-$$)  DB 0

; END BS_BootCode
        DB      0x55, 0xaa      ; BS_BootSign, boot signature
