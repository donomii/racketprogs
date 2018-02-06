// status.go
package main

import (
	"strings"
	"github.com/donomii/tagdb/tagbrowser"
	"runtime"
	"strconv"
	"io"
	"bufio"
	"flag"
	"fmt"
	"log"
	"net/rpc/jsonrpc"
	"os"
	"time"
	"net/rpc"
	"github.com/nsf/termbox-go"
	"sync"
)


var serverActive = false

var use_gui = true
var display_thread = true
var input_thread = true

var statuses map[string]string
var results []Entry

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
var spinner []string
var spinner_index = 0

var predictResults []string
var redrawNeeded bool = true
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

func ToLines (s string) []string {
	return strings.Split(s,"\n")
}

func shellLines (command []string) []string {
	ret := CacheLines(fmt.Sprintf("%v", command), func ()[]string{return ToLines(shellout(command))})
	//log.Println(ret)
	return ret
}

func environ(search string) []string {
	allvars := CacheLines("environment variables", func()[]string{return os.Environ()})
	return CacheLines("environment variable: "+search, func()[]string{return stringGrep(search, allvars)})
}

func stringGrep (needle string, haystack []string) []string {
	var matches []string
	for _, s := range haystack {
		if strings.Contains(strings.ToLower(s), strings.ToLower(needle)) {
			matches = append(matches, s)
		}
	}
	return matches

}

//Things we need in return struct:  short value, full value, description, source, launch command
type Entry struct {
	Name     	string			//A short name.  e.g. a filename, username, etc (around 20 chars)
	Value	 	string			//Usually the location of the thing.  e.g. a directory, a url (as long as you need)
	Description	string			//A user friendly description of the item. (around 80 chars)
	Source		string			//A useful-to-the-user description of where the item is located.  e.g. a directory name, a website name, name of the program that generated the item....
	Launch		[]string		//An array of strings, that are the command name and args.  There must be one string with the value XXXXXX, which will be replaced with the Value string
	Score		string
	Line		string
}

//Contact server with search string
func search(searchTerm string, numResults int) []Entry {
	statuses["Status"] = "Searching"

	ret := []Entry{}
	res := man(searchTerm)
	log.Println("Manpages: ", res)
	for _, a := range res {
			ret = append(ret, Entry{a, searchTerm, a, "Help page", []string{"man", "XXXXXX"}, "1", ""})
		}
	
	res = environ(searchTerm)
	log.Println("Environemnt: ", res)
	for _, a := range res {
			ret = append(ret, Entry{a, a, a, "Environment Variable", []string{"echo", "XXXXXX"}, "1", ""})
		}
	
	res = installedApps(searchTerm)
	log.Println("Installed Apps: ", res)
	for _, a := range res {
			ret = append(ret, Entry{a, a, a, "Applications", []string{"XXXXXX"}, "1", ""})
		}
	resE  := csearch(searchTerm)
	log.Println("CodeSearch: ", res)
	ret = append(ret, resE...)

	
	answer := default_directories(searchTerm)
	log.Println("Directories: ", answer)
	for _, a := range answer {
		ret = append(ret, Entry{a, a, a, "Local Drive", []string{"vim", "XXXXXX"}, "1", ""})
	}

	return ret
}

//Contact server request predictions
func predictString(searchTerm string) []string {
	statuses["Status"] = "Predicting"
	//log.Println("Predicting: ", searchTerm)

	args := &tagbrowser.Args{searchTerm, 10}
	preply := &tagbrowser.StringListReply{}
	err := client.Call("TagResponder.PredictString", args, preply)
	if err != nil {
		//log.Println("RPC error:", err)
		statuses["Status"] = fmt.Sprintf("RPC error:", err)
	} else {
		statuses["Status"] = "Predict complete"
	}
	return preply.C
}

