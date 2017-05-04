PROGRAM := yaml2bash
VERSION := $(shell sed -ne "s/^\#define VERSION \"\(.*\)\"/\1/p" src/version.h)
ARCHIVE := $(PROGRAM)-$(VERSION)-Linux-x86_64.tar.gz

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	WORK_DIR := $(CURDIR)
else
	WORK_DIR := "/vagrant"
endif

image:
	docker build -t $(PROGRAM):work .

ssh: | image
	docker run -it --rm -v $(WORK_DIR):/work $(PROGRAM):work

clean:
	docker run --rm -v $(WORK_DIR):/work $(PROGRAM):work make -C src clean

.PHONY: build test ssh image clean

release: $(ARCHIVE)

$(ARCHIVE):
	docker build -t $(PROGRAM):static -f Dockerfile.static .
	docker create --name $(PROGRAM) $(PROGRAM):static
	docker cp $(PROGRAM):/work/$(PROGRAM) $(PROGRAM)
	docker rm $(PROGRAM)
	tar zcvf $(ARCHIVE) $(PROGRAM) lib/$(PROGRAM).bash

distclean:
	$(RM) $(PROGRAM) $(ARCHIVE)

.PHONY: release distclean
