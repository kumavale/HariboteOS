#include "apilib.h"

void HariMain(void)
{
    char *buf;
    int win;

    api_initmalloc();
    buf = api_malloc(150 * 50);
    win = api_openwin(buf, 150, 50, -1, "hello");
    api_boxfilwin(win,  8, 36, 141, 43, 6 /* Aqua */);
    api_putstrwin(win, 28, 28, 0 /* Black */, 12, "Hello, World!");

    for (;;) {
        if (api_getkey(1) != 128) {
            break;
        }
    }
    api_end();
}