func status() {
	log.Println("Checking tag database status")
	client, err := jsonrpc.Dial("tcp", tagbrowser.ServerAddress)

	if err != nil {
		log.Fatal("dialing:", err)
	}
	args := &tagbrowser.Args{"", 0}
	sreply := &tagbrowser.StatusReply{}
	//log.Println("Fetching status")
	err = client.Call("TagResponder.Status", args, sreply)
	//log.Println("Received status")
	if err != nil {
		log.Fatal("RPC error:", err)
	}
	fmt.Println("Status: ", *sreply)

	hreply := &tagbrowser.HistoReply{}
	log.Println("Fetching status")
	err = client.Call("TagResponder.HistoStatus", args, hreply)
	log.Println("Received status")
	if err != nil {
		log.Fatal("RPC error:", err)
	}
	fmt.Println("Status: ", hreply)
	fmt.Printf("0: %v\n1: %v\n2: %v\n3: %v\n4: %v\n5: %v\n6: %v\n7: %v\n8: %v\n", hreply.TagsToFilesHisto["0"], hreply.TagsToFilesHisto["1"], hreply.TagsToFilesHisto["2"], hreply.TagsToFilesHisto["3"], hreply.TagsToFilesHisto["4"], hreply.TagsToFilesHisto["5"], hreply.TagsToFilesHisto["6"], hreply.TagsToFilesHisto["7"], hreply.TagsToFilesHisto["8"])

	treply := &tagbrowser.TopTagsReply{}
	log.Println("Fetching status")
	err = client.Call("TagResponder.TopTagsStatus", args, treply)
	log.Println("Received status")
	if err != nil {
		log.Fatal("RPC error:", err)
	}
	fmt.Println("Status: ", *treply)

	log.Println("Check complete")
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
		//prevRecord := tagbrowser.ResultRecordTransmittable{"", -1, makeFingerprintFromData(""), "", 0}
		prevRecord := Entry{}
		dispLine := 2
		if len(results) > 0 {
			putStr(5, dispLine, fmt.Sprintf("%v (line %v)", results[0].Name, results[0].Value))
			dispLine++
			prevRecord = results[0]
		}
		itempos = 0
		for i, elem := range results {
			if dispLine < height-4 {
				if !(i == 0) && !(elem.Name == prevRecord.Name) {
					putStr(3, dispLine, fmt.Sprintf("%v", elem.Name))
					dispLine++
				}
				if itempos == selection {
					putStr(0, dispLine, "*")
					selectPosX = 0
					selectPosY = dispLine
				}
                /*if elem.Line != "-1" && strings.HasPrefix(elem.Name, "http") {
                    putStr(1, dispLine, fmt.Sprintf("%v", elem.Score))
                    l, _:= strconv.Atoi(elem.Line)
                    LineStr, _, _ := FetchLine(elem.Filename, l)
					*/
                    putStr(8, dispLine, fmt.Sprintf("%v",  elem.Description))
					
                    dispLine++
                    itempos++
                    prevRecord = elem
                //}
			}
		}
		putStr(1, height-3, fmt.Sprintf("%v results", len(results)))
		//putStr(20, height-3, fmt.Sprintf("%v", statuses))
		putStr(20, height-3, fmt.Sprintf("%v", spinner[spinner_index]))
		spinner_index += 1
		if spinner_index >= len(spinner) { spinner_index = 0 }
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
	if use_gui {
		//statuses["Input"] = "Waiting"
		//width, height := termbox.Size()
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
				case termbox.KeyArrowRight:
					line, _ := strconv.ParseInt(results[selection].Line, 10, 0)
					if line < 0 { line = 0 }
					if isLinux() || isDarwin()  {
						termbox.Close()
						tagbrowser.Launch(results[selection].Name, fmt.Sprintf("%v", line))
						termbox.Init()
						refreshTerm()
					} else {
						launcher := results[selection].Launch
						for i, _ := range launcher {
							if launcher[i] == "XXXXXX" {
								launcher[i] = results[selection].Value
							}
						}
						shellout(launcher)
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

					results = search(searchStr, 10)

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
					results = search(searchStr, 10)
					//sort.Sort(results) FIXME
					statuses["Working"] = "Predicting"
					predictResults = manPredict(extractWord(searchStr, inputPos+1))
					statuses["Working"] = "Done"
					inputPos += 1
					cursorX = 11 + len(searchStr)
					cursorY = 1
					focus = "input"
					refreshTerm()
				}
				redrawNeeded = true
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

//Redraw screen every 10 Milliseconds
func automaticRefreshTerm() {
	for use_gui {
		if redrawNeeded {
			refreshTerm()
			redrawNeeded = false
		} else {
			time.Sleep(time.Millisecond * 1)
		}
	}
	display_thread = false
}

func automaticdoInput() {
	for use_gui {
		time.Sleep(1 * time.Millisecond)
		doInput()
	}
	input_thread = false
}

//Clean up and exit
func shutdown() {
	//Shut down resources so the display thread doesn't panic when the display driver goes away first
	statuses["Status"] = "Shutting down"
	use_gui = false
}
func main() {
    LineCache = map[string]string{}
    spinner = []string{"◜ ", " ◝", " ◞", "◟ "}
	flag.StringVar(&tagbrowser.ServerAddress, "server", tagbrowser.ServerAddress, fmt.Sprintf("Server IP and Port.  Default: %s", tagbrowser.ServerAddress))
	flag.Parse()
	//terms := flag.Args()
	//if len(terms) < 1 {
	//	fmt.Println("Use: query.exe  < --completeMatch >  search terms")
	//}
	searchStr = ""

	refreshMutex = sync.Mutex{}
	predictResults = []string{}
	results = []Entry{}
	statuses = map[string]string{}

	termbox.Init()
	defer termbox.Close()
	termbox.SetInputMode(termbox.InputEsc)
	termbox.SetOutputMode(termbox.OutputNormal)
	use_gui = true
	serverActive = true
	go automaticRefreshTerm()

	go automaticdoInput()

	for display_thread && input_thread {
		time.Sleep(1 * time.Second)
	}
	log.Println("clm finished")

}
