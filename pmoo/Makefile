all: deps build init install

deps:
	go get -v "github.com/google/uuid" "github.com/gin-gonic/gin" "github.com/philippgille/gokv/badgerdb" "github.com/donomii/throfflib" github.com/nsf/termbox-go github.com/pterm/pterm github.com/traefik/yaegi

clean:
	rm -r build

build: *.go Makefile ../xsh/main.go ../xsh/stdlib.xsh ../pmoolib/* ../xsh/* ../queue/*
	mkdir build || true
	mkdir build/objects || true
	go build -o build/pmoo -v .
	go build -o build/queue -v ../queue/
	go build -o build/xshguardian -v ../xsh/cmd/xshguardian/

init:
	cd build && ./pmoo --init
	cd build && cat ../create.txt | ./pmoo  --debug --raw --batch

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

