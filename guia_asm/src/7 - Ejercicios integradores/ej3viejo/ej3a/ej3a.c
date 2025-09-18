#include "../ejs.h"

// Función auxiliar para contar casos por nivel
void contar_casos_por_nivel(caso_t* arreglo_casos, int largo, int* contadores) {
    for(int i = 0; i < largo; i++){
        usuario_t *user = arreglo_casos[i].usuario;
        uint32_t nivel = user->nivel;
        switch (nivel)
        {
        case 0:
            contadores[0]++;
            break;
        case 1:
            contadores[1]++;
            break;
        case 2:
            contadores[2]++;
            break;
        default:
            break;
        }
    }
}

//recorrer todo 2 veces no debe ser muy efectivo pero bueno
segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo) {
    int* contadores = malloc(sizeof(int)*3);
    contadores[0] = 0;
    contadores[1] = 0;
    contadores[2] = 0;
    contar_casos_por_nivel(arreglo_casos, largo, contadores);

    segmentacion_t* segmentacion = malloc(sizeof(segmentacion_t));
    caso_t* c0 = NULL;
    caso_t* c1 = NULL;
    caso_t* c2 = NULL;
    if(contadores[0]!= 0){
        c0 = malloc(sizeof(caso_t) * contadores[0]);}

    if(contadores[1]!= 0){
        c1 = malloc(sizeof(caso_t) * contadores[1]);}
        
    if(contadores[2]!= 0){
        c2 = malloc(sizeof(caso_t) * contadores[2]);}

    segmentacion->casos_nivel_0 = c0;
    segmentacion->casos_nivel_1 = c1;
    segmentacion->casos_nivel_2 = c2;

    int64_t i0,i1,i2;
    i0 = 0;
    i1 = 0;
    i2 = 0;

    for(int i = 0; i < largo; i++){
        usuario_t *user = arreglo_casos[i].usuario;
        uint32_t nivel = user->nivel;

        switch (nivel)
        {
        case 0:
            c0[i0] = arreglo_casos[i];
            i0++;
            break;
        case 1:
            c1[i1] = arreglo_casos[i];
            i1++;
            break;
        case 2:
            c2[i2] = arreglo_casos[i];
            i2++;
            break;
        default:
            break;
        }
    }
    free(contadores);
    return segmentacion;
}



