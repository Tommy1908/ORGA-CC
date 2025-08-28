CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = scope2_1

all: $(TARGET)

$(TARGET): scope2_1.o
	$(CC) $(CFLAGS) $^ -o $@

scope2_1.o: scope2_1.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
