CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = scope2_3

all: $(TARGET)

$(TARGET): scope2_3.o
	$(CC) $(CFLAGS) $^ -o $@

scope2_3.o: scope2_3.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
