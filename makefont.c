/* makefont [in textfile] [out bin] */
#include <stdio.h>
#include <string.h>

#define N 256

int main(int argc, char **argv)
{
    FILE *fpi, *fpo;
    char s[N] = { '\0' };
    unsigned char c;
    int is_invalid;

    if(argc != 3) {
        return 1;
    }

    fpi = fopen(argv[1], "r");
    if(fpi == NULL) {
        return 2;
    }

    fpo = fopen(argv[2], "wb");
    if(fpo == NULL) {
        return 3;
    }

    while(fgets(s, N, fpi) != NULL) {
        c = 0;
        is_invalid = 0;
        if(strlen(s) <= 8) {
            continue;
        }
        for(int i=0; i<N; ++i) {
            if(s[i] == '.') {
                /* Do nothing */
            }
            else if(s[i] == '*') {
                c |= (128 >> i);
            }
            else if(s[i] == 0x0a || s[i] == 0x0d) {
                break;
            }
            else {
                is_invalid = 1;
                break;
            }
        }
        if(!is_invalid) {
            if(fwrite(&c, sizeof(char), 1, fpo) < 1) {
                return 4;
            }
        }
        memset(s, '\0', N);
    }

    fclose(fpi);
    fclose(fpo);

    return 0;
}
