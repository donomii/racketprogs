package xsh

import (
	"fmt"

	"io/ioutil"

	"os"
	"runtime"
	"strings"

	"github.com/nsf/termbox-go"
	"github.com/pterm/pterm"

	"github.com/mattn/go-runewidth"

	//"github.com/lmorg/readline"

	_ "embed"

	"github.com/donomii/goof"

	autoparser "../autoparser"
)

//go:embed stdlib.xsh
var Stdlib_str string

type Function struct {
	Name       string
	Parameters []autoparser.Node
	Body       []autoparser.Node
}

var UsePterm = true
var WantDebug bool = false
var WantTrace bool = false
var WantInform bool = false
var WantHelp bool = true
var WantWarn bool = true
var WantErrors bool = true

var WantEvents bool = true
var Events = [][]string{}

type State struct {
	Functions     map[string]Function
	Globals       map[string]string
	Tree          []autoparser.Node
	ExtraBuiltins func(s State, command []autoparser.Node, parent *autoparser.Node, level int) (autoparser.Node, bool)
	TypeSigs      map[string][]string
	UserData      interface{}
}

func New() State {
	s := State{map[string]Function{}, map[string]string{}, nil, nil, map[string][]string{}, nil}
	addBuiltinTypes(s)
	return s
}

func ShellEval(s State, code, fname string) autoparser.Node {
	XshTrace("Evalling: %v\n", code)
	tree := autoparser.ParseXSH(code, fname)
	drintf("Tree: %v\n", tree)
	s.Tree = tree
	res := treeReduce(s, tree, nil, 1, tree)
	drintf("Res: %+v\n", res)
	return res
}

func Eval(s State, code, fname string) autoparser.Node {
	XshTrace("Evalling: %v\n", code)
	tree := autoparser.ParseXSH(code, fname)
	drintf("Tree: %v\n", tree)
	s.Tree = tree
	res := treeReduce(s, tree, nil, -1, tree)
	drintf("Res: %+v\n", res)
	return res
}

func Parse(code, fname string) []autoparser.Node {
	return autoparser.ParseXSH(code, fname)
}
func Run(s State, tree []autoparser.Node) autoparser.Node {
	s.Tree = tree
	res := treeReduce(s, tree, nil, 2, tree)
	return res
}
func LoadEval(s State, fname string) autoparser.Node {
	return Eval(s, autoparser.LoadFile(fname), fname)
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
				XshErr("%v,%v,%v: Cannot shadow args in lambda: %+v, %+v\n", v.File, v.Line, v.Column, v, p)
				os.Exit(1)
			}
		}
	}
	return nil
}

