package main

import "C"

import (
	xsh "../.."
)

var Interpreter *xsh.State = nil

//export XshInit
func XshInit() {
	I := xsh.New()
	Interpreter = &I
}

//export XshEval
func XshEval(ccode, cfilename *C.char) *C.char {
	code := C.GoString(ccode)
	filename := C.GoString(cfilename)
	if Interpreter == nil {
		panic("Xsh interpreter not initialised")
	}

	result := xsh.Eval(*Interpreter, code, filename)
	str := xsh.S(result)
	return C.CString(str)
}

func main() {}
