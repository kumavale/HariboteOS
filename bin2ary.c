/* bin2ary [in textfile] [out bin] [label] */
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
    FILE *fpi, *fpo;
    unsigned char c;
    char hex[6+1];
    int count = 0;

    if(argc != 4) {
        return 1;
    }

    fpi = fopen(argv[1], "rb");
    if(fpi == NULL) {
        return 2;
    }

    fpo = fopen(argv[2], "w");
    if(fpo == NULL) {
        return 3;
    }

    fputs("char ", fpo);
    fputs(argv[3], fpo);
    fputs("[4096] = {\n", fpo);  /* Anyway 4096 */

    while(fread(&c, sizeof(char), 1, fpi)) {
        sprintf(hex, " 0x%02X,", c);
        fputs(hex, fpo);
        ++count;
        if(16 <= count) {
            fputs("\n", fpo);
            count = 0;
        }
    }

    fputs("};\n", fpo);

    fclose(fpi);
    fclose(fpo);

    return 0;
}
