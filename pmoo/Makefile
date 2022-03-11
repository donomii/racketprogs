all: deps build init install

deps:
	go get -v "github.com/google/uuid" "github.com/gin-gonic/gin" "github.com/philippgille/gokv/badgerdb" "github.com/donomii/throfflib"

clean:
	rm -r build

build: *.go Makefile ../xsh/main.go ../xsh/stdlib.xsh ../pmoolib/main.go ../xsh/*
	mkdir build || true
	mkdir build/objects || true
	go build -o build/pmoo -v .
	go build -o build/queue -v ../queue/

init:
	cd build && ./pmoo --init
	cd build && cat ../create.txt | ./pmoo --batch --debug

localinstall: build
	cp build/pmoo ~/.local/bin/
	cp build/pmoo ~/.local/bin/p
	cp build/queue ~/.local/bin/

install: build
	cp build/pmoo /usr/local/bin/
	cp build/pmoo /usr/local/bin/p
	cp build/queue /usr/local/bin/

run:
	./pmoo

