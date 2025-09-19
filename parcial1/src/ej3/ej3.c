#include "../ejs.h"

tuit_t **trendingTopic(usuario_t *user,uint8_t (*esTuitSobresaliente)(tuit_t *)) {
    
    int count = 0;
    publicacion_t *publi = user->feed->first;
    while(publi != 0){
        if(publi->value->id_autor == user->id){
            if(esTuitSobresaliente(publi->value) == 1){
                count++;
            }
        }
        publi = publi->next;
    }

    if(count == 0){
        return NULL;
    }

    tuit_t* *array = malloc(sizeof(tuit_t)*count);
    publi = user->feed->first;
    int i = 0;
    while(publi != 0){
        if(publi->value->id_autor == user->id){
            if(esTuitSobresaliente(publi->value) == 1){
                array[i] = publi->value;
                i++;
            }
        }
        publi = publi->next;
    }
    
    
    return array;
}

