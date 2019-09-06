#include "rand.h"

#undef  RAND_MAX
#define RAND_MAX 32767

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

