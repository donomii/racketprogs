package main

import (
	"flag"
	"fmt"
	"github.com/chzyer/readline"
	"github.com/donomii/goof"
	"io"
	"io/ioutil"
	"os"
	"strconv"
	"strings"

	autoparser "../.."
)

var globals map[string]string = map[string]string{}
var wholeTree []autoparser.Node

func main() {
	fname := flag.String("f", "main.go", "File to execute")
	wantShell := flag.Bool("shell", false, "Run interactive shell")
	flag.Parse()
	if *wantShell {
		shell()
	} else {

		f := autoparser.LoadFile(*fname)
		tree := autoparser.ParseTcl(f)
		fmt.Printf("%+v\n", tree)
		wholeTree = tree
		fmt.Printf("treeReduce: %+v\n", treeReduce(tree, nil))
		autoparser.PrintTree(tree, 0, false)
		json := TreeToJson(tree)

		fmt.Println(json)
	}
}

func NodeToString(v autoparser.Node) string {
	if v.Raw == "" {
		return v.Str
	} else {
		return v.Raw
	}
}
func ListToArray(l []autoparser.Node) []string {
	out := []string{}
	for _, v := range l {
		if v.List != nil {
			panic("ListToArray: List cannot be converted to array")
		}
		out = append(out, NodeToString(v))
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
func eval(command []string, parent *autoparser.Node) autoparser.Node {
	if len(command) == 0 {
		return autoparser.Node{}
	}
	fmt.Println("Evaluating: ", command)
	f := command[0]
	args := command[1:]
	switch f {
	case "cd":
		os.Chdir(args[0])
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
	case "saveInterpreter":
		*parent = autoparser.Node{"", "", nil, "VOID"}
		os.WriteFile(args[0], []byte(TreeToJson(wholeTree)), 0644)
	default:
		fmt.Printf("Unknown command: %s, attempting shell\n", f)
		res, _ := goof.QC(command)
		return N(res)
	}

	return autoparser.Node{Note: "VOID"}
}
func treeReduce(t []autoparser.Node, parent *autoparser.Node) autoparser.Node {
	out := []autoparser.Node{}
	for i, v := range t {
		switch {
		case v.List != nil:
			atom := treeReduce(v.List, &t[i])
			out = append(out, atom)
			t[i] = atom
		default:
			var atom autoparser.Node
			if strings.HasPrefix(v.Raw, "$") {
				fmt.Printf("Globals: %+v\n", globals)
				atom = N(globals[v.Raw[1:]])
			} else {
				atom = v
			}
			out = append(out, atom)
			t[i] = atom
		}
	}

	//Run command
	command := ListToArray(out)
	return eval(command, parent)
}

func TreeToJson(t []autoparser.Node) string {
	out := ""
	for _, v := range t {
		switch {
		case v.Note == "VOID":
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

// Function constructor - constructs new function for listing given directory
func listFiles(path string) func(string) []string {
	return func(line string) []string {
		names := make([]string, 0)
		files, _ := ioutil.ReadDir(path)
		for _, f := range files {
			names = append(names, f.Name())
		}
		return names
	}
}

func listPathExecutables(path string) func(string) []string {
	return func(line string) []string {
		return []string{}
	}
}

func listBuiltins() func(string) []string {
	return func(line string) []string {
		return []string{"puts", "+", "loadfile", "set", "run"}
	}
}
func shell() {
	var completer = readline.NewPrefixCompleter(
		readline.PcItem("mode"),
		readline.PcItemDynamic(listPathExecutables("."),
			readline.PcItemDynamic(listFiles("./"))),
		readline.PcItemDynamic(listBuiltins(),
			readline.PcItemDynamic(listFiles("./"))),
	)
	l, err := readline.NewEx(&readline.Config{
		Prompt:          "\033[31m»\033[0m ",
		HistoryFile:     "/tmp/readline.tmp",
		AutoComplete:    completer,
		InterruptPrompt: "^C",
		EOFPrompt:       "exit",
	})
	if err != nil {
		panic(err)
	}
	defer l.Close()
	for {
		line, err := l.Readline()
		if err == readline.ErrInterrupt {
			if len(line) == 0 {
				break
			} else {
				continue
			}
		} else if err == io.EOF {
			break
		}

		line = strings.TrimSpace(line)
		tree := autoparser.ParseTcl(line)
		fmt.Printf("Result: %+v\n", NodeToString(treeReduce(tree, nil)))
	}
}
