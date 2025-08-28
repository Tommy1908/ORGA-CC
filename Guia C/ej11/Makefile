CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = rotar1

all: $(TARGET)

$(TARGET): rotar1.o
	$(CC) $(CFLAGS) $^ -o $@

rotar1.o: rotar1.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
