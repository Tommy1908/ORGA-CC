all: 01_hola

01_hola: 01_hola.o
	gcc -Wall -Wall -Wextra -pedantic 01_hola.o -o 01_hola

01_hola.o: 01_hola.c
	gcc -Wall -Wextra -pedantic -c 01_hola.c -o 01_hola.o
	
clean:
	rm *.o 01_hola
	
.PHONY: all clean
	
