#include "list.h"

list_t* listNew(type_t t){
    list_t* l = malloc(sizeof(list_t));
    l->type = t;
    l->size = 0;
    l->first = NULL;
    return l;
}

void listAddFirst(list_t* l, void* data){
    node_t* n = malloc(sizeof(node_t));
    switch(l->type){
        case TypeFAT32:
            n->data = (void*) copy_fat32((fat32_t*) data);
            break;
        case TypeEXT4:
            n->data = (void*) copy_ext4((ext4_t*) data);
            break;
        case TypeNTFS:
            n->data = (void*) copy_ntfs((ntfs_t*) data);
            break;
    }
    n->next = l->first;
    l->first = n;
    l->size++;
}

void* listGet(list_t* l, uint8_t i){
    node_t* n = l->first;

    for(uint8_t j = 0; j < i; j++){
        n = n->next;
    }
    return n->data;
}

void* listRemove(list_t* l, uint8_t i){
    node_t* temp = NULL;
    void* data = NULL;

    if(i==0){
        data = l->first->data;
        temp = l->first;
        l->first = l->first->next;
    }else{
        node_t* n = l->first;
        for(uint8_t j = 0; j < i-1; j++){
            n = n->next;
        }
        data = n->next->data;
        temp = n->next;
        n->next = n->next->next;
    }
    free(temp);
    l->size--;
    return data;
}

void listDelete(list_t* l){
    node_t* n = l->first;
    while(n){
        node_t* tmp = n;
        n = n->next;
        switch (l->type){
        case TypeFAT32:
            rm_fat32((fat32_t*) tmp->data);
            break;
        case TypeEXT4:
            rm_ext4((ext4_t*) tmp->data);
            break;
        case TypeNTFS:
            rm_ntfs((ntfs_t*) tmp->data);
            break;
        }
        free(tmp);
    }
    free(l);
}

//seria mas facil intercambiar los datos pero creo q pide los nodos como tal
//es una implementacion poco eficiente por la falta del prev, porque es simplemente enlazada
//se podria mejorar en la doblemente enlazada, y no creo q lo haga je
//optimizable pero no voy a entender nada
void listSwap(list_t* l, const uint8_t i, const uint8_t j){
    if(l->size < 2 || i == j){
        return;
    }
    node_t *a,*b,*n;
    n = l->first;
    for(uint8_t k = 0; k < l->size; k++){
        if(k == i) a = n;
        if(k == j) b = n;
        n = n->next;
    }

    if(i == 0){
        n = l->first;
        for(uint8_t k = 0; k < l->size; k++){
            l->first = b;
            l->first->next = n->next;
            if(k == j-1){
                a->next = n->next->next;
                n->next = a;
            }
            n = n->next;
        }
        return;
    }
    if(j == 0){
        n = l->first;
        for(uint8_t k = 0; k < l->size; k++){
            l->first = a;
            if(k == i-1){
                b->next = n->next->next;
                n->next = b;
                
            }
            n = n->next;
        }
        return;
    }

    n = l->first;
    for(uint8_t k = 0; k < l->size; k++){
        if(k == i-1){
            b->next = n->next->next;
            n->next = b;
        } 
        if(k == j-1){
            a->next = n->next->next;
            n->next = a;
        }
        n = n->next;
    }
}


//definciones de los tipos
fat32_t* new_fat32() {
    fat32_t* f = malloc(sizeof(fat32_t)); //aparentemente son 
    //printf("%zu\n",sizeof(fat32_t));
    *f = 1;
    return f;
}

ext4_t* new_ext4() {
    ext4_t* f = malloc(sizeof(ext4_t)); //aparentemente son 
    //printf("%zu\n",sizeof(ext4_t));
    *f = 2;
    return f;
}

fat32_t* new_ntfs() {
    ntfs_t* f = malloc(sizeof(ntfs_t)); //aparentemente son 
    //printf("%zu\n",sizeof(ntfs_t));
    *f = 3;
    return f;
}

//como es un uint se copia por valor asi
fat32_t* copy_fat32(fat32_t* file) {
    fat32_t* f = malloc(sizeof(fat32_t));
    *f = *file;
    return f;
}

ext4_t* copy_ext4(ext4_t* file) {
    ext4_t* f = malloc(sizeof(ext4_t));
    *f = *file;
    return f;
}

ntfs_t* copy_ntfs(ntfs_t* file) {
    ntfs_t* f = malloc(sizeof(ntfs_t));
    *f = *file;
    return f;
}

void rm_fat32(fat32_t* file) {free(file);}
void rm_ext4(ext4_t* file) {free(file);}
void rm_ntfs(ntfs_t* file) {free(file);}