package xsh

import (
	"fmt"
	"io/ioutil"
	"os"
	"runtime"
	"strings"

	"github.com/pterm/pterm"

	//"github.com/lmorg/readline"

	_ "embed"

	"github.com/donomii/goof"

	autoparser "../autoparser"
)

//go:embed stdlib.xsh
var Stdlib_str string

type Function struct {
	Name       string
	Parameters autoparser.Node
	Body       autoparser.Node
}

var (
	UsePterm        = true
	WantDebug  bool = false
	WantTrace  bool = false
	WantInform bool = false
	WantHelp   bool = true
	WantWarn   bool = true
	WantErrors bool = true
)

var (
	WantEvents bool = true
	Events          = [][]string{}
)

type State struct {
	Functions     map[string]Function
	Globals       map[string]string
	Tree          autoparser.Node
	ExtraBuiltins func(s State, command []autoparser.Node, parent *autoparser.Node, level int) (autoparser.Node, bool)
	TypeSigs      map[string][]string
	UserData      interface{}
}

func New() State {
	s := State{map[string]Function{}, map[string]string{}, Void(autoparser.Node{}), nil, map[string][]string{}, nil}
	addBuiltinTypes(s)
	return s
}

// Eval, but with options that make sense for interactive sessions.  i.e. run sub programs connected
// to the terminal stdio so that text editors etc can work properly
func ShellEval(s State, code, fname string) autoparser.Node {
	// Trim spaces from both ends of the code
	code = strings.TrimSpace(code)
	if code == "" {
		XshTrace("ShellEval: Empty code\n")
		return Void(autoparser.Node{Line: 1, Column: 0, ChrPos: 1, File: fname})
	}
	XshTrace("Evaluating shell command: %v\n", code)
	tree := autoparser.ParseXSH(code, fname)
	drintf("Tree: %+v\n", tree)
	s.Tree = tree
	res := treeReduce(s, tree.List, &tree, 1, tree)
	drintf("Res: %+v\n", res)
	return res
}

// Eval, in "batch" mode.  STDIN is nil and STDOUT is collected into a string as the return value
func Eval(s State, code, fname string) autoparser.Node {
	// XshTrace("Evalling: %v\n", code)
	tree := autoparser.ParseXSH(code, fname)
	// drintf("Tree: %+v\n", tree)
	// drintf("[Eval] Tree: %+v\n", TreeToXsh(tree))
	// fmt.Println("[Eval] PrintTree")
	// PrintTree(tree, New().Tree)

	s.Tree = tree
	res := treeReduce(s, tree.List, &tree, -1, tree)
	drintf("Res: %+v\n", res)
	return res
}

// Parse some xsh code into a tree
func Parse(code, fname string) autoparser.Node {
	return autoparser.ParseXSH(code, fname)
}

// Run a tree (a program)
func RunTree(s State, tree autoparser.Node) autoparser.Node {
	s.Tree = tree
	res := treeReduce(s, tree.List, &tree, 2, tree)
	return res
}

func LoadEval(s State, fname string) autoparser.Node {
	return Eval(s, autoparser.LoadFile(fname), fname)
}

func CopyTree(t autoparser.Node) autoparser.Node {
	out := []autoparser.Node{}
	for _, v := range t.List {
		if v.List != nil {
			out = append(out, autoparser.Node{v.Raw, v.Str, CopyTree(v).List, v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier})
		} else {
			out = append(out, autoparser.Node{v.Raw, v.Str, v.List, v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier})
		}
	}
	r := autoparser.Node{t.Raw, t.Str, out, t.Note, t.Line, t.Column, t.ChrPos, t.File, t.ScopeBarrier}
	return r
}

// Is this still relevent?
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

