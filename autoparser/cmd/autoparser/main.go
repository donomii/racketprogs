package main

import (
	"errors"
	"flag"
	"fmt"
	"log"
	"runtime"
	"strconv"

	//"github.com/lmorg/readline"

	"github.com/donomii/goof"

	autoparser "../.."
)

var guardianPath string

type function struct {
	Name string
	Args []autoparser.Node
	Body []autoparser.Node
}

var (
	wantDebug bool
	functions = map[string]function{}
)

var (
	globals   map[string]string = map[string]string{}
	wholeTree []autoparser.Node
	wantShell bool
)

func drintf(formatStr string, args ...interface{}) {
	if wantDebug {
		log.Printf(formatStr, args...)
	}
}

func main() {
	bindir := goof.ExecutablePath()
	if runtime.GOOS == "windows" {
		guardianPath = bindir + "/guardian.exe"
	} else {
		guardianPath = bindir + "/guardian"
	}

	/*
		fname = flag.String("f", "example.xsh", "Script file to execute")
		shellOpt := flag.Bool("shell", false, "Run interactive shell")
	*/

	flag.BoolVar(&wantDebug, "debug", false, "Enable debug output")
	flag.Parse()
	sourceFile := flag.Args()[0]
	switch {
	case sourceFile != "":
		fmt.Println("Resuming from file: ", sourceFile)
		f := autoparser.LoadFile(sourceFile)
		tree := autoparser.ParseGo(f, sourceFile)
		drintf("%+v\n", tree)

		autoparser.PrintTree(tree, 0, false)

	default:

		f := autoparser.LoadFile(sourceFile)
		tree := autoparser.ParseGo(f, sourceFile)
		drintf("%+v\n", tree)
		autoparser.PrintTree(tree, 0, false)
	}
}

func NodeToString(v autoparser.Node) string {
	if v.Raw == "" {
		return v.Str
	} else {
		return v.Raw
	}
}

func ListToString(l []autoparser.Node) ([]string, error) {
	out := []string{}
	for _, v := range l {
		if v.List != nil {
			return nil, errors.New(fmt.Sprintf("ListToArray: List cannot be converted to string array: %+v\n", l))
		} else {
			out = append(out, NodeToString(v))
		}
	}
	return out, nil
}

// This is ridiculous
func ato(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}

func N(s string) autoparser.Node {
	return autoparser.Node{Str: s}
}

// Testing nested strings like" this
/* And
// this */
func NN(s string) string {
	return "//" + "/*"
}
