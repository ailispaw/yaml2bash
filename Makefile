up:
	vagrant up

build:
	docker run --rm -v /vagrant/lib:/src yaml2bash make

test:
	docker run --rm -v /vagrant:/src yaml2bash ./test.sh

ssh:
	docker run -it --rm -v /vagrant:/src yaml2bash

clean:
	docker run --rm -v /vagrant/lib:/src yaml2bash make clean

.PHONY: up build test ssh clean