// Recurse through the code tree, replacing any function calls with the function bodies, and any variables
// with the values.
func ReplaceArg(args, params []autoparser.Node, t autoparser.Node) autoparser.Node {
	if len(args) != len(params) {
		XshErr("Invalid number of arguments in function call: %v, %v\n", args, params)
		panic(fmt.Sprintf("ReplaceArg: Args and params must be the same length: %+v, %+v\n", args, params))
		// os.Exit(1)
	}
	out := []autoparser.Node{}
	for _, v := range t.List {
		// The scope barrier exists to prevent variable names being incorrectly replaced in substitued code
		// If there are multiple LET statements, or with some combinations of lambdas and recursion, it is possible
		// that a lambda will be copied into the function tree, and then another variable replace pass runs, incorrectly replacing
		// variables inside the lambda when they are really in a different scope and should not be replaced.  (i.e. modifying the wrong lexical scope)
		if v.ScopeBarrier {
			out = append(out, CopyNode(v))
		} else {
			// If this element is a list
			if v.List != nil {
				if v.Note == "|" {
					checkArgs(v.List, params)
				}
				// Recurse into it
				out = append(out, autoparser.Node{v.Raw, v.Str, ReplaceArg(args, params, v).List, v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier})
			} else {
				replaced := 0
				for parami, param := range params {
					// drintf("Comparing function arg: %+v with node %+v\n", farg, v)
					// drintf("Comparing function arg: %+v with node %+v\n", args[parami].Raw, v.Raw)
					// We found a variable to replace
					if param.Raw == v.Raw {
						drintf("Replacing param %+v with %+v\n", param, args[parami])
						new := CopyNode(args[parami])
						// New node is assumed to be from a different scope, so we need to set the scope barrier
						// This will protect the subtree from further replacements
						new.ScopeBarrier = true
						out = append(out, new)
						// log.Printf("Inserting: %v\n", S(args[parami]))
						replaced = 1
					}
				}
				if replaced == 0 {
					out = append(out, CopyNode(v))
				}
			}
		}
	}
	r := autoparser.Node{t.Raw, t.Str, out, t.Note, t.Line, t.Column, t.ChrPos, t.File, t.ScopeBarrier}
	return r
}

// Recurse through the code tree, replacing any function calls with the function bodies, and any variables
// with the values.
func ReplaceArgs(args, params []autoparser.Node, t autoparser.Node) autoparser.Node {
	a, _ := ListToStrings(params)
	b, _ := ListToStrings(args)
	drintf("Replacing function params %+v with %+v\n", a, b)
	// log.Printf("Replacing function params %+v with %+v\n", TreeToTcl(params), TreeToTcl(args))

	t = ReplaceArg(args, params, t)

	return t
}

// Print the global function definitions into a string, to be parsed later
func FunctionsToXsh(functions map[string]Function) string {
	out := ""
	for _, v := range functions {
		out += fmt.Sprintf("proc %s {%v} {\n", v.Name, TreeToXsh(v.Parameters))
		out += TreeToXsh(v.Body)
		out += "}\n"
	}
	return out
}

// Search the current environment PATH for the named program.  Also searches for files ending in .exe, .bat, and .cmd.
// Returns the full path to the program, including filename, or an empty string if the program was not found.
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
				// XshInform("Found %s\n", fullPath)
				return fullPath
			}
		}
	}
	return ""
}

// Searches for the XshGuardian program, which is used to launch other programs
func FindGuardian() string {
	bindir := goof.ExecutablePath()
	var guardianPath string = "Guardian not found"
	if runtime.GOOS == "windows" {
		guardianPath = bindir + "/xshguardian.exe"
	} else {
		guardianPath = bindir + "/xshguardian"
	}

	// XshInform("Found guardian at %s\n", guardianPath)
	return guardianPath
}

// Trim a string to the requested length, with an ellipsis if the string is longer than the requested length
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

