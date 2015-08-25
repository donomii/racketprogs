package main

import (
    "github.com/icza/gowut/gwu"
    //"strconv"
	"github.com/russross/blackfriday"
	"io/ioutil"
	"fmt"
	"os"
)

var  wikiText string

type MyButtonHandler struct {
    counter int
    text    string
}

func (h *MyButtonHandler) HandleEvent(e gwu.Event) {
    if _, isButton := e.Src().(gwu.Button); isButton {
        ioutil.WriteFile(
			"wikiPages/wikiFile.txt", 
			[]byte(wikiText), os.FileMode(os.O_WRONLY|os.O_CREATE|os.O_TRUNC|0777))
    }
}

func main() {
	
	os.Mkdir("wikiPages",os.FileMode(os.ModeDir|0777))
	wikifile, err := ioutil.ReadFile("wikiPages/wikiFile.txt")
	wikiText = string(wikifile)
	if err!=nil { fmt.Printf("Couldn't load file: %v\n" , err)}
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
	
	h := gwu.NewHtml("")
	p.Add(h)
	
	
    tb := gwu.NewTextBox(string(wikifile))
	tb.SetRows(24)
	tb.SetCols(80)
    tb.AddSyncOnETypes(gwu.ETYPE_KEY_UP)
	btn.AddEHandler(&MyButtonHandler{text: ":-)"}, gwu.ETYPE_CLICK)
    q.Add(tb)
	
	
    
    tb.AddEHandlerFunc(func(e gwu.Event) {
    wikiText = tb.Text()
		h.SetHtml(string(blackfriday.MarkdownCommon([]byte(tb.Text()))))
    
		e.MarkDirty(h)
    }, gwu.ETYPE_CHANGE, gwu.ETYPE_KEY_UP)
    
    
	
	
	


    // Create and start a GUI server (omitting error check)
server := gwu.NewServer("guitest", "localhost:8081")
    server.SetText("Test GUI App")
    server.AddWin(win)
	
	server.Start("") // Also opens windows list in browser
	
	for {
		
	}
    
}