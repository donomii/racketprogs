package main

import (
	"fmt"
	"log"
	"os"
)

type memimage struct {
	size      int
	data      []byte
	floatdata []float64
}

func newImage(size int) *memimage {
	return &memimage{size: size, data: make([]byte, DetailLength*size*size), floatdata: make([]float64, DetailLength*size*size)}
}

func (i *memimage) Save() {
	f, err := os.Create(*outputfile)
	if err != nil {
		log.Panic(err)
	}
	defer f.Close()

	fmt.Fprintf(f, "P6 %v %v 255 ", i.size, i.size)
	if _, err := f.Write(i.data); err != nil {
		log.Panic(err)
	}
}
