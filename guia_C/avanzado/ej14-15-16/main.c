#include <stdio.h>
#include "list.h"

int main()
{
    list_t *l = listNew(TypeFAT32);
    fat32_t *f1 = new_fat32(0);
    fat32_t *f2 = new_fat32(1);
    fat32_t *f3 = new_fat32(2);
    fat32_t *f4 = new_fat32(3);
    fat32_t *f5 = new_fat32(4);

    listAddFirst(l, f5);
    listAddFirst(l, f4);
    listAddFirst(l, f3);
    listAddFirst(l, f2);
    listAddFirst(l, f1);

    void *p = listGet(l, 0);
    printf("%d\n", *(uint32_t *)p);
    listSwap(l, 0, 4);
    p = listGet(l, 0);
    printf("%d\n", *(uint32_t *)p);

    p = listGet(l, 1);
    printf("%d\n", *(uint32_t *)p);
    listSwap(l, 1, 2);
    p = listGet(l, 1);
    printf("%d\n", *(uint32_t *)p);

    listDelete(l);
    rm_fat32(f1);
    rm_fat32(f2);
    rm_fat32(f3);
    rm_fat32(f4);
    rm_fat32(f5);
    return 0;
}