all: clean deps build localinstall install

deps:
	go get -v "github.com/arkady-emelyanov/go-shellparse" "github.com/nightlyone/lockfile" "github.com/donomii/goof"

clean:
	rm -r build || true
	rm -r logs || true

build: *.go Makefile 
	mkdir build || true
	go build -o build/nursemaid -v .

localinstall: build
	mkdir -p ~/.local/bin || true
	mkdir -p ~/.local/etc/nursemaid || true
	cp build/nursemaid ~/.local/bin/nursemaid
	cp -n services.txt ~/.local/etc/nursemaid/services.txt || true
	echo "nursemaid installed in ~/.local/bin/nursemaid"
	echo "Add ~/.local/bin to your PATH"


install: build
	mkdir /etc/nursemaid || true
	cp build/nursemaid ~/.local/bin/nursemaid
	cp -n services.txt ~/.local/etc/nursemaid/services.txt | true

run:
	~/.local/bin/nursemaid

