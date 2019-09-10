#include <stdarg.h>
#include "mystd.h"

static int dec2asc(char *str, int dec, int padding, int is_zero);
static int hex2asc(char *str, int dec, int padding, int is_zero,  int is_large);
static int str2asc(char *str, char *buf);


int sprintf(char *str, const char *fmt, ...)
{
    va_list list;
    int is_zero = 0;
    int padding = 0;
    int len, count = 0;
    va_start(list, fmt);

    while (*fmt) {
        if(*fmt == '%') {
            padding = is_zero = 0;
            ++fmt;
            if(*fmt == '0') {
                ++fmt;
                is_zero = 1;
            }
            while(('0' <= *fmt) && (*fmt <= '9')) {
                padding = (padding * 10) + *fmt - '0';
                ++fmt;
            }
            switch(*fmt){
                case 'd':
                    len = dec2asc(str, va_arg(list, int), padding, is_zero);
                    break;
                case 'x':
                    len = hex2asc(str, va_arg(list, int), padding, is_zero, 0);
                    break;
                case 'X':
                    len = hex2asc(str, va_arg(list, int), padding, is_zero, 1);
                    break;
                case 'c':
                    *str = (char)va_arg(list, int);
                    len = 1;
                    break;
                case 's':
                    len = str2asc(str, va_arg(list, char*));
                    break;
                default:
                    *str = *fmt;
                    len = 1;
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

int dec2asc(char *str, int dec, int padding, int is_zero)
{
    int len = 0, len_buf = 0;
    int isnot_zero_minus = 0;
    int buf[16];
    if(dec < 0) {
        dec *= -1;
        if(!is_zero) {
            isnot_zero_minus = 1;
        }
        else {
            *(str++) = '-';
            ++len_buf;
        }
    }
    while(1) {
        buf[len++] = dec % 10;
        if(dec < 10) break;
        dec /= 10;
    }
    len_buf += len;
    for(int i=len_buf; i<padding - isnot_zero_minus; ++i) {
        *(str++) = is_zero ? '0' : ' ';
        ++len_buf;
    }
    if(isnot_zero_minus) {
        *(str++) = '-';
        ++len_buf;
    }
    while(len) {
        *(str++) = buf[--len] + 0x30;
    }

    return len_buf;
}

int hex2asc(char *str, int dec, int padding, int is_zero, int is_large)
{
    int len = 0, len_buf;
    int buf[10];
    while(1) {
        buf[len++] = dec % 16;
        if(dec < 16) break;
        dec /= 16;
    }
    len_buf = len;
    for(int i=len_buf; i<padding; ++i) {
        *(str++) = is_zero ? '0' : ' ';
        ++len_buf;
    }
    while(len) {
        --len;
        if (buf[len] < 10) {
            *(str++) = (buf[len] + 0x30);
        } else if(is_large) {
            *(str++) = (buf[len] - 9 + 0x40);
        } else {
            *(str++) = (buf[len] - 9 + 0x60);
        }
    }

    return len_buf;
}

int str2asc(char *str, char *buf)
{
    int len = 0;
    while(*buf) {
        *(str++) = *(buf++);
        ++len;
    }

    return len;
}

int strcmp(const char *str1, const char *str2)
{
    for (int i = 0;; ++i) {
        if (str1[i] == 0 && str2[i] == 0) {
            return 0;
        }
        if (str1[i] != str2[i]) {
            break;
        }
    }

    return 1;
}

int strncmp(const char *str1, const char *str2, int n)
{
    for (int i = 0; i < n; ++i) {
        if (str1[i] == 0 && str2[i] == 0) {
            return 0;
        }
        if (str1[i] != str2[i]) {
            return 1;
        }
    }

    return 0;
}


static unsigned long int next = 1;
int rand(void)
{
    next *= 1103515245;
    next += 12345;

    return (unsigned int) next % (RAND_MAX + 1);
}

void srand(int seed)
{
    next = seed;
}

unsigned int strlen(const char *str)
{
    unsigned int len = 0;

    while (*str++) {
        ++len;
    }

    return len;
}

