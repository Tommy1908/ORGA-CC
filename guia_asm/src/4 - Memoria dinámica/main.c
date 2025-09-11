#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "../test-utils.h"
#include "Memoria.h"

char *strCloneEnC(char *a);

int main() {
	/* Acá pueden realizar sus propias pruebas */

	char a[] = "";
	char b[] = "";
	char c[] = "hola";
	char d[] = "abc";
	char e[] = "bcd";
	char f[] = "bcd";
	char g[] = "a";
	char h[] = "b";
	char i[] = "zz";
	char j[] = "abb";


	assert(strCmp(a,b) == 0); 
	assert(strCmp(a,c) == 1); 
	assert(strCmp(c,a) == -1); 
	assert(strCmp(d,d) == 0); 
	assert(strCmp(g,h) == 1); 
	assert(strCmp(h,g) == -1); 
	assert(strCmp(h,i) == 1); 
	assert(strCmp(d,e) == 1); 
	assert(strCmp("sar", "23") == -1); 
	//Con strings vacios aparentemente se rompe por el compilador

	

	char t1[] = "hola 123 !";
	char t2[] = "";
	char *c1 = strCloneEnC(t1);
	char *c2 = strCloneEnC(t2);

	printf("original:%s, copy:%s\n",t1,c1);
	printf("original:%s, copy:%s\n",t2,c2);
	free(c1);
	free(c2);

	//Con assembler
	c1 = strClone(t1);
	c2 = strClone(t2);
	printf("original:%s, copy:%s\n",t1,c1);
	printf("original:%s, copy:%s\n",t2,c2);
	free(c1);
	free(c2);

	return 0;
}

char *strCloneEnC(char *a){
		int count = 0;
		for(int i = 0; a[i] != 0; i++){
			count ++;
		}
		char *copy = (char *) malloc((count+1) * sizeof(char));
		for(int i = 0; i < count; i++){
			copy[i] = a[i];
		}
		copy[count] = '\0';
		//printf("a:%s, copy:%s\n",a,copy);
		return copy;
	}