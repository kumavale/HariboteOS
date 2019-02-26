# 備忘録
はりぼてOSを作り, 学ぶ  
筆者様の作ったツールは使用しない.  

## 環境
Windows10 HOME 1803  
Arch linux on WSL  
```
$ uname -a
Linux salieri 4.4.0-17134-Microsoft #523-Microsoft Mon Dec 31 17:49:00 PST 2018 x86_64 GNU/Linux

$ make --version
GNU Make 4.2.1
Built for x86_64-pc-linux-gnu
Copyright (C) 1988-2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

$ nasm --version
NASM version 2.14.02 compiled on Jan 22 2019

$ gcc --version
gcc (GCC) 8.2.1 20181127
Copyright (C) 2018 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

"c:\Program Files\qemu\qemu-system-i386.exe" --version
QEMU emulator version 3.1.50 (v3.1.0-13607-geb2db0f7ba-dirty)
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
```
nasm, mtools, gcc, make等はArchのものを使用する.  
qemuのみWindows版のexeを使用.  
