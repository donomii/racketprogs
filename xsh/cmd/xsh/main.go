package main

import (
	"errors"
	"flag"
	"fmt"

	"io"
	"io/ioutil"
	"runtime"

	"github.com/nsf/termbox-go"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/mattn/go-runewidth"

	"github.com/pterm/pterm"
	//"github.com/lmorg/readline"

	"github.com/chzyer/readline"
	"github.com/donomii/goof"
	_ "embed"

	autoparser "../../../autoparser"
)

var guardianPath string
var trace bool

//go:embed stdlib.xsh
var stdlib_str string

type function struct {
	Name string
	Args []autoparser.Node
	Body []autoparser.Node
}

var usePterm = true
var wantDebug bool
var functions = map[string]function{}

var globals map[string]string = map[string]string{}
var wholeTree []autoparser.Node
var wantShell bool

func drintf(formatStr string, args ...interface{}) {
	if wantDebug {
		log.Printf(formatStr, args...)
	}
}

func drintln(args ...interface{}) {
	if wantDebug {
		log.Println(args...)
	}
}

func Eval(code, fname string) autoparser.Node {
	fmt.Printf("Evalling: %v\n", code)
	tree := autoparser.ParseXSH(code, fname)
	//fmt.Printf("Tree: %v\n", tree)
	wholeTree = tree
	res := treeReduce(tree, nil, 2)
	//fmt.Printf("Res: %+v\n", res)
	return res
}
func LoadEval(fname string) autoparser.Node {
	return Eval(autoparser.LoadFile(fname), fname)
}

func main() {
	bindir := goof.ExecutablePath()
	if runtime.GOOS == "windows" {
		guardianPath = bindir + "/guardian.exe"
	} else {
		guardianPath = bindir + "/guardian"
	}

	/*
		fname := flag.String("f", "example.xsh", "Script file to execute")
		shellOpt := flag.Bool("shell", false, "Run interactive shell")
	*/
	resumeFile := flag.String("r", "", "Resume from file")
	tracef := flag.Bool("trace", false, "Trace execution")
	flag.BoolVar(&wantDebug, "debug", false, "Enable debug output")
	flag.Parse()
	trace = *tracef
	//wantShell=*shellOpt
	var fname string
	if len(flag.Args()) > 0 {
		fname = flag.Arg(0)
	} else {
		wantShell = true
	}

	switch {
	case *resumeFile != "":
		Eval(stdlib_str, "stdlib")
		LoadEval(*resumeFile)
	case wantShell:
		fmt.Printf("%+v\n", TreeToTcl( Eval(stdlib_str, "stdlib").List ))
		shell()
	default:
		Eval(stdlib_str, "stdlib")
		LoadEval(fname)
	}
}

