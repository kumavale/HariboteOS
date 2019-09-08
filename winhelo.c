#include "apilib.h"

char buf[150 * 50];

void HariMain(void)
{
    (void) api_openwin(buf, 150, 50, -1, "hello");

    for (;;) {
        if (api_getkey(1) != 128) {
            break;
        }
    }
    api_end();
}

