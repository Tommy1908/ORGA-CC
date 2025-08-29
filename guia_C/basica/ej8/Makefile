CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = masmas

all: $(TARGET)

$(TARGET): masmas.o
	$(CC) $(CFLAGS) $^ -o $@

masmas.o: masmas.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
