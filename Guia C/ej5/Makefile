CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = float_cast

all: $(TARGET)

$(TARGET): float_cast.o
	$(CC) $(CFLAGS) $^ -o $@

float_cast.o: float_cast.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
