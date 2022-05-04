package xsh

import (
	autoparser "../autoparser"
	"fmt"
	"github.com/donomii/goof"
	"io/ioutil"
	"log"
	"os"
	"strings"
	"time"
)

func addBuiltinTypes(s State) {
	s.TypeSigs["puts"] = []string{"void", "any", "..."}
	s.TypeSigs["put"] = []string{"void", "any", "..."}
	s.TypeSigs["format"] = []string{"void", "any", "..."}
	s.TypeSigs["list"] = []string{"list", "any", "..."}
	s.TypeSigs["seq"] = []string{"any", "any", "..."}
	s.TypeSigs["set"] = []string{"void", "string", "any"}
	s.TypeSigs["run"] = []string{"string", "string", "..."}
	s.TypeSigs["shell"] = []string{"string", "string"}
	s.TypeSigs["map"] = []string{"list", "lambda", "list"}
	s.TypeSigs["fold"] = []string{"any", "lambda", "any", "list"}
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
	s.TypeSigs["*."] = s.TypeSigs["+"]
	s.TypeSigs["/."] = s.TypeSigs["+"]
	s.TypeSigs["gt."] = s.TypeSigs["+"]
	s.TypeSigs["lt."] = s.TypeSigs["+"]
	s.TypeSigs["eq"] = s.TypeSigs["+"]
	s.TypeSigs["loadfile"] = []string{"string", "string"}
	s.TypeSigs["proc"] = []string{"void", "string", "list", "list"}
	s.TypeSigs["func"] = []string{"void", "string", "lambda"}
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
	s.TypeSigs["saveInterpreter"] = []string{"void string"}
	s.TypeSigs["return"] = []string{"any", "any"}
	s.TypeSigs["id"] = []string{"any", "any"}
	s.TypeSigs["tron"] = []string{"void"}
	s.TypeSigs["troff"] = s.TypeSigs["tron"]
	s.TypeSigs["dron"] = s.TypeSigs["tron"]
	s.TypeSigs["droff"] = s.TypeSigs["tron"]
	s.TypeSigs["debug"] = []string{"void", "string"}
	s.TypeSigs["trace"] = s.TypeSigs["debug"]
	s.TypeSigs["warn"] = s.TypeSigs["debug"]
	s.TypeSigs["errors"] = s.TypeSigs["debug"]
	s.TypeSigs["inform"] = s.TypeSigs["debug"]
}

func NotifyEvent(cmd []string) {
	if WantEvents {
		Events = append(Events, cmd)
	}
}

