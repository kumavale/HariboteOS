#include "apilib.h"

void HariMain(void)
{
    char *buf;
    int win, i, x, y;
    api_initmalloc();
    buf = api_malloc(160 * 100);
    win = api_openwin(buf, 160, 100, -1, "walk");
    api_boxfilwin(win, 4, 24, 155, 95, 0 /* Black */);
    x = 76;
    y = 56;
    api_putstrwin(win, x, y, 2 /* Green */, 1, "@");
    for (;;) {
        i = api_getkey(1);
        api_putstrwin(win, x, y, 0 /* Black */, 1, "@");
        if (i == 'h' && x >   4) { x -= 8; }
        if (i == 'l' && x < 148) { x += 8; }
        if (i == 'k' && y >  24) { y -= 8; }
        if (i == 'j' && y <  80) { y += 8; }
        if (i == 0x0a) { break; } /* Enter to exit */
        api_putstrwin(win, x, y, 2 /* Green */, 1, "@");
    }
    api_closewin(win);
    api_end();
}