// Launch another program using XshGuardian, in interactive mode.
func runWithGuardian(cmd []string) error {
	guardianPath := FindGuardian()
	drintf("Launching guardian for %+v from %v\n", cmd, guardianPath)
	binfile := cmd[0]
	fullPath := searchPath(binfile)
	if fullPath == "" {
		XshErr("Could not find %s in PATH\n", binfile)
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

// Launch another program using XshGuardian, and wait for it to finish.  Returns everything printed to
// STDOUT as a string.
func runWithGuardianCapture(cmd []string) (string, error) {
	guardianPath := FindGuardian()
	drintf("Launching guardian for capturing %+v from %v\n", cmd, guardianPath)
	binfile := cmd[0]
	fullPath := searchPath(binfile)
	if fullPath == "" && !goof.Exists(binfile) {
		XshErr("Could not find %s in PATH\n", binfile)
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

// Create a Void node.  You must provide an existing node to copy the source location from.  The source
// location is used by a lot of debugging and display code, returning 0,0,0 will result in a lot of glitches.
func Void(command autoparser.Node) autoparser.Node {
	drintf("Creating void at %+v\n", command.Line)
	if command.ChrPos == 0 {
		XshWarn("Warning: Create void with invalid position.  This is probably an error.  Code: %+v\n", command)
	}
	return autoparser.Node{"", "", nil, "VOID", command.Line, command.Column, command.ChrPos, command.File, command.ScopeBarrier}
}

// Is the Node a List?
func isList(n autoparser.Node) bool {
	return n.List != nil
}

// Creates a new copy of the node
func CopyNode(n autoparser.Node) autoparser.Node {
	return autoparser.Node{n.Raw, n.Str, n.List, n.Note, n.Line, n.Column, n.ChrPos, n.File, n.ScopeBarrier}
}

// Returns the node type
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

// Create a new empty list.  You must provide a source node with valid location information.
func EmptyList(sourceNode autoparser.Node) autoparser.Node {
	return autoparser.Node{Note: "{", List: []autoparser.Node{}, File: sourceNode.File, Line: sourceNode.Line, Column: sourceNode.Column, ChrPos: sourceNode.ChrPos}
}

// Is the node a lambda?
func isLambda(e autoparser.Node) bool {
	command := e.List
	if len(command) > 0 && isList(command[0]) {
		theLambdaFunction := command[0]
		if theLambdaFunction.Note == "|" {
			return true
		}
		if theLambdaFunction.Raw == "||" {
			return true
		}
	}
	return false
}


	
// Evaluate a single function call.
func eval(s State, command autoparser.Node, parent *autoparser.Node, level int) autoparser.Node {
	if len(command.List) == 0 {
		return Void(autoparser.Node{File: "eval", Line: 1, Column: 0, ChrPos: 1, Note: "empty eval"})
	}
	drintf("Evaluating: %v\n", TreeToXsh(command))
	// If list, assume it is a lambda function and evaluate it
	if isList(command.List[0]) {

		theLambdaFunction := command.List[0]
		drintf("Evaluating lambda: %v\n", theLambdaFunction)
		args := command.List[1:]

		bod := CopyTree(theLambdaFunction)
		bod.List = bod.List[1:]
		params := theLambdaFunction.List[0].List
		if theLambdaFunction.List[0].Note == "|" {

			if len(params) != len(args) {
				XshErr("Error %v,%v,%v: Mismatched function args in ->|%v|<-  expected %v, given %v\n[%v %v]\n", command.List[0].File, command.List[0].Line, command.List[0].Column, TreeToXsh(command), TreeToXsh(autoparser.Node{List: params}), TreeToXsh(autoparser.Node{List: args}), S(theLambdaFunction), TreeToXsh(autoparser.Node{List: args}))
				os.Exit(1)
			}
			nbod := ReplaceArgs(args, params, bod)
			drintf("Calling lambda %+v\n", nbod)
			return blockReduce(s, nbod.List, parent, 0)
		} else {
			// Programmer is trying to return a list, it's not a lambda function
			l := CopyNode(command)
			return l
		}
	}

	// If it s a string or symbol, look it up in the global
	// functions map and return the result
	f := S(command.List[0])
	preargs := command.List[1:]
	args := []autoparser.Node{}
	for _, v := range preargs {
		// if typeOf(v) != "void" {  //FIXME causes map etc. to fail.  Filtering out void alters the number of args to some calls.  Need to improve type system so void can't be returned in those situations.
		args = append(args, v)
		//}
	}

	// Do we have a type for this function?
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
	`, command.List[0].File, command.List[0].Line, command.List[0].Column, f, f, strings.Join(ftype[1:], " "), len(ftype)-1, f, TreeToXsh(autoparser.Node{List: args}), len(args))

				os.Exit(1)
			}
		}
		// Different checks for variadic functions
		// FIXME refactor duplicate code
		if lastArgType == "..." {
			varArgsType := ftype[len(ftype)-2]
			varArgs := []autoparser.Node{}
			if len(ftype)-2 < len(args) {
				varArgs = args[len(ftype)-2:]
			}
			// First, check that the specified types match
			// This is the fixed args array
			for i, v := range fixedArgs {
				drintf("Checking type %v against arg %v\n", v, typeOf(args[i]))
				if typeOf(args[i]) != v && v != "any" {
					XshWarn("Type error in named args at file %v line %v (command %v).  At argument %v, expected %v, got %v\n", command.List[0].File, command.List[0].Line, TreeToXsh(command), i+1, v, typeOf(args[i]))
				}
			}
			// Now check that the remaining args are of the varargs type
			drintf("Checking remaining args %v against varargs type %v\n", TreeToXsh(autoparser.Node{List: varArgs}), varArgsType)
			for i, v := range varArgs {
				drintf("Checking type %v against arg %v\n", typeOf(v), varArgsType)
				if typeOf(v) != varArgsType && varArgsType != "any" {
					XshWarn("Type error in vararg at file %v line %v (command %v).  At argument %v, expected %v (in ...), got %v\n", command.List[0].File, command.List[0].Line, TreeToXsh(command), i+len(ftype)-1, varArgsType, typeOf(v))
				}
			}
		} else {
			// There are no varags, simply check that the types match, and there are the correct number of args
			for i, v := range ftype[1:] {
				if typeOf(args[i]) != v && v != "any" {
					XshWarn("Type error in fixed args at file %v line %v (command %v).  At argument %v, expected %v, got %v\n", command.List[0].File, command.List[0].Line, TreeToXsh(command), i+1, v, typeOf(args[i]))
					XshInform("Node: %+v\n", args[i])
				}
			}
		}

	}
	fu, ok := s.Functions[f]
	if ok {
		// It's a user-defined function
		bod := CopyTree(fu.Body)
		fparams := fu.Parameters
		//FIXME: Need to handle user varargs here
		if len(fparams.List) != len(args) {
			XshErr(`Error %v,%v,%v: Mismatched function args in call to ->|%v|<-, expected %v, got %v
		
	Expected: %v
	Given:    %v
`, command.List[0].File, command.List[0].Line, command.List[0].Column, TreeToXsh(command), len(fparams.List), len(args), TreeToXsh(fparams), TreeToXsh(autoparser.Node{List: args}))
			os.Exit(1)
		}
		nbod := ReplaceArgs(args, fparams.List, bod)
		drintf("Calling function %+v\n", TreeToXsh(nbod))
		return blockReduce(s, nbod.List, parent, 0)
	} else {
		// It is a builtin function or an external call
		if f == "" {
			// We shouldn't get an empty string here, but if we do, we ignore it and keep going
			return Void(command)
		}

		// This is for the embedded xsh, it allows the embeddor to add their own functions,
		// e.g. to connect to data sources or do IO
		if s.ExtraBuiltins != nil {
			ret, handled := s.ExtraBuiltins(s, command.List, parent, level)
			if handled {
				return ret
			} else {
				drintf("No extra builtin for %v\n", TreeToXsh(command))
			}
		}
		drintf("No extra builtins while evaluating %v\n", TreeToXsh(command))
		argsNode := CopyNode(command)
		argsNode.List = args
		return builtin(s, command.List, parent, f, args, level, argsNode)

	}
	// Maybe we should return a warning here?  Or even exit?  Need a strict mode.
}

// BlockReduce operates a little bit oddly.  It evals a list of statements, and replaces each statement with
// the result of the statement.  It then returns the last result.
// The allows the debugger to show each statement as it is evaluated.
func blockReduce(s State, t []autoparser.Node, parent *autoparser.Node, toplevel int) autoparser.Node {
	drintf("BlockReduce: starting %+v\n", TreeToXsh(autoparser.Node{List: t}))
	// log.Printf("BlockReduce: starting %+v\n", t)

	// Empty block
	if len(t) == 0 {
		return Void(*parent)
	}

	// The scopebarrier prevents variable substitution happening to a code branch that has been copied in
	// from another function or scope.
	if (parent != nil) && parent.ScopeBarrier {
		return *parent
	}

	var out autoparser.Node
	if t[0].Note == "\n" && t[0].Raw == "\n" {
		// It is a multi line block, eval as statements, return the last

		for i, v := range t {
			out = treeReduce(s, v.List, parent, toplevel, v)
			t[i] = out
		}
	} else {
		// It is a single line lambda, eval it as an expression
		out = treeReduce(s, t, parent, toplevel, *parent)
	}

	drintf("Returning from BlockReduce: %v\n", TreeToXsh(out))
	return out
}

// Build a node location string from file, line, and column
func Loc(n autoparser.Node) string {
	return fmt.Sprintf("%v:%v:%v", n.File, n.Line, n.Column)
}

// Pretty print code.  The subTree will be highlighted if it is found in the tree.
// This is used by the debugger to show the current statement being evaluated.
func PrintTree(t autoparser.Node, subTree autoparser.Node) {
	PrintTreeRec(t, subTree, true, 1)
}

func indent(str string, level int) string {
	return strings.Repeat(str, level)
}

func printIndent(str string, level int) {
	fmt.Print(indent(str, level))
}

func NLindent(str string, level int) string {
	return "\n" + indent(str, level)
}

func PrintNLindent(str string, level int) {
	fmt.Print(NLindent(str, level))
}

// Recurse through program tree, printing each node
func PrintTreeRec(t autoparser.Node, subTree autoparser.Node, inBlock bool, level int) {
	highlight := pterm.NewStyle(pterm.FgRed, pterm.Bold)
	// function := pterm.NewStyle(pterm.FgMagenta, pterm.Bold)

	/*if Loc(t[0]) == Loc(subTree) {
		highlight.Print("(")
		function.Printf("%v", S(t[0]))
	} else {
		fmt.Printf("(%v", S(t[0]))
	}*/

	for i, v := range t.List {

		if i == 1 && isList(v) && len(v.List) == 1 && v.List[0].Raw == "|" {
			inBlock = true
			// fmt.Printf("%+v\n", v)
			continue
		}
		if i == 0 && isList(v) && len(v.List) == 0 {
			inBlock = true
			// fmt.Printf("%+v\n", v)
			continue
		}
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
					PrintTreeRec(v, subTree, false, level+1)

					highlight.Print("}")
				} else {
					fmt.Print("{")

					PrintTreeRec(v, subTree, false, level+1)

					if inBlock {
						fmt.Print(NLindent(" ", level))
					}
					fmt.Print("}")
				}
			case "|":
				PrintTreeRec(v, subTree, false, level)
				fmt.Print("|")
			default:
				if Loc(v) == Loc(subTree) {
					highlight.Print("(")
					PrintTreeRec(v, subTree, false, level)
					highlight.Print(")")
				} else {
					if inBlock {
						PrintNLindent(" ", level)
						PrintTreeRec(v, subTree, false, level)
					} else {
						fmt.Print("(")
						PrintTreeRec(v, subTree, false, level)
						fmt.Print(")")
					}
				}

			}
		case v.Raw != "":
			if Loc(v) == Loc(subTree) {
				highlight.Print(v.Raw) // FIXME escape string properly to include in JSON
			} else {
				fmt.Print(v.Raw)
			}
		default:
			if v.Note == "#" {
				fmt.Print("#")
				if Loc(v) == Loc(subTree) {
					highlight.Print(v.Str)
				} else {
					fmt.Print(v.Str)
				}
			} else {
				if Loc(v) == Loc(subTree) {
					// fmt.Printf("%+v", v)
					highlight.Print("\"" + v.Str + "\"") // FIXME escape string properly for JSON
				} else {
					fmt.Print("\"" + v.Str + "\"")
				}
			}
		}
	}
	if inBlock {
		PrintNLindent(" ", level-1)
	}
	/*
		if Loc(t[0]) == Loc(subTree) {
			highlight.Print(")")
		} else {
			fmt.Print(")")
		}*/
}

// Recursively evaluate a program tree down to the leaves, then "fold up" the results into a single value
// This is the heart of the interpreter.
func treeReduce(s State, t []autoparser.Node, parent *autoparser.Node, toplevel int, orig autoparser.Node) autoparser.Node {
	drintf("Reducing: %+v\n", TreeListToXsh(t))

	// Because XSH replaces functions with their definitions, and then evals them, there are bits of "other scopes" that get pasted into the running code.  These must not be evaluated in the current function scope, but in their own scope.  So we stop processing when we discover that we are in a different scope.
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
		if WantTrace && v.File != "" { // FIXME this is just masking a problem
			fmt.Printf("Trace: In %v: ", Loc(v))
			PrintTree(orig, v)
			fmt.Print("\n")
		}
		switch {
		case v.Note == "#":
			// Comment node
		case v.Raw == "#":
			// Comment node
		case v.List != nil:
			// A list can be a function call or a normal list
			if v.Note == "[" || v.Note == "\n" || v.Note == ";" {
				// Function call
				// log.Println("Command:", TreeToTcl(v.List))
				atom := treeReduce(s, v.List, &t[i], toplevel-1, orig)
				out = append(out, atom)
				t[i] = atom
			} else {
				// Normal list
				drintln("treeReduce: found list ", TreeToXsh(v))
				out = append(out, v)
				t[i] = v
			}
		default:
			// A literal or a variable
			atom := autoparser.Node{ChrPos: -1}
			if strings.HasPrefix(S(v), "$") {
				// Environment variable or global variable
				drintf("Environment variable lookup: %+v\n", S(v))
				vname := S(v)[1:] // Remove the $, this is the variable name
				drintf("Fetching %v from Globals: %+v\n", vname, s.Globals)
				if vname == "" {
					XshErr("$ found without variable name.  $ defines a variable, and cannot be used on its own.")
					os.Exit(1)
				} else {
					// Valid variable name
					if _, ok := s.Globals[vname]; ok {
						// Global variable (like an environment variable, but inside xsh)
						// FIXME: globals should go away?
						atom = N(s.Globals[vname])
						// FIXME
						atom.File = v.File
						atom.Line = v.Line
						atom.Column = v.Column
						atom.ChrPos = v.ChrPos
					} else {
						// Load value from environment
						if val := os.Getenv(vname); val != "" {
							atom = N(val)
							atom.File = v.File
							atom.Line = v.Line
							atom.Column = v.Column
							atom.ChrPos = v.ChrPos
						} else {
							// FIXME detect if environment variable is not set, or just empty.  Only throw error on not set.
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

	// Run command
	if len(out) > 0 {
		if WantTrace {
			fmt.Printf("Trace: Out %v: ", Loc(out[0]))
			PrintTree(orig, out[0])
			fmt.Print("\n")
		}
	}
	ret := eval(s, autoparser.Node{List: out}, parent, toplevel)
	drintf("Returning from treeReduce: %v\n", TreeToXsh(ret))
	return ret
}

// Turns a segment of a program tree into a json string
func TreeToJson(t autoparser.Node) string {
	out := ""
	for _, v := range t.List {
		switch {
		case v.Note == "VOID":
		case v.List != nil:
			out = out + "[" + TreeToJson(v) + "]"
		case v.Raw != "":
			out = out + "\"" + v.Raw + "\"" + " " // FIXME escape string properly for JSON

		default:
			out = out + "\"\\\"" + v.Str + "\\\"\"" + " " // FIXME escape string properly for JSON

		}
	}
	return out
}

// Convert a list of nodes into a string.
func TreeListToXsh(t []autoparser.Node) string {
	out := ""
	for _, v := range t {
		out = out + TreeToXsh(v)
	}
	return out
}

// Convert a single tree into a string
func TreeToXsh(t autoparser.Node) string {
	out := ""
	for i, v := range t.List {
		switch {
		case v.Note == "VOID":
		case v.List != nil:
			if i != 0 {
				out = out + " "
			}
			switch v.Note {
			case "{":
				out = out + "{" + TreeToXsh(v) + "}"
			case "|":
				out = out + TreeToXsh(v) + "|"
			default:
				out = out + "[" + TreeToXsh(v) + "]"
			}
		case v.Raw != "":
			if i != 0 {
				out = out + " "
			}
			out = out + v.Raw // FIXME escape string properly to include in JSON

		default:
			if i != 0 {
				out = out + " "
			}
			out = out + "\"" + v.Str + "\"" // FIXME escape string properly for JSON
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

// List all executable files in PATH
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
		// FIXME we can now read this dynamically from the types map[]
		return []string{"id", "and", "or", "join", "split", "puts", "+", "-", "*", "/", "+.", "-.", "*.", "/.", "loadfile", "set", "run", "seq", "with", "cd"}
	}
}

func TreeMap(f func(autoparser.Node) autoparser.Node, t autoparser.Node) autoparser.Node {
	if t.List == nil {
		return f(t)
	}
	out := []autoparser.Node{}
	for _, v := range t.List {
		if v.List != nil {
			out = append(out, TreeMap(f, v).List...)
		} else {
			new := f(v)
			if isList(new) {
				out = append(out, new.List...)
			} else {
				out = append(out, new)
			}
		}
	}
	r := autoparser.Node{t.Raw, t.Str, out, t.Note, t.Line, t.Column, t.ChrPos, t.File, t.ScopeBarrier}
	return r
}
