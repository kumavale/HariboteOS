/* stdio */
int sprintf(char *str, const char *fmt, ...);

/* stdlib */
#define RAND_MAX 32767
int rand(void);
void srand(int seed);

/* string */
int strcmp(const char *str1, const char *str2);
int strncmp(const char *str1, const char *str2, int n);
unsigned int strlen(const char *str);

