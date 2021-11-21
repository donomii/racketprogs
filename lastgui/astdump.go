package main

import (
	"fmt"
	"io/ioutil"

	"github.com/lu4p/astextract"
)

func main() {
	code, _ := ioutil.ReadFile("astdump.go")
	f, err := astextract.Parse(string(code))
	if err != nil {
		panic(err)
	}

	fmt.Printf("%+v\n", f)

}
