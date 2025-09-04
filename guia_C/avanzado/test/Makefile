CC = gcc
CFLAGS = -Wall -Wextra -pedantic -MMD -MP -g
TARGET = binario

all: $(TARGET)

SRCS = test.c
OBJS = $(SRCS:.c=.o)

$(TARGET) : $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.CC
	$(CC) $(CFLAGS) -c $< -o $@

-include $(OBJS:.o=.d)

clean:
	rm *.o $(TARGET) *.d

.PHONY: all clean