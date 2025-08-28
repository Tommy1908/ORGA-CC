CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = data_size_stdint

all: $(TARGET)

$(TARGET): data_size_stdint.o
	$(CC) $(CFLAGS) $^ -o $@

data_size_stdint.o: data_size_stdint.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm *.o $(TARGET)

.PHONY: all clean
