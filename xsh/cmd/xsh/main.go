package main

import (
	lined "../../lined"
	"os/signal"

	xsh "../.."
	"flag"
	"fmt"
	"runtime"

	"io"
	"io/ioutil"

	"github.com/donomii/termbox-go"

	"os"

	"strings"

	"github.com/mattn/go-runewidth"

	"github.com/pterm/pterm"

	_ "embed"

	"github.com/chzyer/readline"

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

	resumeFile := flag.String("r", "", "Resume from file")
	tracef := flag.Bool("trace", false, "Trace execution")
	flag.BoolVar(&wantDebug, "debug", false, "Enable debug output")
	flag.Parse()
	xsh.WantDebug = wantDebug
	xsh.WantTrace = *tracef
	trace = *tracef
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
		//fmt.Printf("%+v\n", xsh.TreeToTcl(xsh.Eval(state, xsh.Stdlib_str, "stdlib").List))
		xsh.Eval(state, xsh.Stdlib_str, "stdlib")
		if runtime.GOOS == "windows" {
			shell(state)
		} else {
			NewShell(state)
		}
	default:
		xsh.Eval(state, xsh.Stdlib_str, "stdlib")
		xsh.LoadEval(state, fname)
	}
}

// Returns function that lists given directory
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

func keys(aHash map[string][]string) []string {
	keys := make([]string, 0)
	for k := range aHash {
		keys = append(keys, k)
	}
	return keys
}

//Use the types hash?
func listBuiltins(s xsh.State) func(string) []string {
	return func(line string) []string {
		return keys(s.TypeSigs)
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
		readline.PcItemDynamic(listBuiltins(state),
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
		xsh.XshErr(fmt.Sprintf("%s", err))
		panic(err)
	}
	defer l.Close()

	if usePterm {
		// Print a large text banner with differently colored letters.
		pterm.DefaultBigText.WithLetters(
			pterm.NewLettersFromStringWithStyle("X", pterm.NewStyle(pterm.FgLightMagenta)),
			pterm.NewLettersFromStringWithStyle("Shell", pterm.NewStyle(pterm.FgCyan))).
			Render()
	}

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func() {
		for sig := range c {
			// sig is a ^C, handle it
			//Kill any running guardians?
			fmt.Printf("\n%v\n", sig)
			xsh.XshWarn("Break")
		}
	}()

	for {
		line, err := l.Readline()
		if err == readline.ErrInterrupt {
			xsh.XshWarn("Canceled.  Ctrl-D to exit.\n")
			continue
			/*			if len(line) == 0 {
							break
						} else {
							continue
						}
			*/
		} else if err == io.EOF {
			xsh.XshWarn("Input finished, exiting.")
			break
		}

		line = strings.TrimSpace(line)
		xsh.XshResponse("%+v\n", xsh.TreeToXsh([]autoparser.Node{xsh.ShellEval(state, line, "shell")}))
	}
}

func NewShell(state xsh.State) {

	if usePterm {
		// Print a large text banner with differently colored letters.
		pterm.DefaultBigText.WithLetters(
			pterm.NewLettersFromStringWithStyle("X", pterm.NewStyle(pterm.FgLightMagenta)),
			pterm.NewLettersFromStringWithStyle("Shell", pterm.NewStyle(pterm.FgCyan))).
			Render()
	}

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func() {
		for sig := range c {
			// sig is a ^C, handle it
			//Kill any running guardians?
			fmt.Printf("\n%v\n", sig)
			xsh.XshWarn("Break")
		}
	}()
	lined.Init(os.Getenv("HOME") + "/.xsh/history")
	lined.KeyHook = func(key string) {
		switch key {
		case "TAB":
			lined.Statuses["complete"] = lined.ExtractWord(lined.InputLine, lined.InputPos)
			words := append(xsh.ListBuiltins()("lalala"), xsh.ListPathExecutables()("lalala")...)
			words = append(words, xsh.ListFiles("./")("./")...)
			completions := make([]string, 0)
			for _, w := range words {
				if strings.HasPrefix(w, lined.Statuses["complete"]) {
					completions = append(completions, w)

				}
			}
			lined.Statuses["complete"] = fmt.Sprintf("%v", completions)
		default:
			command := os.Getenv(key)
			lined.InputLine = command
			lined.FinishInput()
		}
	}
	os.Setenv("F1", `puts "ICE - Interactive Command Environment

	ICE is a shell that allows you to write and run commands in a Text UI.  At its core is
	XSH, a simple scripting language.  ICE
	
	"`)
	for {
		fmt.Printf("\n\n")
		line := lined.ReadLine()

		line = strings.TrimSpace(line)
		fmt.Println()
		res := xsh.TreeToXsh([]autoparser.Node{xsh.ShellEval(state, line, "shell")})
		if res != "" && res != "\"\"" {
			xsh.XshResponse("%+v\n", res)
		}
	}
}
