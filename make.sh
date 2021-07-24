#!/bin/sh

rm go.sum
rm go.mod
go mod init atto
go mod tidy

cd pkgreflect
go get github.com/donomii/goof
go build pkgreflect.go
cd ..
./pkgreflect/pkgreflect -stdout github.com/donomii/glim:../../go/src/github.com/donomii/glim  > registry.go
rm go.sum
rm go.mod
go mod init atto
go mod tidy
rm atto
echo $(pwd)
go get
go build cmd/atto/atto.go
