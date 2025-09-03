#include "list.h"

// Quedo hacerla doblemente enlazada pero tmb tendria
// Que cambiar el swap y prefiero avanzar, asi q to-do

list_t *listNew(type_t t)
{
    list_t *l = malloc(sizeof(list_t));
    l->type = t;
    l->size = 0;
    l->first = NULL;
    return l;
}

void listAddFirst(list_t *l, void *data)
{
    node_t *n = malloc(sizeof(node_t));
    switch (l->type)
    {
    case TypeFAT32:
        n->data = (void *)copy_fat32((fat32_t *)data);
        break;
    case TypeEXT4:
        n->data = (void *)copy_ext4((ext4_t *)data);
        break;
    case TypeNTFS:
        n->data = (void *)copy_ntfs((ntfs_t *)data);
        break;
    }
    n->next = l->first;
    l->first = n;
    l->size++;
}

void *listGet(list_t *l, uint8_t i)
{
    if (l == NULL || l->first == NULL || i >= l->size)
    {
        return NULL; // Índice fuera de rango o lista inválida
    }
    node_t *n = l->first;

    for (uint8_t j = 0; j < i; j++)
    {
        n = n->next;
    }
    return n->data;
}

void *listRemove(list_t *l, uint8_t i)
{
    node_t *temp = NULL;
    void *data = NULL;

    if (i == 0)
    {
        data = l->first->data;
        temp = l->first;
        l->first = l->first->next;
    }
    else
    {
        node_t *n = l->first;
        for (uint8_t j = 0; j < i - 1; j++)
        {
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

void listDelete(list_t *l)
{
    node_t *n = l->first;
    while (n)
    {
        node_t *tmp = n;
        n = n->next;
        switch (l->type)
        {
        case TypeFAT32:
            rm_fat32((fat32_t *)tmp->data);
            break;
        case TypeEXT4:
            rm_ext4((ext4_t *)tmp->data);
            break;
        case TypeNTFS:
            rm_ntfs((ntfs_t *)tmp->data);
            break;
        }
        free(tmp);
    }
    free(l);
}

// seria mas facil intercambiar los datos pero creo q pide los nodos como tal
// es una implementacion poco eficiente por la falta del prev, porque es simplemente enlazada
// se podria mejorar en la doblemente enlazada, y no creo q lo haga je
// optimizable pero no voy a entender nada
void listSwap(list_t *l, uint8_t i, uint8_t j)
{
    if (l->size < 2 || i == j)
    {
        return;
    }
    if (i > j)
    {
        uint8_t temp = i;
        i = j;
        j = temp;
    }

    node_t *prev_a = NULL, *a = NULL, *prev_b = NULL, *b = NULL, *n = NULL;

    n = l->first;
    for (uint8_t k = 0; k < l->size; k++)
    {
        if (k == i - 1)
            prev_a = n;
        if (k == i)
            a = n;
        if (k == j - 1)
            prev_b = n;
        if (k == j)
            b = n;
        n = n->next;
    }
    if (a == NULL || b == NULL)
    {
        return;
    }

    node_t *next_of_a = a->next;
    node_t *next_of_b = b->next;

    // Nodos adyacentes
    if (i + 1 == j)
    {
        if (prev_a == NULL)
        {
            l->first = b;
        }
        else
        {
            prev_a->next = b;
        }
        b->next = a;
        a->next = next_of_b;
        return;
    }

    // Caso general
    if (prev_a == NULL) // Cambiar el primer nodo
    {
        l->first = b;
    }
    else
    {
        prev_a->next = b;
    }
    prev_b->next = a;
    a->next = next_of_b;
    b->next = next_of_a;
    return;
}

// definciones de los tipos
fat32_t *new_fat32(uint32_t n)
{
    fat32_t *f = malloc(sizeof(fat32_t)); // aparentemente son
    // printf("%zu\n",sizeof(fat32_t));
    *f = n;
    return f;
}

ext4_t *new_ext4()
{
    ext4_t *f = malloc(sizeof(ext4_t)); // aparentemente son
    // printf("%zu\n",sizeof(ext4_t));
    *f = 2;
    return f;
}

fat32_t *new_ntfs()
{
    ntfs_t *f = malloc(sizeof(ntfs_t)); // aparentemente son
    // printf("%zu\n",sizeof(ntfs_t));
    *f = 3;
    return f;
}

// como es un uint se copia por valor asi
fat32_t *copy_fat32(fat32_t *file)
{
    fat32_t *f = malloc(sizeof(fat32_t));
    *f = *file;
    return f;
}

ext4_t *copy_ext4(ext4_t *file)
{
    ext4_t *f = malloc(sizeof(ext4_t));
    *f = *file;
    return f;
}

ntfs_t *copy_ntfs(ntfs_t *file)
{
    ntfs_t *f = malloc(sizeof(ntfs_t));
    *f = *file;
    return f;
}

void rm_fat32(fat32_t *file) { free(file); }
void rm_ext4(ext4_t *file) { free(file); }
void rm_ntfs(ntfs_t *file) { free(file); }