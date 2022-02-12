all: clean xsh xshguardian xshwatch

xsh:./cmd/xsh/main.go
	go build ./cmd/xsh

xshguardian:./cmd/xshguardian/main.go
	go build ./cmd/xshguardian

xshwatch:../watcher/main.go
	go build -o xshwatch ../watcher

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
	rm xsh xshguardian xshwatch || true
