all: deps build install

deps:
	go get -u -v "github.com/google/uuid" "github.com/gin-gonic/gin" "github.com/philippgille/gokv/badgerdb" "github.com/donomii/throfflib"

build:
	go build -v .
	go build -v ../queue/

install: build
	cp pmoo ~/.local/bin/
	cp pmoo ~/.local/bin/p
	cp queue ~/.local/bin/

run:
	./pmoo

