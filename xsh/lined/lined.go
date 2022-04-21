package lined

import (
	//"strings"
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"runtime"
	"strings"
	"time"
	//"sort"
	"net/rpc"

	"github.com/donomii/termbox-go"
	"path/filepath"
	"sort"
	"sync"
)

var completeVersion = 1
var use_gui = true
var History []string
var Statuses map[string]string
var selection = 0
var itempos = 0
var cursorX = 11
var cursorY = 1
var selectPosX = 11
var selectPosY = 1
var focus = "input"
var InputPos = 0
var InputLine string
var debugStr = ""
var client *rpc.Client
var prompt = "xsh:"
var confPath string

var predictResults []string

var refreshMutex sync.Mutex

var LineCache map[string]string

type Config struct {
	History []string
}

var conf Config

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

func blankPanel() {
	width, height := termbox.Size()
	char := " "
	putStr(0, height-4, strings.Repeat(char, width))
	putStr(0, height-3, strings.Repeat(char, width))
	putStr(0, height-2, strings.Repeat(char, width))
	putStr(0, height-1, strings.Repeat(char, width))

}

func setTrans() {
	width, height := termbox.Size()
	char := string([]byte{0})
	for i := 0; i < height; i++ {
		putStr(0, i, strings.Repeat(char, width))
	}
}

//build a map into a string, sorting by key
func mapToString(aMap map[string]string) string {
	var keys []string
	for k := range aMap {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	var result string
	for _, k := range keys {
		result = result + fmt.Sprintf("[%v] %v ", k, aMap[k])
	}
	return result
}

func refreshTerm() {

	//statuses["Screen"] = "Refresh"
	if use_gui {
		blankPanel()
		width, height := termbox.Size()
		refreshMutex.Lock()
		defer refreshMutex.Unlock()
		//termbox.Clear(foreGround(), backGround())
		//		putStr(0, 0, debugStr)

		putStr(0, height-1, fmt.Sprintf("%v%v%v", prompt, InputLine, strings.Repeat(" ", width-len(InputLine)-len(prompt)))) //FIXME

		itempos = 0

		putStr(1, height-4, fmt.Sprintf("%v", mapToString(Statuses)))
		dir, _ := os.Getwd()
		putStr(1, height-3, fmt.Sprintf("CWD: %v", dir))
		putStr(1, height-2, fmt.Sprintf("F1 help F5 autocomplete TAB cycle autocomplete CTRL-D exit"))
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
			termbox.SetCursor(len(prompt)+InputPos, height-1)
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

func ExtractWord(aLine string, pos int) string {
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
					InputPos = searchRight(InputLine, InputPos)
				case termbox.KeyArrowLeft:
					InputPos = searchLeft(InputLine, InputPos)
				}
			} else {
				Statuses["Input"] = fmt.Sprintf("%+v", ev.Ch) //"Processing"
				//debugStr = fmt.Sprintf("key: %v, %v, %v", ev.Key, ev.Ch, ev)
				switch ev.Key {
				case 4:
					if InputLine == "" {
						shutdown()
					}
				case termbox.KeyTab:
					CallKeyHook("TAB")
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
					InputPos++
					if InputPos > len(InputLine) {
						InputPos = len(InputLine)
					}
				case termbox.KeyArrowLeft:
					InputPos--
					if InputPos < 0 {
						InputPos = 0
					}

				case termbox.KeyArrowDown:
					if len(History) > 0 {
						selection--
						if selection < 0 {
							selection = len(History) - 1

						}
						InputLine = History[selection]
						InputPos = 0
						Statuses["selection"] = fmt.Sprintf("%v", selection)
					}
					focus = "input"
					refreshTerm()

				case termbox.KeyArrowUp:
					if len(History) > 0 {
						selection++
						if selection >= len(History) {
							selection = 0

						}
						InputLine = History[selection]
						InputPos = 0
						Statuses["selection"] = fmt.Sprintf("%v", selection)
					}
					focus = "input"
					refreshTerm()

				case termbox.KeyEsc:
					//FIXME need a thread local check to see if we are in a prompt
					//or if a sub-process is running
					//Only quit if we are definitely in a prompt
					//shutdown()
				case termbox.KeyBackspace, termbox.KeyBackspace2:
					if len(InputLine) > 0 && InputPos > 0 {
						before := InputLine[:InputPos-1]
						after := InputLine[InputPos:]
						InputLine = fmt.Sprintf("%s%s", before, after)

						cursorX = len(prompt) + len(InputLine)
						InputPos -= 1
					}

					focus = "input"
					refreshTerm()
				case termbox.KeyEnter:
					blankPanel()
					completeVersion = completeVersion + 1
				default:
					//statuses["Input"] = ev.Key
					before := InputLine[:InputPos]
					after := InputLine[InputPos:]
					//WTF windows?
					if ev.Ch == 0 {
						ev.Ch = 32
					}
					InputLine = fmt.Sprintf("%s%c%s", before, ev.Ch, after)
					InputPos += 1
					cursorX = len(prompt) + len(InputLine)
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
			//log.Println("Exiting automatic refresh")
			return
		}
		refreshTerm()
		time.Sleep(time.Millisecond * 200)
	}
}

func automaticdoInput(threadVer int) {
	for i := 0; i < 1; i = 0 {
		if threadVer < completeVersion {
			//log.Println("Exiting automatic doInput")
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
	Statuses["Status"] = "Shutting down"
	use_gui = false
	os.Exit(0)

}

func Init(configPath string) {
	confPath = configPath
	log.Printf("Reading config from: %v", confPath)
	confJson, _ := ioutil.ReadFile(confPath)
	err := json.Unmarshal(confJson, &conf)
	if err != nil {
		log.Printf("Error reading config file %v: %v", confPath, err)
	}
	History = conf.History
	LineCache = map[string]string{}
	InputLine = ""

	refreshMutex = sync.Mutex{}
	predictResults = []string{}
	Statuses = map[string]string{}
	completeVersion = completeVersion + 1
	termbox.Init()
	termbox.SetInputMode(termbox.InputEsc)
}
func ReadLine() string {
	completeVersion = completeVersion + 1
	InputLine = ""
	InputPos = 0

	//termbox.SetInputMode(termbox.InputAlt)
	//defer termbox.Close()
	use_gui = true
	defer func() { use_gui = false }()
	setTrans()
	go automaticRefreshTerm(completeVersion)
	go automaticdoInput(completeVersion)

	threadVer := completeVersion
	for threadVer == completeVersion {
		time.Sleep(10 * time.Millisecond)
	}
	use_gui = false
	if len(History) > 0 {
		if History[0] != InputLine {
			History = append([]string{InputLine}, History...)
		}
	} else {
		History = append([]string{InputLine}, History...)
	}

	Statuses["history"] = fmt.Sprintf("%v", History)
	conf.History = History
	confJson, err := json.Marshal(conf)
	if err != nil {
		log.Println("Error marshalling config file", err)
	} else {
		os.Mkdir(filepath.Dir(confPath), 0777)
		ioutil.WriteFile(confPath, confJson, 0644)
	}
	return InputLine
}

/*
func main() {
	fmt.Println(ReadLine())
}
*/
