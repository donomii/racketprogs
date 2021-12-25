package main

import (
	autoparser "../.."
	"flag"
)

func main() {
	fname := flag.String("f", "main.go", "File to parse")
	flag.Parse()
	f := autoparser.LoadFile(*fname)
	tree := autoparser.ParseGo(f)
	autoparser.PrintTree(tree, 0, false)
}
