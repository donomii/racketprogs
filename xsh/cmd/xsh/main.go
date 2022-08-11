package main

import (
	"os/signal"
	"path"

	lined "../../lined"

	"flag"
	"fmt"
	"runtime"

	xsh "../.."

	"io"
	"io/ioutil"

	"github.com/mitchellh/go-homedir"

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
		xsh.Eval(state, xsh.  Stdlib_str, "stdlib")
		xsh.LoadEval(state, *resumeFile)
	case wantShell:
		//fmt.Printf("%+v\n", xsh.TreeToTcl(xsh.Eval(state, xsh.Stdlib_str, "stdlib").List))
		xsh.Eval(state, xsh.Stdlib_str, "stdlib")
		if runtime.GOOS == "win s" {
			NewShell(state)
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
		sep := ":"
		if runtime.GOOS == "windows" {
			sep = ";"
		}
		paths := strings.Split(os.Getenv("PATH"), sep)
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
		xsh.XshResponse("%+v\n", xsh.TreeToXsh(xsh.ShellEval(state, line, "shell")))
	}
}

//Count the number of spaces in a string
func countSpaces(s string) int {
	count := 0
	for _, c := range s {
		if c == ' ' {
			count++
		}
	}
	return count
}

//Take a relative path and turn it into an absolute path.  Expand ~ to home directory, and expand
//other shell shortcuts.
func expandPath(s string) string {
	if s == "" {
		return ""
	}
	if s[0] == '~' {
		return os.Getenv("HOME") + s[1:]
	}
	if s[0] == '.' {
		return "./" + s[1:]
	}
	if s[0] == '/' {
		return s
	}
	return s
}

//FIXME
var current_completions = []string{}
var current_completion_word = ""
var current_completion_index = 0

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
	dir, _ := homedir.Dir()
	lined.Init(dir + "/.xsh/history")
	lined.EveryKeyHook = func(key rune) {
		newFunction()
	}
	lined.KeyHook = func(key string) {

		xsh.XshInform("KeyHook: %s", key)
		if key != "TAB" {
			current_completion_index = 0

			//Also need to generate new completions
			//Probably async
		}
		switch key {
		case "F1":
			if usePterm {
				// Print a large text banner with differently colored letters.
				pterm.DefaultBigText.WithLetters(
					pterm.NewLettersFromStringWithStyle("X", pterm.NewStyle(pterm.FgLightMagenta)),
					pterm.NewLettersFromStringWithStyle("Shell", pterm.NewStyle(pterm.FgCyan))).
					Render()
			}
			//Display help message, eventually context sensitive help
			xsh.XshResponse(xsh.Help("intro"))

		case "F2":
		case "TAB":
			//Accept the completion of the current line
			//Insert the first element of current_completions into lined.InputLine at lined.InputPos

			if current_completion_index < len(current_completions) {
				completion_word := current_completions[current_completion_index]
				current_word := lined.ExtractWord(lined.InputLine, lined.InputPos)
				completion_string := completion_word

				if completion_word[len(completion_word)-1] != '/' {
					//remove current_word from the start of completion_word, and add a space
					completion_string = completion_word[len(current_word):]
				}
				if len(completion_string) > 0 {
					//If the last letter of completion_string is not a "/", add a space
					if completion_string[len(completion_string)-1] != '/' {
						completion_string = completion_string + " "
					}
					lined.InputLine = strings.Join([]string{lined.InputLine[:lined.InputPos], completion_string, lined.InputLine[lined.InputPos:]}, "")
					lined.InputPos += len(completion_string)
				}
			}
		case "F5":
			//If the current word is the same as the last completion word, then we are cycling through the
			//completions.
			//Separate current word into path and partial filename
			//If path is empty, use current directory
			//If path is not empty, use path
			//Build a string from completions, put a * next to the current completion
			newFunction()
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
		fmt.Printf("\n\n\n\n\n")
		line := lined.ReadLine()

		line = strings.TrimSpace(line)
		fmt.Println()

		res := xsh.TreeToXsh(xsh.ShellEval(state, line, "shell"))
		if res != "" && res != "\"\"" {
			xsh.XshResponse("%+v\n", res)
		}
		for _, v := range xsh.Events {
			fc := v[0]
			if fc == "cd" {
				//Get a list of files in the current directory
				files := xsh.ListFiles(".")(".")
				//If the list of files is longer than 10, take the first ten elements of the list
				if len(files) > 10 {
					files = files[:10]
					files = append(files, "...")
				}
				xsh.XshResponse("%v\n", files)
			}
		}
		xsh.Events = [][]string{}
	}
}

func newFunction() {
	xsh.XshInform("Generating new completions")
	current_word := lined.ExtractWord(lined.InputLine, lined.InputPos)
	lined.Statuses["current_word"] = current_word
	lined.Statuses["current_completion_word"] = current_completion_word
	completions := current_completions
	if current_word == current_completion_word {

		if current_completion_index < len(current_completions)-1 {
			current_completion_index++
		} else {
			current_completion_index = 0
		}
	} else {
		lined.Statuses["complete"] = current_word
		current_completion_word = current_word
		current_completion_index = 0
		current_completions = []string{}
		completions = []string{}
		words := []string{}
		if countSpaces(lined.InputLine[:lined.InputPos]) == 0 {
			words = append(xsh.ListBuiltins()("lalala"), xsh.ListPathExecutables()("lalala")...)
		}

		userpath, filename := path.Split(current_word)
		path := expandPath(userpath)
		if path == "" {
			path = "./"
		}

		words = append(words, xsh.ListFiles(path)(path)...)

		for _, w := range words {
			if strings.HasPrefix(w, filename) {
				completions = append(completions, w)
			}
		}
		current_completions = completions
	}

	completion_string := ""
	for i, c := range completions {
		if i == current_completion_index {
			completion_string += "*"
		}
		completion_string += c + " "
	}
	lined.Statuses["complete"] = completion_string
}