func ReplaceArg(args, params, t []autoparser.Node) []autoparser.Node {
	if len(args) != len(params) {
		XshErr("Internal error.  Invalid number of arguments in function call: %v, %v\n", args, params)
		panic(fmt.Sprintf("ReplaceArg: Args and params must be the same length: %+v, %+v\n", args, params))
		//os.Exit(1)
	}
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
					//drintf("Comparing function arg: %+v with node %+v\n", args[parami].Raw, v.Raw)
					//We found a variable to replace
					if param.Raw == v.Raw {
						drintf("Replacing param %+v with %+v\n", param, args[parami])
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
	drintf("Replacing function params %+v with %+v\n", TreeToXsh(params), TreeToXsh(args))
	//log.Printf("Replacing function params %+v with %+v\n", TreeToTcl(params), TreeToTcl(args))

	t = ReplaceArg(args, params, t)

	return t
}

func FunctionsToTcl(functions map[string]Function) string {
	out := ""
	for _, v := range functions {
		out += fmt.Sprintf("proc %s {%v} {\n", v.Name, TreeToXsh(v.Parameters))
		out += TreeToXsh(v.Body)
		out += "}\n"
	}
	return out
}

func searchPath(execName string) string {
	drintf("Searching path for '%v'\n", execName)
	if execName == "" {
		return ""
	}
	if execName[0] == '/' {
		return execName
	}
	pathStr := os.Getenv("PATH")
	paths := strings.Split(pathStr, ":")
	if runtime.GOOS == "windows" {
		paths = strings.Split(pathStr, ";")
	}
	for _, extension := range []string{"", ".exe", ".bat", ".cmd"} {
		for _, path := range paths {
			fullPath := path + "/" + execName + extension
			if _, err := os.Stat(fullPath); err == nil {

				//XshInform("Found %s\n", fullPath)
				return fullPath
			}
		}
	}
	return ""
}

func FindGuardian() string {
	bindir := goof.ExecutablePath()
	var guardianPath string = "Guardian not found"
	if runtime.GOOS == "windows" {
		guardianPath = bindir + "/xshguardian.exe"
	} else {
		guardianPath = bindir + "/xshguardian"
	}

	//XshInform("Found guardian at %s\n", guardianPath)
	return guardianPath
}

func clampString(s string, max int) string {
	if len(s) > max {
		if max > 3 {
			return s[:max-3] + "..."
		} else {
			return s[:max]
		}
	}
	return s
}
func runWithGuardian(cmd []string) error {
	guardianPath := FindGuardian()
	drintf("Launching guardian for %+v from %v\n", cmd, guardianPath)
	binfile := cmd[0]
	fullPath := searchPath(binfile)
	if fullPath == "" {
		XshWarn("Could not find %s in PATH\n", binfile)
		if runtime.GOOS == "windows" && (goof.Exists(binfile) || goof.Exists(binfile+".exe") || goof.Exists(binfile+".bat")) {
			XshHelpful("Your file is in the current directory, but not in PATH.  Xsh does not automatically run programs in the current directory.  To do so, add '.' to PATH with 'set PATH [join [list $PATH \".\"] \";\"]'.\n")
		}
		return fmt.Errorf("Could not find application %v in search path: %v\nTo see full path: puts $PATH\n", binfile, clampString(os.Getenv("PATH"), 100))
	}

	cmd[0] = fullPath
	cmd = append([]string{guardianPath, "interactive"}, cmd...)
	XshInform("Running %+v interactively with guardian %v\n", cmd[1:], guardianPath)
	return goof.QCI(cmd)
}

func runWithGuardianCapture(cmd []string) (string, error) {
	guardianPath := FindGuardian()
	drintf("Launching guardian for capturing %+v from %v\n", cmd, guardianPath)
	binfile := cmd[0]
	fullPath := searchPath(binfile)
	if fullPath == "" && !goof.Exists(binfile) {
		XshWarn("Could not find %s in PATH\n", binfile)
		if runtime.GOOS == "windows" && (goof.Exists(binfile) || goof.Exists(binfile+".exe") || goof.Exists(binfile+".bat")) {
			XshHelpful("Your file is in the current directory, but not in PATH.  Xsh does not automatically run programs in the current directory.  To do so, add '.' to PATH with 'set PATH [join [list $PATH \".\"] \";\"]'.\n")
		}
		return "", fmt.Errorf("Could not find application %v in search path: %v\nTo see full path: puts $PATH\n", binfile, clampString(os.Getenv("PATH"), 100))
	}

	cmd[0] = fullPath
	cmd = append([]string{guardianPath, "noninteractive"}, cmd...)
	XshTrace("Command: %+v\n", cmd)
	XshInform("Running %+v for capture with guardian %v\n", cmd, guardianPath)
	return goof.QC(cmd)
}
func Void(command autoparser.Node) autoparser.Node {
	drintf("Creating void at %+v\n", command.Line)
	if command.ChrPos < 1 {
		XshWarn("Warning: Create void with no line number.  This is probably an error.  Code: %+v\n", command)
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
	if isLambda(e) {
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

func isLambda(e autoparser.Node) bool {
	command := e.List
	if len(command) > 0 && isList(command[0]) {
		theLambdaFunction := command[0]
		if theLambdaFunction.Note == "|" {

			return true
		}
	}
	return false
}

func eval(s State, command []autoparser.Node, parent *autoparser.Node, level int) autoparser.Node {
	if len(command) == 0 {
		return Void(autoparser.Node{File: "eval", Line: 1, Column: 0, ChrPos: 1, Note: "empty eval"})
	}
	drintf("Evaluating: %v\n", TreeToXsh(command))
	//If list, assume it is a lambda function and evaluate it
	if isList(command[0]) {
		theLambdaFunction := command[0]
		args := command[1:]

		bod := CopyTree(theLambdaFunction.List[1:])
		params := theLambdaFunction.List[0].List
		if theLambdaFunction.List[0].Note == "|" {

			if len(params) != len(args) {
				XshErr("Error %v,%v,%v: Mismatched function args in ->|%v|<-  expected %v, given %v\n[%v %v]\n", command[0].File, command[0].Line, command[0].Column, TreeToXsh(command), TreeToXsh(params), TreeToXsh(args), S(theLambdaFunction), TreeToXsh(args))
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
		//if typeOf(v) != "void" {  //FIXME causes map etc. to fail.  Filtering out void alters the number of args to some calls.  Need to improve type system so void can't be returned in those situations.
		args = append(args, v)
		//}
	}

	//Do we have a type for this function?
	ftype, ok := s.TypeSigs[f]
	if ok {
		lastArgType := ftype[len(ftype)-1]
		fixedArgs := []string{}
		if len(ftype)-2 > 0 {
			fixedArgs = ftype[1 : len(ftype)-2]
		}
		if len(ftype) != len(args)+1 {
			if lastArgType != "..." {
				XshErr(`Error %v,%v,%v: Mismatched function args to %v

Expected:
	%v %v (%v args)

Given:
	%v %v (%v args)
	`, command[0].File, command[0].Line, command[0].Column, f, f, strings.Join(ftype[1:], " "), len(ftype)-1, f, TreeToXsh(args), len(args))

				os.Exit(1)
			}
		}
		//Different checks for variadic functions
		//FIXME refactor duplicate code
		if lastArgType == "..." {
			varArgsType := ftype[len(ftype)-2]
			varArgs := []autoparser.Node{}
			if len(ftype)-2 < len(args) {
				varArgs = args[len(ftype)-2:]
			}
			//First, check that the specified types match
			//This is the fixed args array
			for i, v := range fixedArgs {
				drintf("Checking type %v against arg %v\n", v, typeOf(args[i]))
				if typeOf(args[i]) != v && v != "any" {
					XshWarn("Type error at file %v line %v (command %v).  At argument %v, expected %v, got %v\n", command[0].File, command[0].Line, TreeToXsh(command), i+1, v, typeOf(args[i]))
				}
			}
			//Now check that the remaining args are of the varargs type
			drintf("Checking remaining args %v against varargs type %v\n", TreeToXsh(varArgs), varArgsType)
			for i, v := range varArgs {
				drintf("Checking type %v against arg %v\n", typeOf(v), varArgsType)
				if typeOf(v) != varArgsType && varArgsType != "any" {
					XshWarn("Type error at file %v line %v (command %v).  At argument %v, expected %v (in ...), got %v\n", command[0].File, command[0].Line, TreeToXsh(command), i+len(ftype)-1, varArgsType, typeOf(v))
				}
			}
		} else {
			//There are no varags, simply check that the types match, and there are the correct number of args
			for i, v := range ftype[1:] {
				if typeOf(args[i]) != v && v != "any" {
					XshWarn("Type error at file %v line %v (command %v).  At argument %v, expected %v, got %v\n", command[0].File, command[0].Line, TreeToXsh(command), i+1, v, typeOf(args[i]))
				}
			}
		}

	}
	fu, ok := s.Functions[f]
	if ok {
		//It's a user-defined function
		bod := CopyTree(fu.Body)
		fparams := fu.Parameters
		nbod := ReplaceArgs(args, fparams, bod)
		drintf("Calling function %+v\n", TreeToXsh(nbod))
		return blockReduce(s, nbod, parent, 0)
	} else {
		//It is a builtin function or an external call
		if f == "" {
			//We shouldn't get an empty string here, but if we do, we ignore it and keep going
			return Void(command[0])
		}

		//This is for the embedded xsh, it allows the embeddor to add their own functions,
		//most usually extra data sources and/or IO
		if s.ExtraBuiltins != nil {
			ret, handled := s.ExtraBuiltins(s, command, parent, level)
			if handled {
				return ret
			} else {
				drintf("No extra builtin for %v\n", command[0])
			}
		}
		drintf("No extra builtins while evaluating %v\n", command[0])
		return builtin(s, command, parent, f, args, level)

	}
	//Maybe we should return a warning here?  Or even exit?  Need a strict mode.

}
func blockReduce(s State, t []autoparser.Node, parent *autoparser.Node, toplevel int) autoparser.Node {

	drintf("BlockReduce: starting %+v\n", TreeToXsh(t))
	//log.Printf("BlockReduce: starting %+v\n", t)
	if len(t) == 0 {
		return Void(*parent)
	}

	//The scopebarrier prevents variable substitution happening to a code branch that has been copied in
	//from another function or scope.
	if (parent != nil) && parent.ScopeBarrier {
		return *parent
	}

	var out autoparser.Node
	if t[0].Note == "\n" && t[0].Raw == "\n" {
		//It is a multi line lambda, eval as statements, return the last

		for i, v := range t {
			out = treeReduce(s, v.List, parent, toplevel, v.List)
			t[i] = out
		}
	} else {
		//It is a single line lambda, eval it as an expression
		out = treeReduce(s, t, parent, toplevel, t)
	}

	drintf("Returning from BlockReduce: %v\n", TreeToXsh([]autoparser.Node{out}))
	return out
}

//Build a node location string from file, line, and column
func Loc(n autoparser.Node) string {
	return fmt.Sprintf("%v:%v:%v", n.File, n.Line, n.Column)
}

//Recurse through program tree, printing each node
func PrintTree(t []autoparser.Node, subTree autoparser.Node) {
	highlight := pterm.NewStyle(pterm.FgRed, pterm.Bold)
	//function := pterm.NewStyle(pterm.FgMagenta, pterm.Bold)

	/*if Loc(t[0]) == Loc(subTree) {
		highlight.Print("(")
		function.Printf("%v", S(t[0]))
	} else {
		fmt.Printf("(%v", S(t[0]))
	}*/

	for i, v := range t {

		if i != 0 {

			fmt.Print(" ")
		}

		switch {
		case v.Note == "VOID":
		case v.List != nil:
			switch v.Note {
			case "{":
				if Loc(v) == Loc(subTree) {
					highlight.Print("{")
					PrintTree(v.List, subTree)
					highlight.Print("}")
				} else {
					fmt.Print("{")
					PrintTree(v.List, subTree)
					fmt.Print("}")
				}
			case "|":
				PrintTree(v.List, subTree)
				fmt.Print("|")
			default:
				if Loc(v) == Loc(subTree) {
					highlight.Print("(")
					PrintTree(v.List, subTree)
					highlight.Print(")")
				} else {
					fmt.Print("(")
					PrintTree(v.List, subTree)
					fmt.Print(")")
				}

			}
		case v.Raw != "":
			if Loc(v) == Loc(subTree) {
				highlight.Print(v.Raw) //FIXME escape string properly to include in JSON
			} else {
				fmt.Print(v.Raw)
			}
		default:
			if Loc(v) == Loc(subTree) {
				highlight.Print("\"" + v.Str + "\"") //FIXME escape string properly for JSON
			} else {
				fmt.Print("\"" + v.Str + "\"")
			}
		}
	}
	/*
		if Loc(t[0]) == Loc(subTree) {
			highlight.Print(")")
		} else {
			fmt.Print(")")
		}*/
}

func treeReduce(s State, t []autoparser.Node, parent *autoparser.Node, toplevel int, orig []autoparser.Node) autoparser.Node {
	drintf("Reducing: %+v\n", TreeToXsh(t))

	if (parent != nil) && parent.ScopeBarrier {
		return *parent
	}
	/*  FIXME need some way to display each line as we run it, but this is not it
	if toplevel == 1 {
		XshInform(TreeToXsh(t))
	}
	*/
	out := []autoparser.Node{}
	for i, v := range t {
		if WantTrace && v.File != "" { //FIXME this is just masking a problem
			fmt.Printf("In:%v: ", Loc(v))
			PrintTree(orig, v)
			fmt.Print("\n")
		}

		switch {
		case v.Note == "#":
		case v.Raw == "#":
		case v.List != nil:
			if v.Note == "[" || v.Note == "\n" || v.Note == ";" {
				//log.Println("Command:", TreeToTcl(v.List))
				atom := treeReduce(s, v.List, &t[i], toplevel-1, orig)
				out = append(out, atom)
				t[i] = atom
			} else {
				drintln("treeReduce: found list ", TreeToXsh(v.List))
				out = append(out, v)
				t[i] = v
			}
		default:
			atom := autoparser.Node{ChrPos: -1}
			if strings.HasPrefix(S(v), "$") {
				//Environment variable
				drintf("Environment variable lookup: %+v\n", S(v))
				vname := S(v)[1:]
				drintf("Fetching %v from Globals: %+v\n", vname, s.Globals)
				if vname == "" {
					XshErr("$ found without variable name.  $ defines a variable, and cannot be used on its own.")
					os.Exit(1)
				} else {
					//FIXME: globals should go away?
					if _, ok := s.Globals[vname]; ok {
						atom = N(s.Globals[vname])
						//FIXME
						atom.File = v.File
						atom.Line = v.Line
						atom.Column = v.Column
						atom.ChrPos = v.ChrPos
					} else {
						//Load value from environment
						if val := os.Getenv(vname); val != "" {
							atom = N(val)
							atom.File = v.File
							atom.Line = v.Line
							atom.Column = v.Column
							atom.ChrPos = v.ChrPos
						} else {
							XshErr("Global variable $%v not found.  You must define a variable before you use it.", vname)
							os.Exit(1)
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
			fmt.Printf("Out:%v: ", Loc(out[0]))
			PrintTree(orig, out[0])
			fmt.Print("\n")
		}
	}
	ret := eval(s, out, parent, toplevel)
	drintf("Returning from treeReduce: %v\n", TreeToXsh([]autoparser.Node{ret}))
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

func TreeToXsh(t []autoparser.Node) string {
	out := ""
	for i, v := range t {
		switch {
		case v.Note == "VOID":
		case v.List != nil:
			if i != 0 {
				out = out + " "
			}
			switch v.Note {
			case "{":
				out = out + "{" + TreeToXsh(v.List) + "}"
			case "|":
				out = out + TreeToXsh(v.List) + "|"
			default:
				out = out + "[" + TreeToXsh(v.List) + "]"
			}
		case v.Raw != "":
			if i != 0 {
				out = out + " "
			}
			out = out + v.Raw //FIXME escape string properly to include in JSON

		default:
			if i != 0 {
				out = out + " "
			}
			out = out + "\"" + v.Str + "\"" //FIXME escape string properly for JSON
		}
	}
	return out
}

// Function constructor - constructs new function for listing given directory
func ListFiles(path string) func(string) []string {
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
func ListPathExecutables() func(string) []string {
	return func(line string) []string {
		names := make([]string, 0)
		paths := strings.Split(os.Getenv("PATH"), ":")
		if runtime.GOOS == "windows" {
			paths = strings.Split(os.Getenv("PATH"), ";")
		}
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

func ListBuiltins() func(string) []string {
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

func TreeMap(f func(autoparser.Node) autoparser.Node, t []autoparser.Node) []autoparser.Node {

	out := []autoparser.Node{}
	for _, v := range t {
		if v.List != nil {
			out = append(out, autoparser.Node{v.Raw, v.Str, TreeMap(f, v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier})
		} else {
			new := f(v)
			if isList(new) {
				out = append(out, new.List...)
			} else {
				out = append(out, new)
			}
		}
	}
	return out
}