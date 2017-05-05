PROGRAM := yaml2bash
VERSION := $(shell sed -ne "s/^\#define Y2B_VERSION \"\(.*\)\"/\1/p" src/version.h)
ARCHIVE := $(PROGRAM)-$(VERSION)-Linux-armhf.tar.gz

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

$(ARCHIVE): $(PROGRAM)
	tar zcvf $(ARCHIVE) $(PROGRAM)

$(PROGRAM):
	docker build -t $(PROGRAM):static-armhf -f Dockerfile.armhf .
	docker create --name $(PROGRAM) $(PROGRAM):static-armhf
	docker cp $(PROGRAM):/work/$(PROGRAM) $(PROGRAM)
	docker rm $(PROGRAM)

distclean:
	$(RM) $(PROGRAM) $(ARCHIVE)

.PHONY: release distclean

docker: $(PROGRAM)
	cp $(PROGRAM) ./docker/$(PROGRAM)
	docker build -t $(PROGRAM):armhf docker
	$(RM) ./docker/$(PROGRAM)

push: docker
	docker tag $(PROGRAM):armhf ailispaw/$(PROGRAM):$(VERSION)-armhf
	docker tag $(PROGRAM):armhf ailispaw/$(PROGRAM):armhf
	docker push ailispaw/$(PROGRAM):$(VERSION)-armhf
	docker push ailispaw/$(PROGRAM):armhf

.PHONY: docker push
