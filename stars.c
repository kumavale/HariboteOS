#include "apilib.h"
#include "mystd.h"

void HariMain(void)
{
    char *buf;
    int win, i, x, y;
    api_initmalloc();
    buf = api_malloc(150 * 100);
    win = api_openwin(buf, 150, 100, -1, "stars");
    api_boxfilwin(win,  6, 26, 143, 93, 0 /* Black */);
    srand(1221);
    for (i = 0; i < 50; ++i) {
        x = (rand() % 137) +  6;
        y = (rand() %  67) + 26;
        api_point(win, x, y, 3 /* Yellow */);
    }

    for (;;) {
        if (api_getkey(1) != 128) {
            break;
        }
    }
    api_end();
}

