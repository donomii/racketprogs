	go get -v "github.com/google/uuid" "github.com/gin-gonic/gin" "github.com/philippgille/gokv/badgerdb" "github.com/donomii/throfflib"
	mkdir build
	mkdir build/objects
	go build -o build/pmoo -v .
	go build -o build/queue -v ../queue/
	cd build 
	./pmoo --init
	type ../create.txt | ./pmoo --batch --debug
