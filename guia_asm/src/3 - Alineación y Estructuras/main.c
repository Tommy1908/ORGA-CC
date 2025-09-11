#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Estructuras.h"

int main()
{

    lista_t *lista = malloc(sizeof(lista_t));
    lista->head = NULL;

    // Nodo 1
    nodo_t *n1 = malloc(sizeof(nodo_t));
    uint32_t *arr1 = malloc(3 * sizeof(uint32_t));
    arr1[0] = 1;
    arr1[1] = 2;
    arr1[2] = 3;
    n1->categoria = 1;
    n1->arreglo = arr1;
    n1->longitud = 3;
    n1->next = NULL;

    // Nodo 2
    nodo_t *n2 = malloc(sizeof(nodo_t));
    uint32_t *arr2 = malloc(2 * sizeof(uint32_t));
    arr2[0] = 10;
    arr2[1] = 20;
    n2->categoria = 2;
    n2->arreglo = arr2;
    n2->longitud = 2;
    n2->next = NULL;

    lista->head = n1;
    n1->next = n2;

    uint32_t r;
    r = cantidad_total_de_elementos(lista);
    printf("%d\n", r);

    // liberar memoria
    free(arr1);
    free(n1);
    free(arr2);
    free(n2);
    free(lista);

    packed_lista_t *plista = malloc(sizeof(packed_lista_t));
    plista->head = NULL;

    // Nodo 1
    packed_nodo_t *pn1 = malloc(sizeof(packed_nodo_t));
    uint32_t *parr1 = malloc(4 * sizeof(uint32_t));
    parr1[0] = 1;
    parr1[1] = 2;
    parr1[2] = 3;
    parr1[3] = 4;
    pn1->categoria = 1;
    pn1->arreglo = parr1;
    pn1->longitud = 4;
    pn1->next = NULL;

    // Nodo 2
    packed_nodo_t *pn2 = malloc(sizeof(packed_nodo_t));
    uint32_t *parr2 = malloc(3 * sizeof(uint32_t));
    parr2[0] = 10;
    parr2[1] = 20;
    parr2[2] = 30;
    pn2->categoria = 2;
    pn2->arreglo = parr2;
    pn2->longitud = 3;
    pn2->next = NULL;

    plista->head = pn1;
    pn1->next = pn2;

    uint32_t pr;
    pr = cantidad_total_de_elementos_packed(plista);
    printf("%d\n", pr);

    // liberar memoria
    free(parr1);
    free(pn1);
    free(parr2);
    free(pn2);
    free(plista);
    return 0;
}
