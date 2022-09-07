#!/bin/sh

mkdir build

cd xsh
make
cp xsh xshwatch  xshguardian ../build
cd ..

cd trigrammr
go get github.com/donomii/trigrammr github.com/chzyer/readline
go build cmd/trigrammr-import-csv/trigrammr-import-csv.go
go build cmd/trigrammr-client/trigrammr-client.go
go build cmd/trigrammr-import-book/trigrammr-import-book.go 
cp trigrammr-import-book trigrammr-client trigrammr-import-csv ../build
cd ..

cd pmoo
make
cp pmoo queue xshguardian ../build
cd ..