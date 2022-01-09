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

	autoparser "../../../autoparser"
)

var guardianPath string

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
	flag.BoolVar(&wantDebug, "debug", false, "Enable debug output")
	flag.Parse()
	//wantShell=*shellOpt
	var fname string
	if len(flag.Args()) > 0 {
		fname = flag.Arg(0)
	} else {
		wantShell = true
	}

	switch {
	case *resumeFile != "":
		fmt.Println("Resuming from file: ", *resumeFile)
		f := autoparser.LoadFile(*resumeFile)
		tree := autoparser.ParseTcl(f)
		drintf("%+v\n", tree)
		wholeTree = tree
		drintf("treeReduce: %+v\n", treeReduce(tree, nil,0))
		//autoparser.PrintTree(tree, 0, false)
		json := TreeToTcl(tree)

		fmt.Println(json)

	case wantShell:
		shell()
	default:

		f := autoparser.LoadFile(fname)
		tree := autoparser.ParseTcl(f)
		drintf("%+v\n", tree)
		wholeTree = tree
		drintf("treeReduce: %+v\n", treeReduce(tree, nil, 2))
		//autoparser.PrintTree(tree, 0, false)
		json := TreeToTcl(tree)

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

func ListToStr(l []autoparser.Node) string {
	str, _ := ListToString(l)
	out := strings.Join(str, " ")
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
func CopyTree(t []autoparser.Node) []autoparser.Node {
	out := []autoparser.Node{}
	for _, v := range t {
		if v.List != nil {
			out = append(out, autoparser.Node{v.Raw, v.Str, CopyTree(v.List), v.Note})
		} else {
			out = append(out, autoparser.Node{v.Raw, v.Str, v.List, v.Note})
		}
	}
	return out
}

func ReplaceArg(arg, farg autoparser.Node, t []autoparser.Node) []autoparser.Node {
	drintf("Replacing farg %+v with %+v\n", farg, arg)
	out := []autoparser.Node{}
	for _, v := range t {
		if v.List != nil {
			out = append(out, autoparser.Node{v.Raw, v.Str, ReplaceArg(arg, farg, v.List), v.Note})
		} else {
			drintf("Comparing function arg: %+v with node %+v\n", farg, v)
			if farg.Raw == v.Raw {
				out = append(out, arg)
			} else {
				out = append(out, autoparser.Node{v.Raw, v.Str, v.List, v.Note})
			}
		}
	}
	return out
}

func ReplaceArgs(args, fargs, t []autoparser.Node) []autoparser.Node {
	drintf("Replacing function args %+v with %+v\n", fargs, args)
	for i, v := range fargs {
		t = ReplaceArg(args[i], v, t)
	}
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
func void() autoparser.Node {
	return autoparser.Node{Note: "VOID"}
}
func eval(command []autoparser.Node, parent *autoparser.Node, level int) autoparser.Node {
	if len(command) == 0 {
		return autoparser.Node{}
	}
	drintf("Evaluating: %v\n", command)
	f := S(command[0])
	args := command[1:]
	fu, ok := functions[f]
	if ok {
		bod := CopyTree(fu.Body)
		fargs := fu.Args
		nbod := ReplaceArgs(args, fargs, bod)
		drintf("Calling function %+v\n", nbod)
		return treeReduce(nbod, parent,0)
	} else {
		if f == "" {
			return void()
		}
		switch f {
		case "seq":
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
			return autoparser.Node{Note: "VOID"}
		case "+":
			return N(fmt.Sprintf("%v", ato(S(args[0]))+ato(S(args[1]))))
		case "puts":

			for _, v := range args {
				fmt.Print(S(v))
			}
			fmt.Println()
		case "loadfile":
			b, _ := ioutil.ReadFile(S(args[0]))
			return N(string(b))
		case "set":
			if len(args) == 2 {
				globals[S(args[0])] = S(args[1])
			} else {
				return N(globals[S(args[0])])
			}
		case "run":
			stringCommand, err := ListToString(command[1:])
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
			functions[S(args[0])] = function{
				Name: S(args[0]),
				Args: args[1].List,
				Body: args[2].List,
			}
		case "exit":
			if len(args) == 0 {
				os.Exit(0)
			} else {
				os.Exit(ato(S(args[0])))
			}

		case "if":
			if ato(S(args[0])) != 0 {
				return treeReduce(args[1].List, parent, level)
			} else if len(args) == 3 {
				return treeReduce(args[2].List, parent, level)
			} else {
				return void()
			}

		case "saveInterpreter":
			if len(args)<1 {
				xshErr("saveInterpreter: no filename specified")
				return N("No filename given")
			}
			*parent = autoparser.Node{"", "", nil, "VOID"}
			rest := TreeToTcl(wholeTree)
			funcs := FunctionsToTcl(functions)
			code := funcs + "\n\n" + rest
			fmt.Printf("Function defs: %v\n\nRemaining code: %v\n", funcs, rest)

			ioutil.WriteFile(S(args[0]), []byte(code), 0644)
		default:
			//fixme warn user on verbose?
			//fmt.Printf("Unknown command: '%s', attempting shell\n", f)
			if command[0].Note == "\"" {
				return command[0]
			}
			stringCommand, err := ListToString(command)
			if err != nil {
				return autoparser.Node{Note: "VOID"}
			} else {
				var res string
				var err error
				if level ==1 {
					err = runWithGuardian(stringCommand)
				} else {

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
	return autoparser.Node{Note: "VOID"}
}
func xshErr(msg string) {
	if usePterm {
		header := pterm.DefaultHeader.WithBackgroundStyle(pterm.NewStyle(pterm.BgRed))
		pterm.DefaultCenter.Println(header.Sprint(msg))
	}
}
func treeReduce(t []autoparser.Node, parent *autoparser.Node, toplevel int) autoparser.Node {
	drintf("Reducing: %+v\n", t)
	if toplevel == 1{
		xshErr(ListToStr(t))
		}
	out := []autoparser.Node{}
	for i, v := range t {
		switch {
		case v.Note == "#":
		case v.Raw == "#":
		case v.List != nil:
			if v.Note == "[" || v.Note == "\n" || v.Note == ";" {

				
				atom := treeReduce(v.List, &t[i], toplevel-1)
				out = append(out, atom)
				t[i] = atom
			} else {
				out = append(out, v)
				t[i] = v
			}
		default:
			var atom autoparser.Node
			if strings.HasPrefix(S(v), "$") {
				drintf("Found variable: %+v\n", S(v))
				vname := S(v)[1:]
				drintf("Fetching %v from Globals: %+v\n", vname, globals)
				if vname == "" {
					fmt.Println("$ must preceed a variable name")
					
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

	return eval(out, parent, toplevel)
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
			out = out + v.Raw + " " //FIXME escape string properly for JSON

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
		tree := autoparser.ParseTcl(line)
		wholeTree=tree
		fmt.Printf("%+v\n", NodeToString(treeReduce(tree, nil,2)))
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
