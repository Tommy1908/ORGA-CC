CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = test

all: $(TARGET)

$(TARGET): test.o
	$(CC) $(CFLAGS) $^ -o $@

test.o: test.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
