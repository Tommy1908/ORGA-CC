CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = data_size

all: $(TARGET)

$(TARGET): data_size.o
	$(CC) $(CFLAGS) $^ -o $@

data_size.o: data_size.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
