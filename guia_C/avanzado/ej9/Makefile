CC = gcc
CFLAGS = -Wall -Wextra -pedantic
TARGET = binario

all: $(TARGET)

SRCS = mayus.c
OBJS = $(SRCS:.c=.o)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@
	
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
	
-include £(OBJS:.o=.d)

clean:
	rm *.o $(TARGET) *.d
	
.PHONY: all clean