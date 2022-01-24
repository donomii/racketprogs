all: clean xsh guardian

xsh:./cmd/xsh/main.go
	go build ./cmd/xsh

guardian:./cmd/guardian/main.go
	go build ./cmd/guardian

install: xsh guardian
	mkdir -p ~/.local/bin
	cp xsh ~/.local/bin/
	cp guardian ~/.local/bin/

clean:
	rm xsh guardian || true
