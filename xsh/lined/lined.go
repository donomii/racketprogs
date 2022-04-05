package lined

import (
	//"strings"
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"runtime"
	"strings"
	"time"

	//"sort"
	"net/rpc"

	"github.com/donomii/termbox-go"

	"sync"
)

var completeVersion = 1
var use_gui = true

var statuses map[string]string
var selection = 0
var itempos = 0
var cursorX = 11
var cursorY = 1
var selectPosX = 11
var selectPosY = 1
var focus = "input"
var inputPos = 0
var InputLine string
var debugStr = ""
var client *rpc.Client

var predictResults []string

var refreshMutex sync.Mutex

var LineCache map[string]string

func FetchLine(f string, lineNum int) (line string, lastLine int, err error) {
	key := fmt.Sprintf("%v%v", f, lineNum)
	if val, ok := LineCache[key]; ok {
		return val, -1, nil
	} else {
		r, _ := os.Open(f)
		sc := bufio.NewScanner(r)
		for sc.Scan() {
			lastLine++
			if lastLine == lineNum {
				LineCache[key] = sc.Text()
				return sc.Text(), lastLine, sc.Err()
			}
		}
		LineCache[key] = line
		return line, lastLine, io.EOF
	}
}

var completeMatch = false

func isLinux() bool {
	return (runtime.GOOS == "linux")
}

func isDarwin() bool {
	return (runtime.GOOS == "darwin")
}

func refreshTerm() {
	prompt := "xsh:"
	//statuses["Screen"] = "Refresh"
	if use_gui {
		width, height := termbox.Size()
		refreshMutex.Lock()
		defer refreshMutex.Unlock()
		//termbox.Clear(foreGround(), backGround())
		putStr(0, 0, debugStr)
		putStr(0, height-1, fmt.Sprintf("%v%v%v", prompt, InputLine, strings.Repeat(" ", width-len(InputLine)-len(prompt)))) //FIXME

		itempos = 0

		putStr(20, height-4, fmt.Sprintf("%v", statuses))
		putStr(1, height-3, fmt.Sprintf("Type your search terms, add a - to the end of word to remove that word (word-)"))
		putStr(1, height-2, fmt.Sprintf("Up/Down Arrows to select a result, Right Arrow to edit that file, Escape Quits"))
		if focus == "input" {
			putStr(8, 9, "                    ")
			for i, v := range predictResults {
				if i < 10 {
					putStr(8, 9, "-----Suggestions----")
					putStr(8, 10+i, "|                  |")
					putStr(8, 10+i+1, "--------------------")
					putStr(10, 10+i, v)
				}
			}
		}

		if focus == "input" {
			termbox.SetCursor(len(prompt)+inputPos, height-1)
		} else {
			termbox.SetCursor(selectPosX, selectPosY)
		}
		termbox.Flush()
	}
}

//Find the first space character to the left of the cursor
func searchLeft(aStr string, pos int) int {
	for i := pos; i > 0; i-- {
		if aStr[i-1] == ' ' {
			if pos != i {
				return i
			}
		}
	}
	return 0
}

//Find the first space character to the right of the cursor
func searchRight(aStr string, pos int) int {
	for i := pos; i < len(aStr)-1; i++ {
		if aStr[i+1] == ' ' {
			if pos != i {
				return i
			}
		}
	}
	return len(aStr) - 1
}

func extractWord(aLine string, pos int) string {
	start := searchLeft(aLine, pos)
	return aLine[start:pos]
}

var KeyHook func(key string)

func CallKeyHook(key string) {
	if KeyHook != nil {
		KeyHook(key)
	}
}

