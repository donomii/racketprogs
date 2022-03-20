	set GO111MODULE=auto
	go get -v "github.com/google/uuid" "github.com/gin-gonic/gin" "github.com/philippgille/gokv/badgerdb" "github.com/donomii/throfflib"
	mkdir build
	go build -o build/pmoo.exe -v .
	go build -o build/queue.exe -v ../queue/
	cd build 
	mkdir objects
	pmoo --init
	type ..\create.txt | pmoo --raw --debug