func Help(topic string) string {
	switch topic {
	case "builtins":
		return `
XSHELL builtins

Basic xsh commands

  puts 	[any] [...]	: Prints the arguments to the console.
  put 	[any] [...]	: Prints the arguments to the console.
  format [any] [...]: Formats a string, printf style.
  list 	[any] [...]	: Creates a list from the arguments.
  seq 	[any] [...]	: Calculates the arguments, returns the last.  See help syntax.
  set 	[string] [any]: Sets an environment variable to the value.
  run 	[string] [...]: Runs a command with the arguments.
  shell [string]	: Runs a command with the arguments.
  map 	[lambda] [list]: Maps a function over a list.
  fold  [lambda] [any] [list]: Folds a function over a list.
  cd 	[string]	: Changes the current working directory.

Xsh does not have automatic type promotion, so you must use different functions for integers and floats.

  Integers
  +  	[integer] [integer]: Adds two integers.
  -  	[integer] [integer]: Subtracts two integers.
  *  	[integer] [integer]: Multiplies two integers.
  / 	[integer] [integer]: Divides two integers.
  gt 	a b: True if a < b.
  lt  	a b: True if a < b.

  Floats
  +.  	[integer] [integer]: Adds two floats.
  -.  	[integer] [integer]: Subtracts two floats.
  *.  	[integer] [integer]: Multiplies two floats.
  /.  	[integer] [integer]: Divides two floats.
  gt. 	a b: True if a < b.
  lt. 	a b: True if a < b.
  eq 	[string] [string]: Returns true if the strings are equal.
  loadfile	[string]: Loads a file.
  proc 	[string] [list] [list]: Creates a procedure.  See help syntax.
  func 	[string] [lambda]: Creates a function.  See help syntax.
  exit 	[string]: Exits the interpreter.
  cons 	[string] [list]: Creates a list from the arguments.
  empty? [list]: Returns true if the list is empty.
  length [list]: Returns the length of the list.
  lindex [list] [string]: Returns the value at the index.
  lset 	 [list] index [any]value: Sets the value at the index.
  lrange [list] [string] [string]: Returns a sublist.
  split  [string] [string]separator: Splits a string into a list.
  join   [list] [string]: Joins a list into a string.
  chr 	 [integer]: Converts a number to a (Unicode) character.
  saveInterpreter [string]: Saves the interpreter state.
  return [any]: Returns the argument.
  id 	 [any]: Returns the argument.

  Controlling output:
  tron		  : Turns on tracing.
  troff	      : Turns off tracing.
  dron	      : Turns on debugging.
  droff		  : Turns off debugging.
  debug on/off: Enables/disables debug messages.
  trace on/off: Enables/disables trace messages.
  warn on/off : Enables/disables warning messages.
  errors on/off: Enables/disables error messages.
  inform on/off: Enables/disables informational messages.

`
	case "":
		return `
XSHELL

XSHELL is a shell for the Go programming language.

Usage: xsh [options] [command] [arguments]

Options:
  -h, --help: Show this help message.
  -v, --version: Show the version number.
  -e, --events: Show events.
  -s, --silent: Show nothing.
  -d, --debug: Show debug messages.
  -t, --trace: Show trace messages.
  -w, --warn: Show warn messages.
  -i, --info: Show info messages.
  -e, --errors: Show errors messages.
  -l, --load: Load a file.
  -p, --proc: Create a procedure.
  -f, --func: Create a function.
  -x, --exit:


`
	case "shell":
		return `
		XSHELL command line
		
The xshell command line is shell that is not POSIX compatible, 
but tries to look like it.  The basic operations are the same 
to move around the disk, work on files and launch programs.

The xsh scripting language is very different.  see 'help scripting'
for more details.

`
	default:
		return `
XSHELL HELP

Xshell is a command shell and scripting language.  It is not compatible
 with POSIX shells, but is still familiar.

Basic commands and environment variables work as usual:

ls -lh
set LISTDIR /home
ls -lh $LISTDIR


Key shortcuts function roughly as usual:

TAB - rotate through completion suggestions
F5 - auto-complete
F1 - help
Up/Down - history
Ctrl-D - exit

More help is available by typing "help" or "?" followed by one of these topics:

online, scripting, builtins, variables, history, shell, environment
`
	}
}
func builtin(s State, command []autoparser.Node, parent *autoparser.Node, f string, args []autoparser.Node, level int) autoparser.Node {
	cmd, _ := ListToStrings(command)
	switch f {
	case "help":
		if len(args) == 0 {
			return N(Help(""))
		} else {
			return N(Help(S(args[0])))
		}
	case "sleep":
		if len(args) == 1 {
			t := atoi(S(args[0]))
			time.Sleep(time.Duration(t) * time.Millisecond)
		}
	case "nand":
		if S(args[0]) == "1" && S(args[1]) == "1" {
			return Bool(false)
		} else {
			return Bool(true)
		}
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
				evalledArgs = append(evalledArgs, treeReduce(s, e.List, nil, 0, e.List))
			}
		}
		letbod := CopyTree(args[3].List)
		//fmt.Printf("Replacing %v with %v\n", TreeToXsh(letparams), TreeToXsh(evalledArgs))
		nbod := ReplaceArgs(evalledArgs, letparams, letbod)
		drintf("Calling function %+v\n", TreeToXsh(nbod))
		return blockReduce(s, nbod, parent, 0)
	case "..":
		NotifyEvent(cmd)
		os.Chdir("..")
		XshResponse("Current working directory: %v", goof.Cwd())
	case "cd":
		NotifyEvent(cmd)
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
		XshResponse("Current working directory: %v", goof.Cwd())
	case "\n":
		//Fuck
		return Void(command[0])
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
		return N(fmt.Sprintf("%v", TreeToXsh(args)))

	case "eq":
		if S(args[0]) == S(args[1]) {
			return N("1")
		} else {
			return N("0")
		}
		//FIXME dedupe
	case "tron":
		WantTrace = true
		return N("Trace on")
	case "troff":
		WantTrace = false
		return N("Trace off")
	case "dron":
		WantDebug = true
		return N("Debug on")
	case "droff":
		WantDebug = false
		return N("Debug off")
		//FIXME replace with an options hash later on
	case "debug":
		if S(args[0]) == "1" || S(args[0]) == "on" {
			WantDebug = true
		} else {
			WantDebug = false
		}
	case "inform":
		if S(args[0]) == "1" || S(args[0]) == "on" {
			WantInform = true
		} else {
			WantInform = false
		}
	case "helpful":
		if S(args[0]) == "1" || S(args[0]) == "on" {
			WantHelp = true
		} else {
			WantHelp = false
		}
	case "trace":
		if S(args[0]) == "1" || S(args[0]) == "on" {
			WantTrace = true
		} else {
			WantTrace = false
		}
	case "errors":
		if S(args[0]) == "1" || S(args[0]) == "on" {
			WantErrors = true
		} else {
			WantErrors = false
		}
	case "warn":
		if S(args[0]) == "1" || S(args[0]) == "on" {
			WantWarn = true
		} else {
			WantWarn = false
		}
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
		return N(TreeToXsh(args))
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
		if len(args) > 0 {
			return N(TreeToXsh(args))
		} else {
			return N("")
		}
	case "format":
		return N(TreeToXsh(args))
	case "loadfile":
		NotifyEvent(cmd)
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
	case "eval":
		res := Run(s, args[0].List)
		return res
	case "run":
		NotifyEvent(cmd)
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
	case "shell":
		NotifyEvent(cmd)
		shellcmd := S(args[0])
		return N(goof.Shell(shellcmd))
	case "func":
		/*
			func procedureName {arguments|
			   body
			}
		*/
		if len(args) != 2 {
			a := TreeToXsh(args)
			msg := fmt.Sprintf("Error %v,%v: func requires 2 arguments: func name {arguments| body}\n[%v %v]\n", command[0].Line, command[0].Column, f, a)

			log.Panicf(msg)
		}
		//fmt.Printf("%+v\n", args)
		body := args[1].List
		s.Functions[S(args[0])] = Function{
			Name:       S(args[0]),
			Parameters: body[0].List,
			Body:       body[1:],
		}

		//fmt.Printf("%+v\n", s.Functions[S(args[0])])

	case "proc":
		/*
			proc procedureName {arguments} {
			   body
			}
		*/
		if len(args) != 3 {
			a := TreeToXsh(args)
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
		out := autoparser.Node{List: list, File: command[0].File, Line: command[0].Line, Column: command[0].Column, ChrPos: command[0].ChrPos, Note: "{"}
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
		//FIXME each element needs a unique id
		list, _ := ListToStrings(args[0].List)
		delim := S(args[1])
		out := N(strings.Join(list, delim))
		out.File = parent.File
		out.Line = parent.Line
		out.Column = parent.Column
		out.ChrPos = parent.ChrPos
		return out
	case "chr":
		return N(string(atoi(S(args[0]))))
	case "if":
		if len(args) == 3 && S(args[2]) != "else" {
			panic("If missing else")
		}
		if atoi(S(args[0])) != 0 {
			ret := blockReduce(s, args[1].List, parent, level)
			drintln("Returning from if true branch:", TreeToXsh([]autoparser.Node{ret}))
			return ret
		} else if len(args) == 4 {
			ret := blockReduce(s, args[3].List, parent, level)
			drintln("Returning from if false branch:", TreeToXsh([]autoparser.Node{ret}))
			return ret
		} else {
			XshWarn("No else for if at %v:%v\n", command[0].Line, command[0].Column)
			return Void(command[0])
		}

	case "saveInterpreter":
		NotifyEvent(cmd)
		if len(args) < 1 {
			XshErr("saveInterpreter: no filename specified")
			return N("No filename given")
		}
		*parent = Void(command[0])
		rest := TreeToXsh(s.Tree)
		funcs := FunctionsToTcl(s.Functions)
		code := funcs + "\n\n" + rest
		fmt.Printf("Function defs: %v\n\nRemaining code: %v\n", funcs, rest)

		ioutil.WriteFile(S(args[0]), []byte(code), 0644)

	case "return":
		return args[0]
	case "id":
		return args[0]
	case "list":
		//FIXME need a unique id for each element in tree
		out := autoparser.Node{List: args, File: parent.File, Line: parent.Line, Column: parent.Column, ChrPos: parent.ChrPos, Note: "{"}
		return out
	default:
		//It is an external call, prepare the shell command then run it
		//fixme warn user on verbose?
		//fmt.Printf("Unknown command: '%s', attempting shell\n", f)
		if command[0].Note == "\"" {
			return command[0]
		}
		stringCommand, err := ListToStrings(command)
		if err != nil {
			log.Printf("Error %v,%v,%v: converting command to string: %v\n", command[0].File, command[0].Line, command[0].Column, err)
			return Void(command[0])
		} else {
			var res string
			var err error
			if level == 1 {
				drintln("Running", stringCommand, "interactively")
				err = runWithGuardian(stringCommand)
			} else {
				drintln("Running", stringCommand, "to capture output")
				res, err = runWithGuardianCapture(stringCommand)
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
	return Void(command[0])
}
