CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = analizar

all: $(TARGET)

$(TARGET): analizar.o
	$(CC) $(CFLAGS) $^ -o $@

analizar.o: analizar.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
