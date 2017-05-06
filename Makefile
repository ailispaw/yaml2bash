PROGRAM := yaml2bash
VERSION := $(shell sed -ne "s/^\#define Y2B_VERSION \"\(.*\)\"/\1/p" src/version.h)
ARCHIVE := $(PROGRAM)-$(VERSION)-Linux-x86_64.tar.gz

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	WORK_DIR := $(CURDIR)
else
	WORK_DIR := "/vagrant"
endif

image:
	docker build -t $(PROGRAM):work -f Dockerfile.work .

ssh: | image
	docker run -it --rm -v $(WORK_DIR):/work $(PROGRAM):work

clean:
	docker run --rm -v $(WORK_DIR):/work $(PROGRAM):work make -C src clean

.PHONY: image ssh clean

release: $(ARCHIVE)

$(ARCHIVE): $(PROGRAM) lib/$(PROGRAM).bash
	tar zcvf $(ARCHIVE) $(PROGRAM) lib/$(PROGRAM).bash

$(PROGRAM):
	docker build -t $(PROGRAM):static -f Dockerfile.static .
	docker create --name $(PROGRAM) $(PROGRAM):static
	docker cp $(PROGRAM):/work/$(PROGRAM) $(PROGRAM)
	docker rm $(PROGRAM)

distclean:
	$(RM) $(PROGRAM) $(ARCHIVE)

.PHONY: release distclean

docker: $(PROGRAM)
	cp $(PROGRAM) ./docker/$(PROGRAM)
	docker build -t $(PROGRAM):latest docker
	$(RM) ./docker/$(PROGRAM)

push: docker
	docker tag $(PROGRAM):latest ailispaw/$(PROGRAM):$(VERSION)
	docker tag $(PROGRAM):latest ailispaw/$(PROGRAM):latest
	docker push ailispaw/$(PROGRAM):$(VERSION)
	docker push ailispaw/$(PROGRAM):latest

.PHONY: docker push
