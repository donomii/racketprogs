all: clean deps xsh xshguardian xshwatch libxsh localinstall install

deps:
	go get -v .
	go get -v github.com/donomii/termbox-go github.com/mitchellh/go-homedir github.com/radovskyb/watcher

xsh:./cmd/xsh/main.go ./*.go
	go build ./cmd/xsh

xshguardian:./cmd/xshguardian/main.go ./*.go
	go build ./cmd/xshguardian

xshwatch:../watcher/main.go ./*.go
	go build -o xshwatch ../watcher

libxsh:./cmd/libxsh/libxsh.go ./*.go
	go build -buildmode c-shared -o libxsh.so ./cmd/libxsh
	gcc -L. -lxsh -o testxshCbridge ./cmd/libxshtest/test.c

localinstall: xsh xshguardian xshwatch
	mkdir -p ~/.local/bin
	cp xsh ~/.local/bin/
	cp xshguardian ~/.local/bin/
	cp xshwatch ~/.local/bin

install: xsh xshguardian xshwatch
	cp xsh /usr/local/bin/
	cp xshguardian /usr/local/bin/
	cp xshwatch /usr/local/bin


clean:
	rm xsh xshguardian xshwatch libxsh.h libxsh.so || true
