#include "../ejs.h"
#include <string.h>

// Función principal: publicar un tuit


publicacion_t* crear_publi(tuit_t *tuit, feed_t *feed){


  publicacion_t *publicacion = feed->first;

  publicacion_t *nueva = malloc(sizeof(publicacion_t));

  nueva->next = feed->first;
  nueva->value = tuit;
  return nueva;
}

tuit_t *publicar(char *mensaje, usuario_t *user) {

  //crear tuit
  tuit_t *tuit = malloc(sizeof(tuit_t));
  
  //copiar mensaje
  for(int i= 0; i<140;i++){
    if(mensaje[i]==0){
      tuit->mensaje[i] = 0;
      break;
    }
    tuit->mensaje[i] = mensaje[i];
  }
  tuit-> retuits = 0;
  tuit-> favoritos = 0;
  tuit-> id_autor = user->id;

  //lo agrego a mi feed
  publicacion_t *publi = crear_publi(tuit, user->feed);
  user->feed->first = publi;

  for(uint32_t i = 0; i < user->cantSeguidores;i++){
    publicacion_t *publicacion = crear_publi(tuit, user->seguidores[i]->feed);
    usuario_t *seguidor = user->seguidores[i];
    seguidor->feed->first = publicacion;
  }

  return tuit;
  
}

