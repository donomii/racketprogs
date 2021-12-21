package main

import (
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"

	atto "../.."
	"github.com/chzyer/readline"
)

var completer = readline.NewPrefixCompleter()

func in(k string, list []string) bool {
	for _, v := range list {
		//.Printf("Comparing %v and %v\n", k, v)

		if v == k {
			return true
		}
	}
	return false
}

func strify(v interface{}) string {
	switch v.(type) {
	case nil:
		return ""
	case []interface{}:
		if fmt.Sprintf("%v", v.([]interface{})[0]) == "__value" {
			return fmt.Sprintf("%v", v.([]interface{})[1])
		}

		o := "("

		for i, e := range v.([]interface{}) {
			atom := fmt.Sprintf("%v", e)
			if i == 0 {
				fn := atom
				switch fn {
				case "#":
					o = o + "drop "
				default:
					o = o + fn + " "
				}
			} else {
				o = o + strify(e) + " "
			}
		}
		return o + ")"
	case string:
		return fmt.Sprintf("\"%v\"", v)
	default:
		return fmt.Sprintf("%v", v)
	}
}
func main() {
	var debug, scheme bool
	flag.BoolVar(&debug, "debug", false, "Print looots of debug information")
	flag.BoolVar(&scheme, "scheme", false, "Dump code as scheme s-expression")

	flag.Parse()
	if !debug {
		log.SetFlags(0)
		log.SetOutput(ioutil.Discard)
	}
	a := atto.NewAtto()

	if scheme {
		atto.LoadFilewCore(flag.Args()[0], a)
		for k, v := range a.Functions {
			if !in(k, []string{"cons", "true", "tail", "head", "and", "false", "or", "pair"}) {
				//fn := strings.Replace(fmt.Sprintf("%v", v), "fn", "define "+k, 1)
				fmt.Printf("(define %v (lambda %v %v))\n", k, strify(v[1]), strify(v[2]))
			}
		}
		os.Exit(0)
	}
	if len(flag.Args()) > 0 {

		atto.LoadFilewCore(flag.Args()[0], a)
		atto.RunFunc("main", a)

		if debug {

			fmt.Println("Done!")
		}
	} else {
		Repl(a)
	}
}

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
