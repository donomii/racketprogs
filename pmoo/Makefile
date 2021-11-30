all: deps build install

deps:
	go get -u -v "github.com/google/uuid" "github.com/gin-gonic/gin" "github.com/philippgille/gokv/badgerdb" "github.com/donomii/throfflib"

clean:
	rm -r build

build: *.go
	mkdir build || true
	mkdir build/objects || true
	go build -o build/pmoo -v .
	go build -o build/queue -v ../queue/
	cd build && ./pmoo --init
	cd build && cat ../create.txt | ./pmoo --batch --debug

install: build
	cp pmoo ~/.local/bin/
	cp pmoo ~/.local/bin/p
	cp queue ~/.local/bin/

run:
	./pmoo