func doInput() {
	if use_gui {
		//statuses["Input"] = "Waiting"
		//width, height := termbox.Size()
		ev := termbox.PollEvent()
		if ev.Type == termbox.EventKey {
			if ev.Mod == termbox.ModAlt {
				switch ev.Key {
				case termbox.KeyArrowRight:
					inputPos = searchRight(InputLine, inputPos)
				case termbox.KeyArrowLeft:
					inputPos = searchLeft(InputLine, inputPos)
				}
			} else {
				//statuses["Input"] = fmt.Sprintf("%v", ev.Key) //"Processing"
				//debugStr = fmt.Sprintf("key: %v, %v, %v", ev.Key, ev.Ch, ev)
				switch ev.Key {
				case termbox.KeyF1:
					CallKeyHook("F1")
				case termbox.KeyF2:
					CallKeyHook("F2")
				case termbox.KeyF3:
					CallKeyHook("F3")
				case termbox.KeyF4:
					CallKeyHook("F4")
				case termbox.KeyF5:
					CallKeyHook("F5")
				case termbox.KeyArrowRight:

				case termbox.KeyArrowDown:
				case termbox.KeyArrowUp:
					selection--
					if selection < 0 {
						selection = 0
					}
					focus = "selection"
				case termbox.KeyEsc:
					shutdown()
				case termbox.KeyBackspace, termbox.KeyBackspace2:
					if len(InputLine) > 0 {
						InputLine = InputLine[0 : len(InputLine)-1]
						inputPos -= 1
					}

					focus = "input"
					refreshTerm()
				case termbox.KeyEnter:

					completeVersion = completeVersion + 1
				case termbox.KeySpace:
					InputLine = fmt.Sprintf("%s ", InputLine)
					inputPos += 1
					refreshTerm()

				default:
					//statuses["Input"] = ev.Key
					InputLine = fmt.Sprintf("%s%c", InputLine, ev.Ch)
					inputPos += 1
					cursorX = 11 + len(InputLine)
					cursorY = 1
					focus = "input"
					refreshTerm()
				}
			}
		}
	}
}

func FinishInput() {
	completeVersion = completeVersion + 1
}

//ForeGround colour
func foreGround() termbox.Attribute {
	return termbox.ColorBlack
}

//Background colour
func backGround() termbox.Attribute {
	return termbox.ColorWhite
}

//Display a string at XY
func putStr(x, y int, aStr string) {
	width, height := termbox.Size()
	if y >= height {
		return
	}
	for i, r := range aStr {
		if x+i >= width {
			return
		}
		termbox.SetCell(x+i, y, r, foreGround(), backGround())
	}
}

//Redraw screen every 200 Milliseconds
func automaticRefreshTerm(threadVer int) {
	for i := 0; i < 1; i = 0 {
		if threadVer < completeVersion {
			log.Println("Exiting automatic refresh")
			return
		}
		refreshTerm()
		time.Sleep(time.Millisecond * 200)
	}
}

func automaticdoInput(threadVer int) {
	for i := 0; i < 1; i = 0 {
		if threadVer < completeVersion {
			log.Println("Exiting automatic doInput")
			return
		}
		doInput()
		time.Sleep(20 * time.Millisecond)
	}
}

//Clean up and exit
func shutdown() {
	//Shut down resources so the display thread doesn't panic when the display driver goes away first
	//When we get a file persistence layer, it will go here
	statuses["Status"] = "Shutting down"
	use_gui = false
	os.Exit(0)

}

func Init() {
	LineCache = map[string]string{}
	InputLine = ""

	refreshMutex = sync.Mutex{}
	predictResults = []string{}
	statuses = map[string]string{}
	completeVersion = completeVersion + 1
	termbox.Init()
	termbox.SetInputMode(termbox.InputEsc)
}
func ReadLine() string {
	completeVersion = completeVersion + 1
	InputLine = ""
	inputPos = 0

	//termbox.SetInputMode(termbox.InputAlt)
	//defer termbox.Close()
	use_gui = true
	defer func() { use_gui = false }()
	go automaticRefreshTerm(completeVersion)
	go automaticdoInput(completeVersion)

	threadVer := completeVersion
	for threadVer == completeVersion {
		time.Sleep(10 * time.Millisecond)
	}
	use_gui = false

	return InputLine
}

/*
func main() {
	fmt.Println(ReadLine())
}
*/
