CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = ciclos

all: $(TARGET)

$(TARGET): ciclos.o
	$(CC) $(CFLAGS) $^ -o $@

ciclos.o: ciclos.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
