PROGRAM := yaml2bash

SRCS := yaml2bash.c
OBJS := $(SRCS:%.c=%.o)

CFLAGS := -std=gnu99 -Wall -Werror -O3
LDFLAGS := -s
LDLIBS := -lyaml

$(PROGRAM): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJS): $(SRC) version.h

clean:
	$(RM) $(PROGRAM) $(OBJS)

.PHONY: clean
