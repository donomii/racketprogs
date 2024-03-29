// status.go
package main

import (
	//"log"
	"strings"

	"github.com/donomii/goof"

	//"strings"
	"bufio"
	"flag"
	"fmt"
	"io"
	"os"
	"runtime"
	"strconv"
	"time"

	//"sort"
	"net/rpc"

	"github.com/nsf/termbox-go"

	"sync"
)

var serverActive = false

var use_gui = true

var statuses map[string]string
var results []ResultRecordTransmittable

var selection = 0
var itempos = 0
var cursorX = 11
var cursorY = 1
var selectPosX = 11
var selectPosY = 1
var focus = "input"
var inputPos = 0
var searchStr string
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

type ResultRecordTransmittable struct {
	Filename    string
	Line        string
	Fingerprint []string
	Sample      string
	Score       string
}

//Contact server with search string
func search(searchTerm string, numResults int) []ResultRecordTransmittable {
	statuses["Status"] = "Searching"
	//log.Println("Searching for: ", searchTerm)

	var out []ResultRecordTransmittable
	terms := strings.Split(searchTerm, " ")

	grepStr := ""

	for _, t := range terms {
		if strings.HasSuffix(t, "-") {
			tt := strings.TrimSuffix(t, "-")
			grepStr = grepStr + " | grep -i -v " + tt
		} else {
			grepStr = grepStr + " | grep -i " + t
		}
	}

	if len(terms) > 0 && len(terms[0]) > 2 {
		cmd := []string{"/bin/sh", "-c", "csearch -i -n " + terms[0] + " " + grepStr + " | head -" + fmt.Sprintf("%v", numResults)}

		//log.Println(cmd)
		res := goof.QC(cmd)

		lines := strings.Split(res, "\n")

		for _, v := range lines {
			bits := strings.Split(v, ":")
			if len(bits) > 2 {
				out = append(out, ResultRecordTransmittable{Filename: bits[0], Line: bits[1], Sample: bits[2]})
			}
		}
	}

	delete(statuses, "Status")
	return out
}

var completeMatch = false

func isLinux() bool {
	return (runtime.GOOS == "linux")
}

func isDarwin() bool {
	return (runtime.GOOS == "darwin")
}

