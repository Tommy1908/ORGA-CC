CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = dado

all: $(TARGET)

$(TARGET): dado.o
	$(CC) $(CFLAGS) $^ -o $@

dado.o: dado.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
