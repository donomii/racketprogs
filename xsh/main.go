package xsh

import (
	"errors"
	"fmt"

	"io/ioutil"

	"github.com/nsf/termbox-go"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/mattn/go-runewidth"

	"github.com/pterm/pterm"
	//"github.com/lmorg/readline"

	_ "embed"
	"github.com/donomii/goof"

	autoparser "../autoparser"
)

var guardianPath string

//go:embed stdlib.xsh
var Stdlib_str string

type Function struct {
	Name       string
	Parameters []autoparser.Node
	Body       []autoparser.Node
}

var usePterm = true
var WantDebug bool
var WantShell bool
var WantTrace bool

type State struct {
	Functions     map[string]Function
	Globals       map[string]string
	Tree          []autoparser.Node
	ExtraBuiltins func(s State, command []autoparser.Node, parent *autoparser.Node, level int) (autoparser.Node, bool)
	TypeSigs      map[string][]string
	UserData      interface{}
}

func drintf(formatStr string, args ...interface{}) {
	if WantDebug {
		log.Printf(formatStr, args...)
	}
}

func drintln(args ...interface{}) {
	if WantDebug {
		log.Println(args...)
	}
}

func New() State {
	s := State{map[string]Function{}, map[string]string{}, nil, nil, map[string][]string{}, nil}
	s.TypeSigs["map"] = []string{"list", "lambda", "list"}
	s.TypeSigs["cd"] = []string{"void", "string"}
	s.TypeSigs["\n"] = []string{"void"}
	s.TypeSigs["+"] = []string{"string", "string", "string"}
	s.TypeSigs["-"] = s.TypeSigs["+"]
	s.TypeSigs["*"] = s.TypeSigs["+"]
	s.TypeSigs["/"] = s.TypeSigs["+"]
	s.TypeSigs["gt"] = s.TypeSigs["+"]
	s.TypeSigs["lt"] = s.TypeSigs["+"]
	s.TypeSigs["+."] = s.TypeSigs["+"]
	s.TypeSigs["-."] = s.TypeSigs["+"]
	s.TypeSigs["."] = s.TypeSigs["+"]
	s.TypeSigs["/."] = s.TypeSigs["+"]
	s.TypeSigs["gt."] = s.TypeSigs["+"]
	s.TypeSigs["lt"] = s.TypeSigs["+"]
	s.TypeSigs["eq"] = s.TypeSigs["+"]
	s.TypeSigs["loadfile"] = []string{"string", "string"}
	s.TypeSigs["proc"] = []string{"void", "string", "list", "list"}
	s.TypeSigs["exit"] = []string{"string", "void"}
	s.TypeSigs["cons"] = []string{"list", "string", "list"}
	s.TypeSigs["empty?"] = []string{"string", "list"}
	s.TypeSigs["length"] = []string{"string", "list"}
	s.TypeSigs["lindex"] = []string{"any", "list", "string"}
	s.TypeSigs["lset"] = []string{"string", "list", "string", "any"}
	s.TypeSigs["lrange"] = []string{"list", "list", "string", "string"}
	s.TypeSigs["split"] = []string{"list", "string", "string"}
	s.TypeSigs["join"] = []string{"string", "list", "string"}
	s.TypeSigs["chr"] = []string{"string", "string"}
	s.TypeSigs["saveInterpreter"] = []string{"void"}
	s.TypeSigs["return"] = []string{"any", "any"}
	s.TypeSigs["id"] = []string{"any", "any"}
	s.TypeSigs["and"] = []string{"string", "string"}
	s.TypeSigs["or"] = []string{"string", "string"}

	return s
}

