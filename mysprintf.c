/* [References]
 * http://bttb.s1.valueserver.jp/wordpress/blog/2017/12/17/makeos-5-2/
 */
#include <stdarg.h>

int sprintf_(char *str, const char *fmt, ...);

static int dec2asc(char *str, int dec, int padding);
static int hex2asc(char *str, int dec, int padding, int is_large);


int sprintf_(char *str, const char *fmt, ...)
{
    va_list list;
    int len, count = 0;
    va_start(list, fmt);

    while (*fmt) {
        if(*fmt=='%') {
            ++fmt;
            switch(*fmt){
                case 'd':
                    len = dec2asc(str, va_arg(list, int), 3);
                    break;
                case 'x':
                    len = hex2asc(str, va_arg(list, int), 2, 0);
                    break;
                case 'X':
                    len = hex2asc(str, va_arg(list, int), 2, 1);
                    break;
            }
            str += len;
            count += len;
            ++fmt;
        } else {
            ++count;
            *(str++) = *(fmt++);
        }
    }
    *str = 0x00;
    va_end(list);

    return count;
}

int dec2asc(char *str, int dec, int padding)
{
    int len = 0, len_buf = 0;
    int buf[10];
    if(dec < 0) {
        *(str++) = '-';
        dec *= -1;
        ++len_buf;
    }
    while(1) {
        buf[len++] = dec % 10;
        if(dec < 10) break;
        dec /= 10;
    }
    len_buf += len;
    for(int i=len_buf; i<padding; ++i) {
        *(str++) = '0';
        ++len_buf;
    }
    while(len) {
        *(str++) = buf[--len] + 0x30;
    }

    return len_buf;
}

int hex2asc(char *str, int dec, int padding, int is_large)
{
    int len = 0, len_buf;
    int buf[10];
    while(1) {
        buf[len++] = dec % 16;
        if(dec < 16) break;
        dec /= 16;
    }
    len_buf = len;
    while(len) {
        --len;
        *(str++) = (buf[len]<10) ? (buf[len] + 0x30) : is_large ? (buf[len] - 9 + 0x40) : (buf[len] - 9 + 0x60);
    }

    return len_buf;
}

