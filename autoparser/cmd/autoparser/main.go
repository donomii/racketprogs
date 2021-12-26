package main

import (
	"flag"
	"fmt"
	"github.com/donomii/goof"
	"os"
	"strconv"
	"strings"

	autoparser "../.."
)

var globals map[string]string = map[string]string{}

func main() {
	fname := flag.String("f", "main.go", "File to parse")
	flag.Parse()
	f := autoparser.LoadFile(*fname)
	tree := autoparser.ParseTcl(f)
	fmt.Printf("treeReduce: %+v\n", treeReduce(tree))
	autoparser.PrintTree(tree, 0, false)
	json := TreeToJson(tree)

	fmt.Println(json)
}

func ListToArray(l []autoparser.Node) []string {
	out := []string{}
	for _, v := range l {
		if v.List != nil {
			panic("ListToArray: List cannot be converted to array")
		}
		if v.Raw == "" {
			out = append(out, v.Str)
		} else {
			out = append(out, v.Raw)
		}
	}
	return out
}

//This is ridiculous
func ato(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}
func N(s string) autoparser.Node {
	return autoparser.Node{Str: s}
}
func eval(command []string) autoparser.Node {
	if len(command) == 0 {
		return autoparser.Node{}
	}
	fmt.Println("Evaluating: ", command)
	f := command[0]
	args := command[1:]
	switch f {
	case "+":
		return N(fmt.Sprintf("%v", ato(args[0])+ato(args[1])))
	case "puts":
		fmt.Println(args[0])
	case "loadfile":
		b, _ := os.ReadFile(args[0])
		return N(string(b))
	case "set":
		if len(args) == 2 {
			globals[args[0]] = args[1]
		} else {
			return N(globals[args[0]])
		}
	case "run":
		res := goof.QCI(command[1:])
		if res == nil {
			return N("")
		} else {
			return N(fmt.Sprintf("%v", res))
		}
	default:
		fmt.Printf("Unknown command: %s, attempting shell\n", f)
		res, _ := goof.QC(command)
		return N(res)
	}

	return autoparser.Node{}
}
func treeReduce(t []autoparser.Node) autoparser.Node {
	out := []autoparser.Node{}
	for _, v := range t {
		switch {
		case v.List != nil:
			out = append(out, treeReduce(v.List))
		default:
			if strings.HasPrefix(v.Raw, "$") {
				fmt.Printf("Globals: %+v\n", globals)
				out = append(out, N(globals[v.Raw[1:]]))
			} else {
				out = append(out, v)
			}
		}
	}

	//Run command
	command := ListToArray(out)
	fmt.Print("Evaluating: ", command, "\n")
	return eval(command)
}

func TreeToJson(t []autoparser.Node) string {
	out := ""
	for _, v := range t {
		switch {
		case v.List != nil:
			out = out + "[" + TreeToJson(v.List) + "]"
		case v.Raw != "":
			out = out + "\"" + v.Raw + "\"" + " "

		default:
			out = out + "\"\\\"" + v.Str + "\\\"\"" + " "

		}

	}
	return out
}
