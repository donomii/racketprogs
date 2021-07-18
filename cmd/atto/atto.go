package main

import (
	"flag"
	"io/ioutil"
	"log"
	"os"

	atto "../.."
)

func main() {
	var debug bool
	flag.BoolVar(&debug, "debug", false, "Print looots of debug information")
	flag.Parse()
	if !debug {
		log.SetFlags(0)
		log.SetOutput(ioutil.Discard)
	}
	a := atto.NewAtto()
	atto.LoadFile(os.Args[1], a)
	atto.RunFunc("main", a)
}
