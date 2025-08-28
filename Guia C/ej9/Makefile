CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = tres_mas_significativos

all: $(TARGET)

$(TARGET): tres_mas_significativos.o
	$(CC) $(CFLAGS) $^ -o $@

tres_mas_significativos.o: tres_mas_significativos.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