func Eval(s State, code, fname string) autoparser.Node {
	//fmt.Printf("Evalling: %v\n", code)
	tree := autoparser.ParseXSH(code, fname)
	//fmt.Printf("Tree: %v\n", tree)
	s.Tree = tree
	res := treeReduce(s, tree, nil, 2)
	//fmt.Printf("Res: %+v\n", res)
	return res
}
func LoadEval(s State, fname string) autoparser.Node {
	return Eval(s, autoparser.LoadFile(fname), fname)
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
			out = append(out, autoparser.Node{v.Raw, v.Str, CopyTree(v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier})
		} else {
			out = append(out, autoparser.Node{v.Raw, v.Str, v.List, v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier})
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
		//The scope barrier exists to prevent variable names being incorrectly replaced in substitued code
		//If there are multiple LET statements, or with some combinations of lambdas and recursion, it is possible
		//that a lambda will be copied into the function tree, and then another variable replace pass runs, incorrectly replacing
		//variables inside the lambda when they are really in a different scope and should not be replaced.
		if v.ScopeBarrier {
			out = append(out, CopyNode(v))
		} else {
			if v.List != nil {
				if v.Note == "|" {
					checkArgs(v.List, params)
				}
				out = append(out, autoparser.Node{v.Raw, v.Str, ReplaceArg(args, params, v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier})
			} else {
				replaced := 0
				for parami, param := range params {

					//drintf("Comparing function arg: %+v with node %+v\n", farg, v)
					//log.Printf("Comparing function arg: %+v with node %+v\n", args[parami].Raw, v.Raw)
					//We found a variable to replace
					if param.Raw == v.Raw {
						//log.Printf("Replacing param %+v with %+v\n", param, args[parami])
						new := CopyNode(args[parami])
						//New node is assumed to be from a different scope, so we need to set the scope barrier
						new.ScopeBarrier = true
						out = append(out, new)
						//log.Printf("Inserting: %v\n", S(args[parami]))
						replaced = 1
					}
				}
				if replaced == 0 {
					out = append(out, CopyNode(v))
				}
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

func FunctionsToTcl(functions map[string]Function) string {
	out := ""
	for _, v := range functions {
		out += fmt.Sprintf("proc %s {%v} {\n", v.Name, TreeToTcl(v.Parameters))
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
	return autoparser.Node{"", "", nil, "VOID", command.Line, command.Column, command.ChrPos, command.File, command.ScopeBarrier}
}
func isList(n autoparser.Node) bool {
	return n.List != nil
}

func CopyNode(n autoparser.Node) autoparser.Node {
	return autoparser.Node{n.Raw, n.Str, n.List, n.Note, n.Line, n.Column, n.ChrPos, n.File, n.ScopeBarrier}
}

func typeOf(e autoparser.Node) string {
	if e.Note == "|" {
		return "lambda"
	}
	if e.List != nil && e.Note == "{" {
		return "list"
	}
	if e.Str != "" {
		return "string"
	}
	if e.Raw != "" {
		return "string"
	}
	return "void"
}

func EmptyList() autoparser.Node {
	return autoparser.Node{Note: "{", List: []autoparser.Node{}}
}
func eval(s State, command []autoparser.Node, parent *autoparser.Node, level int) autoparser.Node {
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
			return blockReduce(s, nbod, parent, 0)
		} else {
			//Programmer is trying to return a list, it's not a lambda function
			l := EmptyList()
			l.List = command
			return l
		}
	}

	//If it s a string or symbol, look it up in the global
	//functions map and return the result
	f := S(command[0])
	preargs := command[1:]
	args := []autoparser.Node{}
	for _, v := range preargs {
		if typeOf(v) != "void" {
			args = append(args, v)
		}
	}

	//Do we have a type for this?
	ftype, ok := s.TypeSigs[f]
	if ok {
		for i, v := range ftype[1:] {
			if typeOf(args[i]) != v {
				fmt.Printf("Type error at line %v (command %v, %+v).  At argument %v, expected %v, got %v\n", command[0].Line, TreeToTcl(command), command, i, v, typeOf(args[i]))
			}
		}
	}
	fu, ok := s.Functions[f]
	if ok {
		bod := CopyTree(fu.Body)
		fparams := fu.Parameters
		nbod := ReplaceArgs(args, fparams, bod)
		drintf("Calling function %+v\n", TreeToTcl(nbod))
		return blockReduce(s, nbod, parent, 0)
	} else {
		//It is a builtin function or an external call
		if f == "" {
			return void(command[0])
		}
		if s.ExtraBuiltins != nil {
			ret, handled := s.ExtraBuiltins(s, command, parent, level)
			if handled {
				return ret
			}
		}
		switch f {
		case "seq":
			//log.Printf("seq %v\n", TreeToTcl(args))
			return args[len(args)-1]
		case "with":
			letparams := args[0].List
			letargs := args[2].List
			evalledArgs := []autoparser.Node{}
			for _, e := range letargs {
				if e.List == nil {
					evalledArgs = append(evalledArgs, e)
				} else {
					evalledArgs = append(evalledArgs, treeReduce(s, e.List, nil, 0))
				}
			}
			letbod := CopyTree(args[3].List)
			fmt.Printf("Replacing %v with %v\n", TreeToTcl(letparams), TreeToTcl(evalledArgs))
			nbod := ReplaceArgs(evalledArgs, letparams, letbod)
			drintf("Calling function %+v\n", TreeToTcl(nbod))
			return blockReduce(s, nbod, parent, 0)
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
			//FIXME dedupe
		case "put":
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
				s.Globals[S(args[0])] = S(args[1])
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
			if len(args) != 3 {
				a := TreeToTcl(args)
				msg := fmt.Sprintf("Error %v,%v: proc requires 3 arguments: proc name {arguments} {body}\n[%v %v]\n", command[0].Line, command[0].Column, f, a)

				log.Panicf(msg)
			}
			s.Functions[S(args[0])] = Function{
				Name:       S(args[0]),
				Parameters: args[1].List,
				Body:       args[2].List,
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
			out := autoparser.Node{List: list, Line: command[0].Line, Column: command[0].Column, ChrPos: command[0].ChrPos, Note: "{"}
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
			array := args[0]
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

			return autoparser.Node{List: args[0].List[start:end], Note: "{"}
		case "split":
			text := S(args[0])
			delim := S(args[1])
			bits := strings.Split(text, delim)
			var list []autoparser.Node
			for _, v := range bits {
				list = append(list, N(v))
			}
			return autoparser.Node{List: list, Note: "{"}
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
				ret := blockReduce(s, args[1].List, parent, level)
				drintln("Returning from if true branch:", TreeToTcl([]autoparser.Node{ret}))
				return ret
			} else if len(args) == 4 {
				ret := blockReduce(s, args[3].List, parent, level)
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
			rest := TreeToTcl(s.Tree)
			funcs := FunctionsToTcl(s.Functions)
			code := funcs + "\n\n" + rest
			fmt.Printf("Function defs: %v\n\nRemaining code: %v\n", funcs, rest)

			ioutil.WriteFile(S(args[0]), []byte(code), 0644)

		case "return":
			return args[0]
		case "id":
			return args[0]
		case "list":
			return autoparser.Node{List: args, Note: "{"}
		case "and":
			if atoi(S(args[0])) != 0 {
				if atoi(S(args[1])) != 0 {
					return N("1")
				}
			}
			return N("0")
		case "or":
			if atoi(S(args[0])) != 0 {
				return N("1")
			}
			if atoi(S(args[1])) != 0 {
				return N("1")
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
func blockReduce(s State, t []autoparser.Node, parent *autoparser.Node, toplevel int) autoparser.Node {

	drintf("BlockReduce: starting %+v\n", TreeToTcl(t))
	//log.Printf("BlockReduce: starting %+v\n", t)
	if len(t) == 0 {
		return void(*parent)
	}

	if (parent != nil) && parent.ScopeBarrier {
		return *parent
	}

	var out autoparser.Node
	if t[0].Note == "\n" && t[0].Raw == "\n" {
		//It is a multi line lambda, eval as statements, return the last

		for i, v := range t {
			out = treeReduce(s, v.List, parent, toplevel)
			t[i] = out
		}
	} else {
		//It is a single line lambda, eval as expression
		out = treeReduce(s, t, parent, toplevel)
	}

	drintf("Returning from BlockReduce: %v\n", TreeToTcl([]autoparser.Node{out}))
	return out
}
func treeReduce(s State, t []autoparser.Node, parent *autoparser.Node, toplevel int) autoparser.Node {
	drintf("Reducing: %+v\n", TreeToTcl(t))

	if (parent != nil) && parent.ScopeBarrier {
		return *parent
	}

	if toplevel == 1 {
		xshErr(TreeToTcl(t))
	}
	out := []autoparser.Node{}
	for i, v := range t {
		if WantTrace {
			log.Printf("%v,%v: %v\n", v.Line, v.Column, TreeToTcl(t))
		}

		switch {
		case v.Note == "#":
		case v.Raw == "#":
		case v.List != nil:
			if v.Note == "[" || v.Note == "\n" || v.Note == ";" {
				//log.Println("Command:", TreeToTcl(v.List))
				atom := treeReduce(s, v.List, &t[i], toplevel-1)
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
				drintf("Fetching %v from Globals: %+v\n", vname, s.Globals)
				if vname == "" {
					fmt.Println("$ must preceed a variable name")
					os.Exit(1)
				} else {
					if _, ok := s.Globals[vname]; ok {
						atom = N(s.Globals[vname])
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
		if WantTrace {
			log.Printf("%v,%v: %v\n", out[0].Line, out[0].Column, TreeToTcl(out))
		}
	}
	ret := eval(s, out, parent, toplevel)
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
		return []string{"id", "and", "or", "join", "split", "puts", "+", "-", "*", "/", "+.", "-.", "*.", "/.", "loadfile", "set", "run", "seq", "with", "cd"}
	}
}
func tbprint(x, y int, fg, bg termbox.Attribute, msg string) {
	for _, c := range msg {
		termbox.SetCell(x, y, c, fg, bg)
		x += runewidth.RuneWidth(c)
	}
}
