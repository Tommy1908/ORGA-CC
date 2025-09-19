#include "../ejs.h"

void borrar_publis(feed_t *feed, uint32_t id){
  
  if(feed->first != 0){
    publicacion_t *publi = feed->first;
    while(publi != 0 && publi->value->id_autor == id){
      feed->first = publi->next;
      free(publi);
      publi = feed->first;
    }
    //el primero esta bien ya
    publicacion_t *borrar;
    while(publi != 0 && publi->next != 0){
      if(publi->next->value->id_autor == id){
        borrar = publi->next;
        publi->next = publi->next->next;
        publi = publi->next->next;
        
        free(borrar);
      }
      else{
        publi->next = publi->next;
        publi = publi->next;
      }
    }
  }
  return;
}


void bloquearUsuario(usuario_t *usuario, usuario_t *usuarioABloquear){

  //primero de a -> b
  feed_t *user_feed = usuario->feed;
  uint32_t id = usuarioABloquear-> id;
  borrar_publis(user_feed , id);
  uint32_t cantbloqueado = usuario->cantBloqueados;
  usuario->bloqueados[cantbloqueado] = usuarioABloquear;
  usuario->cantBloqueados++;

  //de b -> a
  user_feed = usuarioABloquear->feed;
  id = usuario->id;
  borrar_publis(user_feed, id);

  return;
}

