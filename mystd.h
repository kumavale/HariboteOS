#undef  RAND_MAX
#define RAND_MAX 32767

int sprintf(char *str, const char *fmt, ...);
int strcmp(const char *str1, const char *str2);
int strncmp(const char *str1, const char *str2, int n);
int rand(void);
void srand(int seed);

