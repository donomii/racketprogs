package main

import (
	xsh "../.."

	"flag"
	"fmt"

	"io"
	"io/ioutil"
	"runtime"

	"github.com/nsf/termbox-go"

	"os"

	"strings"

	"github.com/mattn/go-runewidth"

	"github.com/pterm/pterm"
	//"github.com/lmorg/readline"

	_ "embed"
	"github.com/chzyer/readline"
	"github.com/donomii/goof"

	autoparser "../../../autoparser"
)

var guardianPath string
var trace bool

type function struct {
	Name       string
	Parameters []autoparser.Node
	Body       []autoparser.Node
}

var usePterm = true
var wantDebug bool
var wantShell bool

func main() {
	state := xsh.New()
	bindir := goof.ExecutablePath()
	if runtime.GOOS == "windows" {
		guardianPath = bindir + "/xshguardian.exe"
	} else {
		guardianPath = bindir + "/xshguardian"
	}

	/*
		fname := flag.String("f", "example.xsh", "Script file to execute")
		shellOpt := flag.Bool("shell", false, "Run interactive shell")
	*/
	resumeFile := flag.String("r", "", "Resume from file")
	tracef := flag.Bool("trace", false, "Trace execution")
	flag.BoolVar(&wantDebug, "debug", false, "Enable debug output")
	flag.Parse()
	xsh.WantDebug = wantDebug
	xsh.WantTrace = *tracef
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
		xsh.Eval(state, xsh.Stdlib_str, "stdlib")
		xsh.LoadEval(state, *resumeFile)
	case wantShell:
		fmt.Printf("%+v\n", xsh.TreeToTcl(xsh.Eval(state, xsh.Stdlib_str, "stdlib").List))
		shell(state)
	default:
		xsh.Eval(state, xsh.Stdlib_str, "stdlib")
		xsh.LoadEval(state, fname)
	}
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
func shell(state xsh.State) {

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
		fmt.Printf("Result: %+v\n", xsh.TreeToTcl([]autoparser.Node{xsh.Eval(state, line, "shell")}))
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
