package main

import (
    "github.com/icza/gowut/gwu"
    "strconv"
	"github.com/russross/blackfriday"
	"io/ioutil"
	"fmt"
	"os"
)

var  wikiText string
var  fileName string
var tb gwu.TextBox
var html gwu.Html

type MyButtonHandler struct {
    counter int
    text    string
}
type MyButtonHandler2 struct {
    counter int
    text    string
}

func (h *MyButtonHandler) HandleEvent(e gwu.Event) {
    if _, isButton := e.Src().(gwu.Button); isButton {
        ioutil.WriteFile(
			fmt.Sprintf("wikiPages/%s", fileName), 
			[]byte(wikiText), os.FileMode(os.O_WRONLY|os.O_CREATE|os.O_TRUNC|0777))
    }
}

func (h *MyButtonHandler2) HandleEvent(e gwu.Event) {
    if _, isButton := e.Src().(gwu.Button); isButton {
			fmt.Println("Loading... ", h.text)
			fileName = h.text
			LoadFile(h.text)
			tb.SetText(wikiText)
			html.SetHtml(string(blackfriday.MarkdownCommon([]byte(tb.Text()))))
			e.MarkDirty(tb)
			e.MarkDirty(html)
    }
}


func LoadFile ( fname string ) {
	wikifile, err := ioutil.ReadFile(fmt.Sprintf("wikiPages/%s",fname))
	wikiText = string(wikifile)
	if err!=nil { fmt.Printf("Couldn't load file: %v\n" , err)}

}

func main() {
	
	os.Mkdir("wikiPages",os.FileMode(os.ModeDir|0777))
	LoadFile("wikiFile.txt")
	fileName = "wikiFile.txt"
    // Create and build a window
    win := gwu.NewWindow("main", "AlfaWiki")
    win.Style().SetFullWidth()
    win.SetHAlign(gwu.HA_CENTER)
    win.SetCellPadding(2)
    
    
  btn := gwu.NewButton("Save")
    
    win.Add(btn)
    // ListBox examples
    p := gwu.NewHorizontalPanel()
    p.Style().SetBorder2(1, gwu.BRD_STYLE_SOLID, gwu.CLR_BLACK)
    p.SetCellPadding(2)
    
    
    // TextBox with echo
    p = gwu.NewHorizontalPanel()
	win.Add(p)
    
	q := gwu.NewHorizontalPanel()
	win.Add(q)
	
	html = gwu.NewHtml("")
	p.Add(html)
	
	
    tb = gwu.NewTextBox(string(wikiText))
	tb.SetRows(24)
	tb.SetCols(80)
    tb.AddSyncOnETypes(gwu.ETYPE_KEY_UP)
	btn.AddEHandler(&MyButtonHandler{text: ":-)"}, gwu.ETYPE_CLICK)
    q.Add(tb)
	
	
    
    tb.AddEHandlerFunc(func(e gwu.Event) {
    		wikiText = tb.Text()
		html.SetHtml(string(blackfriday.MarkdownCommon([]byte(tb.Text()))))
		e.MarkDirty(html)
    }, gwu.ETYPE_CHANGE, gwu.ETYPE_KEY_UP)
    
        p.AddVSpace(20)
        p.Add(gwu.NewLabel("Panel with vertical layout:"))
        v := gwu.NewVerticalPanel()
        p.Add(v)
	files, _ := ioutil.ReadDir("wikiPages") 
        for i,f := range files {
                b:= gwu.NewButton(f.Name() + " " + strconv.Itoa(i))
		b.AddEHandler(&MyButtonHandler2{text: f.Name()}, gwu.ETYPE_CLICK)
                v.Add(b)
        }

        p.AddVSpace(20)


    // Create and start a GUI server (omitting error check)
server := gwu.NewServer("guitest", "localhost:8081")
    server.SetText("Test GUI App")
    server.AddWin(win)
	
	server.Start("") // Also opens windows list in browser
	
	for {
		
	}
    
}