func NodeToString(v autoparser.Node) string {
	if v.Raw == "" {
		return v.Str
	} else {
		return v.Raw
	}
}
func ListToStrings(l []autoparser.Node) ([]string, error) {
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

func ListToStr(l []autoparser.Node) string {
	str, _ := ListToStrings(l)
	out := strings.Join(str, " ")
	return out
}

//This is ridiculous
func atoi(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}

func atof(s string) float64 {
	i, _ := strconv.ParseFloat(s, 64)
	return i
}
func N(s string) autoparser.Node {
	return autoparser.Node{Str: s}
}
func CopyTree(t []autoparser.Node) []autoparser.Node {
	out := []autoparser.Node{}
	for _, v := range t {
		if v.List != nil {
			out = append(out, autoparser.Node{v.Raw, v.Str, CopyTree(v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File})
		} else {
			out = append(out, autoparser.Node{v.Raw, v.Str, v.List, v.Note, v.Line, v.Column, v.ChrPos, v.File})
		}
	}
	return out
}

func checkArgs(args []autoparser.Node, params []autoparser.Node) error {
	for _, v := range args {
		for _, p := range params {
			if p.Raw == v.Raw {
				panic(fmt.Sprintf("Cannot shadow args in lambda: %+v, %+v\n", v, p))
			}
		}
	}
	return nil
}

func ReplaceArg(args, params, t []autoparser.Node) []autoparser.Node {

	out := []autoparser.Node{}
	for _, v := range t {
		if v.List != nil {
			if v.Note == "|" {
				checkArgs(v.List, params)
			}
			out = append(out, autoparser.Node{v.Raw, v.Str, ReplaceArg(args, params, v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File})
		} else {
			replaced := 0
			for parami, param := range params {

				//drintf("Comparing function arg: %+v with node %+v\n", farg, v)
				//log.Printf("Comparing function arg: %+v with node %+v\n", args[parami].Raw, v.Raw)
				if param.Raw == v.Raw {
					//log.Printf("Replacing param %+v with %+v\n", param, args[parami])
					out = append(out, args[parami])
					//log.Printf("Inserting: %v\n", S(args[parami]))
					replaced = 1
				}
			}
			if replaced == 0 {
				out = append(out, CopyNode(v))
			}
		}
	}
	return out
}

func ReplaceArgs(args, params, t []autoparser.Node) []autoparser.Node {
	drintf("Replacing function params %+v with %+v\n", TreeToTcl(params), TreeToTcl(args))
	//log.Printf("Replacing function params %+v with %+v\n", TreeToTcl(params), TreeToTcl(args))

	t = ReplaceArg(args, params, t)

	return t
}

func S(n autoparser.Node) string {
	return NodeToString(n)
}

func FunctionsToTcl(functions map[string]function) string {
	out := ""
	for _, v := range functions {
		out += fmt.Sprintf("proc %s {%v} {\n", v.Name, TreeToTcl(v.Args))
		out += TreeToTcl(v.Body)
		out += "}\n"
	}
	return out
}
func runWithGuardian(cmd []string) error {
	drintf("Launching guardian for %+v from %v\n", cmd, guardianPath)
	cmd = append([]string{guardianPath}, cmd...)
	return goof.QCI(cmd)
}
func void(command autoparser.Node) autoparser.Node {
	drintf("Creating void at %+v\n", command.Line)
	if command.ChrPos < 1 {
		log.Println("Warning: Create void with no line number.  This is probably an error.")
	}
	return autoparser.Node{"", "", nil, "VOID", command.Line, command.Column, command.ChrPos, command.File}
}
func isList(n autoparser.Node) bool {
	return n.List != nil
}

func CopyNode(n autoparser.Node) autoparser.Node {
	return autoparser.Node{n.Raw, n.Str, n.List, n.Note, n.Line, n.Column, n.ChrPos, n.File}
}
func eval(command []autoparser.Node, parent *autoparser.Node, level int) autoparser.Node {
	if len(command) == 0 {
		return autoparser.Node{}
	}
	drintf("Evaluating: %v\n", command)
	//If list, assume it is a lambda function and evaluate it
	if isList(command[0]) {
		theLambdaFunction := command[0]
		args := command[1:]

		bod := CopyTree(theLambdaFunction.List[1:])
		params := theLambdaFunction.List[0].List
		if theLambdaFunction.List[0].Note == "|" {
			if theLambdaFunction.List[0].Note != "|" {
				panic("Not a lambda function: " + TreeToTcl(params))
				panic(fmt.Sprintf("Not a lambda function: %+v\n", theLambdaFunction))
			}
			if len(params) != len(args) {
				msg := fmt.Sprintf("Error %v,%v: Mismatched function args in ->|%v|<-  expected %v, given %v\n[%v %v]\n", command[0].Line, command[0].Column, TreeToTcl(command), TreeToTcl(params), TreeToTcl(args), S(theLambdaFunction), TreeToTcl(args))
				fmt.Printf(msg)
				os.Exit(1)
			}
			nbod := ReplaceArgs(args, params, bod)
			drintf("Calling lambda %+v\n", nbod)
			return blockReduce(nbod, parent, 0)
		}
	}

	//If it s a string or symbol, look it up in the global
	//functions map and return the result
	f := S(command[0])
	args := command[1:]
	fu, ok := functions[f]
	if ok {
		bod := CopyTree(fu.Body)
		fargs := fu.Args
		nbod := ReplaceArgs(args, fargs, bod)
		drintf("Calling function %+v\n", TreeToTcl(nbod))
		return blockReduce(nbod, parent, 0)
	} else {
		//It is a builtin function or an external call
		if f == "" {
			return void(command[0])
		}
		switch f {
		case "seq":
			//log.Printf("seq %v\n", TreeToTcl(args))
			return args[len(args)-1]
		case "cd":
			switch {
			case len(args) == 0:
				os.Setenv("OLDPWD", os.Getenv("PWD"))
				os.Chdir(os.Getenv("HOME"))
			case S(args[0]) == "-":
				oldpwd := os.Getenv("OLDPWD")
				os.Setenv("OLDPWD", os.Getenv("PWD"))
				os.Chdir(oldpwd)
			default:
				os.Setenv("OLDPWD", os.Getenv("PWD"))
				os.Chdir(S(args[0]))
			}
			if usePterm {
				header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgRed))
				pterm.DefaultCenter.Println(header.Sprint(goof.Cwd()))
			}
		case "\n":
			//Fuck
			return void(command[0])
		case "+":
			return N(fmt.Sprintf("%v", atoi(S(args[0]))+atoi(S(args[1]))))
		case "-":
			return N(fmt.Sprintf("%v", atoi(S(args[0]))-atoi(S(args[1]))))
		case "*":
			return N(fmt.Sprintf("%v", atoi(S(args[0]))*atoi(S(args[1]))))
		case "/":
			return N(fmt.Sprintf("%v", atoi(S(args[0]))/atoi(S(args[1]))))
		case "gt":
			if atoi(S(args[0])) > atoi(S(args[1])) {
				return N("1")
			} else {
				return N("0")
			}
		case "lt":
			if atoi(S(args[0])) < atoi(S(args[1])) {
				return N("1")
			} else {
				return N("0")
			}
		case "+.":
			return N(fmt.Sprintf("%v", atof(S(args[0]))+atof(S(args[1]))))
		case "-.":
			return N(fmt.Sprintf("%v", atof(S(args[0]))-atof(S(args[1]))))
		case "*.":
			return N(fmt.Sprintf("%v", atof(S(args[0]))*atof(S(args[1]))))
		case "/.":
			return N(fmt.Sprintf("%v", atof(S(args[0]))/atof(S(args[1]))))
		case "gt.":
			if atof(S(args[0])) > atof(S(args[1])) {
				return N("1")
			} else {
				return N("0")
			}
		case "lt.":
			if atof(S(args[0])) < atof(S(args[1])) {
				return N("1")
			} else {
				return N("0")
			}
		case "dump":
			//fmt.Println(N(fmt.Sprintf("%+v", args)))
			return N(fmt.Sprintf("%v", TreeToTcl(args)))

		case "eq":
			if S(args[0]) == S(args[1]) {
				return N("1")
			} else {
				return N("0")
			}

		case "puts":
			for i, v := range args {
				if i != 0 {
					fmt.Print(" ")
				}
				if v.List != nil {
					fmt.Printf("%v", ListToStr(v.List))
				} else {
					fmt.Print(S(v))
				}
			}
			fmt.Println()
		case "loadfile":
			b, _ := ioutil.ReadFile(S(args[0]))
			return N(string(b))
		case "set":
			if len(args) == 2 {
				globals[S(args[0])] = S(args[1])
				os.Setenv(S(args[0]), S(args[1])) //FIXME add "use environment" toggle
			} else {
				//return N(globals[S(args[0])])
				return N(os.Getenv(S(args[0])))
			}
		case "run":
			stringCommand, err := ListToStrings(command[1:])
			if err != nil {
				return N(err.Error())
			} else {
				var res string
				var err error

				err = runWithGuardian(stringCommand)

				if err == nil {
					if res == "" {
						return N("")
					} else {
						return N(fmt.Sprintf("%v", res))
					}
				} else {
					return N(err.Error())
				}
			}

		case "proc":
			/*
						proc procedureName {arguments} {
				   body
				}
			*/
			//log.Println("procedure definition", args)
			if len(args) != 3 {
				a := TreeToTcl(args)
				msg := fmt.Sprintf("Error %v,%v: proc requires 3 arguments: proc name {arguments} {body}\n[%v %v]\n", command[0].Line, command[0].Column, f, a)

				log.Panicf(msg)
			}
			functions[S(args[0])] = function{
				Name: S(args[0]),
				Args: args[1].List,
				Body: args[2].List,
			}
		case "exit":
			if len(args) == 0 {
				os.Exit(0)
			} else {
				os.Exit(atoi(S(args[0])))
			}
		case "cons":
			//log.Printf("Cons %+v\n", args)
			thing := args[0]
			list := args[1].List
			list = append([]autoparser.Node{thing}, list...)
			out := autoparser.Node{List: list, Line: command[0].Line, Column: command[0].Column, ChrPos: command[0].ChrPos}
			//log.Printf("New consed node: %+v\n", out)
			return out
		case "empty?":
			if args[0].List == nil || len(args[0].List) == 0 {
				return N("1")
			} else {
				return N("0")
			}
		case "length":
			return autoparser.Node{Str: fmt.Sprintf("%v", len(args[0].List))}
		case "lindex":
			return args[0].List[atoi(S(args[1]))]
		case "lset":
			array:= args[0]
			pos := atoi(S(args[1]))
			data := args[2]
			array.List[pos] = data
			return array
		case "lrange":
			var start int
			if S(args[1]) == "start" {
				start = 0
			} else {
				start = atoi(S(args[1]))
			}
			var end int
			if S(args[2]) == "end" {
				end = len(args[0].List)
			} else {
				end = atoi(S(args[2]))
			}

			return autoparser.Node{List: args[0].List[start:end]}
		case "split":
			text := S(args[0])
			delim := S(args[1])
			bits := strings.Split(text, delim)
			var list []autoparser.Node
			for _, v := range bits {
				list = append(list, N(v))
			}
			return autoparser.Node{List: list}
		case "join":
			list, _ := ListToStrings(args[0].List)
			delim := S(args[1])
			return N(strings.Join(list, delim))
		case "chr":
			return N(string(atoi(S(args[0]))))
		case "if":
			if len(args) == 3 && S(args[2]) != "else" {
				panic("If missing else")
			}
			if atoi(S(args[0])) != 0 {
				ret := blockReduce(args[1].List, parent, level)
				drintln("Returning from if true branch:", TreeToTcl([]autoparser.Node{ret}))
				return ret
			} else if len(args) == 4 {
				ret := blockReduce(args[3].List, parent, level)
				drintln("Returning from if false branch:", TreeToTcl([]autoparser.Node{ret}))
				return ret
			} else {
				log.Printf("No else for if at %v:%v\n", command[0].Line, command[0].Column)
				return void(command[0])
			}

		case "saveInterpreter":
			if len(args) < 1 {
				xshErr("saveInterpreter: no filename specified")
				return N("No filename given")
			}
			*parent = void(command[0])
			rest := TreeToTcl(wholeTree)
			funcs := FunctionsToTcl(functions)
			code := funcs + "\n\n" + rest
			fmt.Printf("Function defs: %v\n\nRemaining code: %v\n", funcs, rest)

			ioutil.WriteFile(S(args[0]), []byte(code), 0644)

		case "return":
			return args[0]
		case "id":
			return args[0]
		case "and":
			if atoi(S(args[0])) != 0 {
				if atoi(S(args[1])) != 0 {
					return N("1")
				}
			}
			return N("0")
		default:
			//It is an external call, prepare the shell command then run it
			//fixme warn user on verbose?
			//fmt.Printf("Unknown command: '%s', attempting shell\n", f)
			if command[0].Note == "\"" {
				return command[0]
			}
			stringCommand, err := ListToStrings(command)
			if err != nil {
				log.Printf("Error %v,%v: converting command to string: %v\n", command[0].Line, command[0].Column, err)
				return void(command[0])
			} else {
				var res string
				var err error
				if level == 1 {
					drintln("Running", stringCommand, "interactively")
					err = runWithGuardian(stringCommand)
				} else {
					drintln("Running", stringCommand, "to capture output")
					res, err = goof.QC(stringCommand)
				}
				if err == nil {
					if res == "" {
						return N("")
					} else {
						return N(fmt.Sprintf("%v", res))
					}
				} else {
					return N(err.Error())
				}
			}
		}
	}
	return void(command[0])
}
func xshErr(msg string) {
	if usePterm {
		header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgRed))
		pterm.DefaultCenter.Println(header.Sprint(msg))
	}

}
func blockReduce(t []autoparser.Node, parent *autoparser.Node, toplevel int) autoparser.Node {

	drintf("BlockReduce: starting %+v\n", TreeToTcl(t))
	//log.Printf("BlockReduce: starting %+v\n", t)
	if len(t) == 0 {
		return void(*parent)
	}
	var out autoparser.Node
	if t[0].Note == "\n" && t[0].Raw == "\n" {
		//It is a multi line lambda, eval as statements, return the last

		for i, v := range t {
			out = treeReduce(v.List, parent, toplevel)
			t[i] = out
		}
	} else {
		//It is a single line lambda, eval as expression
		out = treeReduce(t, parent, toplevel)
	}

	drintf("Returning from BlockReduce: %v\n", TreeToTcl([]autoparser.Node{out}))
	return out
}
func treeReduce(t []autoparser.Node, parent *autoparser.Node, toplevel int) autoparser.Node {
	drintf("Reducing: %+v\n", TreeToTcl(t))

	if toplevel == 1 {
		xshErr(TreeToTcl(t))
	}
	out := []autoparser.Node{}
	for i, v := range t {
		if trace {
			log.Printf("%v,%v: %v\n", v.Line, v.Column, TreeToTcl(t))
		}

		switch {
		case v.Note == "#":
		case v.Raw == "#":
		case v.List != nil:
			if v.Note == "[" || v.Note == "\n" || v.Note == ";" {
				//log.Println("Command:", TreeToTcl(v.List))
				atom := treeReduce(v.List, &t[i], toplevel-1)
				out = append(out, atom)
				t[i] = atom
			} else {
				drintln("treeReduce: found list ", TreeToTcl(v.List))
				out = append(out, v)
				t[i] = v
			}
		default:
			atom := autoparser.Node{ChrPos: -1}
			if strings.HasPrefix(S(v), "$") {
				drintf("Found variable: %+v\n", S(v))
				vname := S(v)[1:]
				drintf("Fetching %v from Globals: %+v\n", vname, globals)
				if vname == "" {
					fmt.Println("$ must preceed a variable name")
					os.Exit(1)
				} else {
					if _, ok := globals[vname]; ok {
						atom = N(globals[vname])
					} else {
						if val := os.Getenv(vname); val != "" {
							atom = N(val)
						} else {
							fmt.Printf("Variable '%v' not found\n", vname)
						}
					}
				}

			} else {
				atom = v
			}
			out = append(out, atom)
			t[i] = atom
		}
	}

	//Run command
	if len(out) > 0 {
		if trace {
			log.Printf("%v,%v: %v\n", out[0].Line, out[0].Column, TreeToTcl(out))
		}
	}
	ret := eval(out, parent, toplevel)
	drintf("Returning from treeReduce: %v\n", TreeToTcl([]autoparser.Node{ret}))
	return ret
}

