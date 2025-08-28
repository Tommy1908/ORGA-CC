CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = scope2_2

all: $(TARGET)

$(TARGET): scope2_2.o
	$(CC) $(CFLAGS) $^ -o $@

scope2_2.o: scope2_2.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
