CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = rotarN

all: $(TARGET)

$(TARGET): rotarN.o
	$(CC) $(CFLAGS) $^ -o $@

rotarN.o: rotarN.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