func refreshTerm() {
	if !serverActive {
		return
	}
	//statuses["Screen"] = "Refresh"
	if use_gui {
		refreshMutex.Lock()
		defer refreshMutex.Unlock()
		termbox.Clear(foreGround(), backGround())
		putStr(0, 0, debugStr)
		putStr(0, 1, fmt.Sprintf("Search for:%v", searchStr))
		_, height := termbox.Size()
		//prevRecord := ResultRecordTransmittable{"", -1, makeFingerprintFromData(""), "", 0}
		prevRecord := ResultRecordTransmittable{}
		dispLine := 2
		if len(results) > 0 {
			putStr(5, dispLine, fmt.Sprintf("%v (line %v)", results[0].Filename, results[0].Line))
			dispLine++
			prevRecord = results[0]
		}
		itempos = 0
		for i, elem := range results {
			if dispLine < height-4 {
				if !(i == 0) && !(elem.Filename == prevRecord.Filename) {
					putStr(3, dispLine, fmt.Sprintf("%v", elem.Filename))
					dispLine++
				}
				if itempos == selection {
					putStr(0, dispLine, "*")
					selectPosX = 0
					selectPosY = dispLine
				}
				//if elem.Line != "-1" && strings.HasPrefix(elem.Filename, "http") {
				putStr(1, dispLine, fmt.Sprintf("%v", elem.Score))
				l, _ := strconv.Atoi(elem.Line)
				LineStr, _, _ := FetchLine(elem.Filename, l)
				putStr(8, dispLine, fmt.Sprintf("(line %v) %v", elem.Line, LineStr))
				dispLine++
				itempos++
				prevRecord = elem
				//}
			}
		}
		putStr(1, height-3, fmt.Sprintf("%v results", len(results)))
		putStr(20, height-3, fmt.Sprintf("%v", statuses))
		putStr(1, height-2, fmt.Sprintf("Type your search terms, add a - to the end of word to remove that word (word-)"))
		putStr(1, height-1, fmt.Sprintf("Up/Down Arrows to select a result, Right Arrow to edit that file, Escape Quits"))
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
			termbox.SetCursor(11+inputPos, 1)
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
func doInput() {
	if !serverActive {
		return
	}

	if use_gui {
		//statuses["Input"] = "Waiting"
		_, height := termbox.Size()
		ev := termbox.PollEvent()
		if ev.Type == termbox.EventKey {
			if ev.Mod == termbox.ModAlt {
				switch ev.Key {
				case termbox.KeyArrowRight:
					inputPos = searchRight(searchStr, inputPos)
				case termbox.KeyArrowLeft:
					inputPos = searchLeft(searchStr, inputPos)
				}
			} else {
				//statuses["Input"] = fmt.Sprintf("%v", ev.Key) //"Processing"
				//debugStr = fmt.Sprintf("key: %v, %v, %v", ev.Key, ev.Ch, ev)
				switch ev.Key {
				case termbox.KeyArrowLeft:
				case termbox.KeyArrowRight:
					line, _ := strconv.ParseInt(results[selection].Line, 10, 0)
					if line < 0 {
						line = 0
					}
					if isLinux() || isDarwin() {
						termbox.Close()
						goof.QCI([]string{"vim", "+" + fmt.Sprintf("%v", line), results[selection].Filename})
						termbox.Init()
						refreshTerm()
					} else {
						refreshTerm()
					}
				case termbox.KeyArrowDown:
					selection++
					if selection > len(results) {
						selection = len(results)
					}
					focus = "selection"
				case termbox.KeyArrowUp:
					selection--
					if selection < 0 {
						selection = 0
					}
					focus = "selection"
				case termbox.KeyEsc:
					shutdown()
				case termbox.KeyBackspace, termbox.KeyBackspace2:
					if len(searchStr) > 0 {
						searchStr = searchStr[0 : len(searchStr)-1]
						inputPos -= 1
					}

					focus = "input"
					refreshTerm()
				case termbox.KeyEnter:

					results = search(searchStr, height)

					//sort.Sort(results) FIXME
					focus = "selection"
					refreshTerm()
				case termbox.KeySpace:
					searchStr = fmt.Sprintf("%s ", searchStr)
					inputPos += 1
					refreshTerm()

				default:
					//statuses["Input"] = ev.Key
					searchStr = fmt.Sprintf("%s%c", searchStr, ev.Ch)
					results = search(searchStr, height)
					//sort.Sort(results) FIXME
					inputPos += 1
					cursorX = 11 + len(searchStr)
					cursorY = 1
					focus = "input"
					refreshTerm()
				}
			}
		}
	}
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
func automaticRefreshTerm() {
	for i := 0; i < 1; i = 0 {
		refreshTerm()
		time.Sleep(time.Millisecond * 200)
		if !serverActive {
			statuses["Status"] = "Closed"
			return
		}
	}
}

func automaticdoInput() {
	for i := 0; i < 1; i = 0 {
		doInput()
		time.Sleep(20 * time.Millisecond)
		if !serverActive {
			statuses["Input"] = "Closed"
			return
		}
	}
}

//Clean up and exit
func shutdown() {
	//Shut down resources so the display thread doesn't panic when the display driver goes away first
	//When we get a file persistence layer, it will go here
	statuses["Status"] = "Shutting down"
	use_gui = false
	serverActive = false
	os.Exit(0)

}
func main() {
	LineCache = map[string]string{}
	flag.Parse()
	//terms := flag.Args()
	//if len(terms) < 1 {
	//	fmt.Println("Use: query.exe  < --completeMatch >  search terms")
	//}
	searchStr = ""

	refreshMutex = sync.Mutex{}
	predictResults = []string{}
	results = []ResultRecordTransmittable{}
	statuses = map[string]string{}

	termbox.Init()
	termbox.SetInputMode(termbox.InputEsc)
	//termbox.SetInputMode(termbox.InputAlt)
	defer termbox.Close()
	use_gui = true
	serverActive = true
	go automaticRefreshTerm()

	go automaticdoInput()

	for {
		time.Sleep(1 * time.Second)
	}

}
