#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../test-utils.h"
#include "Debugging.h"

int main(int argc, char *argv[])
{

    uint64_t x = ejercicio1(1, 1, 2, 3, 4);
    printf("%d", x);
}