CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = scopes

all: $(TARGET)

$(TARGET): scopes.o
	$(CC) $(CFLAGS) $^ -o $@

scopes.o: scopes.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