func TreeToJson(t []autoparser.Node) string {
	out := ""
	for _, v := range t {
		switch {
		case v.Note == "VOID":
		case v.List != nil:
			out = out + "[" + TreeToJson(v.List) + "]"
		case v.Raw != "":
			out = out + "\"" + v.Raw + "\"" + " " //FIXME escape string properly for JSON

		default:
			out = out + "\"\\\"" + v.Str + "\\\"\"" + " " //FIXME escape string properly for JSON

		}

	}
	return out
}

func TreeToTcl(t []autoparser.Node) string {
	out := ""
	for _, v := range t {
		switch {
		case v.Note == "VOID":
		case v.List != nil:
			out = out + "[" + TreeToTcl(v.List) + "]"
		case v.Raw != "":
			out = out + v.Raw + " " //FIXME escape string properly to include in JSON

		default:
			out = out + "\"" + v.Str + "\"" + " " //FIXME escape string properly for JSON
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

//List all executable files in PATH
func listPathExecutables() func(string) []string {
	return func(line string) []string {
		names := make([]string, 0)
		paths := strings.Split(os.Getenv("PATH"), ":")
		for _, p := range paths {
			files, _ := ioutil.ReadDir(p)
			for _, f := range files {
				if f.Mode().Perm()&0111 != 0 {
					names = append(names, f.Name())
				}
			}
		}
		return names
	}
}

func listBuiltins() func(string) []string {
	return func(line string) []string {
		return []string{"puts", "+", "loadfile", "set", "run"}
	}
}
func tbprint(x, y int, fg, bg termbox.Attribute, msg string) {
	for _, c := range msg {
		termbox.SetCell(x, y, c, fg, bg)
		x += runewidth.RuneWidth(c)
	}
}
func shell() {

	var completer = readline.NewPrefixCompleter(
		readline.PcItem("cd", readline.PcItemDynamic(listFiles("./"))),
		readline.PcItemDynamic(listPathExecutables(),
			readline.PcItemDynamic(listFiles("./")),
		),
		readline.PcItemDynamic(listBuiltins(),
			readline.PcItemDynamic(listFiles("./")),
		),
	)

	l, err := readline.NewEx(&readline.Config{
		Prompt:       "\033[31m»\033[0m ",
		HistoryFile:  "/tmp/readline.tmp",
		AutoComplete: completer,
		//InterruptPrompt: "^C",
		EOFPrompt: "exit",
	})
	if err != nil {
		panic(err)
	}
	defer l.Close()

	if usePterm {
		// Print a large text with differently colored letters.
		pterm.DefaultBigText.WithLetters(
			pterm.NewLettersFromStringWithStyle("X", pterm.NewStyle(pterm.FgCyan)),
			pterm.NewLettersFromStringWithStyle("Shell", pterm.NewStyle(pterm.FgLightMagenta))).
			Render()
	}

	for {
		line, err := l.Readline()
		if err == readline.ErrInterrupt {
			fmt.Println("Canceled.  Ctrl-D to exit.")
			continue
			/*			if len(line) == 0 {
							break
						} else {
							continue
						}
			*/
		} else if err == io.EOF {
			break
		}

		line = strings.TrimSpace(line)
		fmt.Printf("Result: %+v\n", TreeToTcl([]autoparser.Node{Eval(line, "shell")}))
	}

	/*
		for {
			rl := readline.NewInstance()

			for {
				line, err := rl.Readline()

				if err != nil {
					fmt.Println("Error:", err)
					return
				}

				fmt.Printf("You just typed: %s\n", line)
			}
		}
	*/
}
