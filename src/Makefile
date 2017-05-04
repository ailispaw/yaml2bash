PROGRAM := yaml2bash

SRCS := main.c
OBJS := $(SRCS:%.c=%.o)
HDRS := version.h

CFLAGS  ?= -std=gnu99 -Wall -Werror -O3
LDFLAGS ?= -s
LIBS    := -lyaml

INSTALL_DIR ?= /usr/bin

ifdef DEBUG
	CFLAGS += -DDEBUG
endif

ifdef STATIC
	LDFLAGS += -static
endif

all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

%.o: %.c $(HDRS)
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

install: $(INSTALL_DIR)/$(PROGRAM)

$(INSTALL_DIR)/$(PROGRAM): $(PROGRAM)
	install -D -m 0755 $< $@ 

clean:
	$(RM) $(PROGRAM) $(OBJS)

.PHONY: all install clean
