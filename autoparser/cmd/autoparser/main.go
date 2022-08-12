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

	switch {
	case len(flag.Args()) > 0:
		sourceFile := flag.Args()[0]
		f := autoparser.LoadFile(sourceFile)
		tree := autoparser.ParseGo(f, sourceFile)
		drintf("%+v\n", tree)
		autoparser.PrintTree(tree, 0, false)

	default:
		testCSV()

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

func testCSV() {
	l := autoparser.NewTree(CSVdata(), "inline")
	// r, _ := Stringify(l, "//", "\n", "\\", "")
	// r, _ = Stringify(r, "\"", "\"", "\\", "")

	r := autoparser.KeywordBreak(l, []string{"\n"}, false)
	r = autoparser.KeywordBreak(r, []string{";"}, false)
	r = autoparser.MergeNonWhiteSpace(r)

	r = autoparser.StripWhiteSpace(r)
	// Need to split on spaces and merge before doing binops

	autoparser.PrintTree(r, 0, false)

	// fmt.Printf("%+v\n", r)
	// fmt.Println()
}

func CSVdata() string {
	return `Username; Identifier;One-time password;Recovery code;First name;Last name;Department;Location
booker12;9012;12se74;rb9012;Rachel;Booker;Sales;Manchester
grey07;2070;04ap67;lg2070;Laura;Grey;Depot;London
johnson81;4081;30no86;cj4081;Craig;Johnson;Depot;London
jenkins46;9346;14ju73;mj9346;Mary;Jenkins;Engineering;Manchester
smith79;5079;09ja61;js5079;Jamie;Smith;Engineering;Manchester`
}
