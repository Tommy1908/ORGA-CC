#include <stdio.h>
#include "list.h"

int main(){
    list_t* l = listNew(TypeFAT32);
    fat32_t* f1 = new_fat32();
    fat32_t* f2 = new_fat32();
    listAddFirst(l, f1);
    listAddFirst(l, f2);
    void* p = listGet(l,1);
    printf("%d",*(uint32_t*)p);
    listDelete(l);
    rm_fat32(f1);
    rm_fat32(f2);
    return 0;
}