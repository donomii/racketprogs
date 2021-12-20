all: deps build install

deps:
	go get -v "github.com/google/uuid" "github.com/gin-gonic/gin" "github.com/philippgille/gokv/badgerdb" "github.com/donomii/throfflib"

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
	cp build/pmoo ~/.local/bin/
	cp build/pmoo ~/.local/bin/p
	cp build/queue ~/.local/bin/

run:
	./pmoo

