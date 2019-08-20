# 備忘録
[はりぼてOS](https://www.amazon.co.jp/dp/B00IR1HYI0)を作り, 学ぶ  
筆者様の作ったツールは使用しない.  

## 環境
Windows10 HOME 1903  
Arch linux on WSL  
VirtualBox

```
$ uname -a
Linux salieri 4.4.0-18362-Microsoft #1-Microsoft Mon Mar 18 12:02:00 PST 2019 x86_64 GNU/Linux

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
gcc (GCC) 9.1.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

```
qemu-system-i386.exe --version
QEMU emulator version 3.1.50 (v3.1.0-13607-geb2db0f7ba-dirty)
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
```

```VirtualBox:
VBoxManage.exe -v
5.2.22r126460
```

nasm, mtools, gcc, make等はWSL(Arch)のものを使用する.  
~~qemu~~ VirtualBox のみWindows版を使用.  

