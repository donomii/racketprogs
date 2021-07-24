package main

import (
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"

	atto "../.."
	"github.com/chzyer/readline"
)

func main() {
	var debug bool
	flag.BoolVar(&debug, "debug", false, "Print looots of debug information")
	flag.Parse()
	if !debug {
		log.SetFlags(0)
		log.SetOutput(ioutil.Discard)
	}
	a := atto.NewAtto()
	atto.LoadFile(flag.Args()[0], a)
	atto.RunFunc("main", a)
	if debug {

		fmt.Println("Done!")
	}
	Repl(a)
}

var completer = readline.NewPrefixCompleter(
	readline.PcItem("mode",
		readline.PcItem("vi"),
		readline.PcItem("emacs"),
	),
	readline.PcItem("login"),

	readline.PcItem("setprompt"),
	readline.PcItem("setpassword"),
	readline.PcItem("bye"),
	readline.PcItem("help"),
	readline.PcItem("go",
		readline.PcItem("build", readline.PcItem("-o"), readline.PcItem("-v")),
		readline.PcItem("install",
			readline.PcItem("-v"),
			readline.PcItem("-vv"),
			readline.PcItem("-vvv"),
		),
		readline.PcItem("test"),
	),
	readline.PcItem("sleep"),
)

func Repl(e *atto.Atto) *atto.Atto {

	prompt := "\033[32matto » "

	l, err := readline.NewEx(&readline.Config{
		Prompt:          prompt,
		HistoryFile:     "transcript.txt",
		AutoComplete:    completer,
		InterruptPrompt: "^C",
		EOFPrompt:       "exit",
	})
	if err != nil {
		panic(err)
	}
	defer l.Close()
	//log.SetOutput(l.Stderr())

	return realRepl(e, l)
}

func realRepl(e *atto.Atto, rl *readline.Instance) *atto.Atto {
	//engineDump(e)
	fmt.Printf("Ready> ")
	//reader := bufio.NewReader(os.Stdin)
	//text, _ := reader.ReadString('\n')
	rl.Config.AutoComplete = readline.NewPrefixCompleter(readline.PcItemDynamic(
		func(string) []string {
			keys := []string{}
			for k := range e.Functions {
				keys = append(keys, k)
			}
			return keys
		},
	))
	line, err := rl.Readline()
	rl.Write([]byte("\033[33m"))
	fmt.Printf("\n")
	if err == readline.ErrInterrupt {
		if len(line) == 0 {
			return e
		} else {
			//continue
		}
	} else if err == io.EOF {
		return e
	}

	if len(line) > 0 {
		text := "fn repl is print " + line
		atto.LoadString(text, e)
		atto.RunFunc("repl", e)
		fmt.Printf("\n\n")
		//emit(fmt.Sprintln(e.dataStack[len(e.dataStack)-1].GetString()))

		realRepl(e, rl)
		return e
	} else {
		return e
	}
}
