#include "../ejs.h"

// Función auxiliar para contar casos por nivel
void contar_casos_por_nivel(caso_t* arreglo_casos, int largo, int* contadores) {
    //revisar que el puntero a usuario no sea
    for(int i = 0; i < largo; i++){
        uint32_t nivel = arreglo_casos[i].usuario->nivel;
        if(nivel == 0){
            contadores[0]++;
        }
        else if(nivel == 1){
            contadores[1]++;
        }
        else{
            contadores[2]++;
        }
        
    }
    return;
}


segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo) {

    int* contadores = malloc(32*3); //(3 ints), capaz es innecesario peeeero mas facil y comun a lo que venia haciendo
    contadores[0] = 0;
    contadores[1] = 0;
    contadores[2] = 0;
    contar_casos_por_nivel(arreglo_casos, largo, contadores);

    caso_t* c0 = NULL;
    caso_t* c1 = NULL;
    caso_t* c2 = NULL;

    if(contadores[0] !=0){
        c0 = malloc(sizeof(caso_t)*contadores[0]);
    }    
    if(contadores[1] !=0){
        c1 = malloc(sizeof(caso_t)*contadores[1]);
    }
    if(contadores[2] !=0){
        c2 = malloc(sizeof(caso_t)*contadores[2]);
    }



    int i0 = 0;
    int i1 = 0;
    int i2 = 0;

    for(int i = 0; i < largo; i++){
        uint32_t nivel = arreglo_casos[i].usuario->nivel;
        if(nivel == 0){
            c0[i0] = arreglo_casos[i];
            i0++;
        }
        else if(nivel == 1){
            c1[i1] = arreglo_casos[i];
            i1++;
        }
        else{
            c2[i2] = arreglo_casos[i];
            i2++;
        }
    }

    segmentacion_t* segmentacion = malloc(sizeof(segmentacion_t));
    segmentacion->casos_nivel_0 = c0;
    segmentacion->casos_nivel_1 = c1;
    segmentacion->casos_nivel_2 = c2;

    free(contadores);
    return segmentacion;
}



