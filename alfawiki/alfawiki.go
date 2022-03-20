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
var newPageBox gwu.TextBox

type MyButtonHandler struct {
    counter int
    text    string
}
type MyButtonHandler2 struct {
    counter int
    text    string
}

type NewPageHandler struct {
    counter int
    text    string
}

func (h *NewPageHandler) HandleEvent(e gwu.Event) {
    if _, isButton := e.Src().(gwu.Button); isButton {
	fmt.Printf ("NewPage: %s\n",newPageBox.Text())
        ioutil.WriteFile(
			fmt.Sprintf("wikiPages/%s", newPageBox.Text()), 
			[]byte{}, os.FileMode(os.O_WRONLY|os.O_CREATE|os.O_EXCL|0777))
	
  }
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
			html.SetHtml(fmt.Sprintf("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM%v",string(blackfriday.MarkdownCommon([]byte(tb.Text())))))
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
    //win.Style().SetFullWidth()
    win.SetHAlign(gwu.HA_CENTER)
    win.SetCellPadding(2)
    
    
    p := gwu.NewHorizontalPanel()
    //p.Style().SetBorder2(1, gwu.BRD_STYLE_SOLID, gwu.CLR_BLACK)
    p.SetCellPadding(2)
    
    
    p = gwu.NewHorizontalPanel()
	//p.Style().Set("width","100%")
	//p.Style().SetFullHeight()
	win.Add(p)
    

	html = gwu.NewHtml(fmt.Sprintf("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM%v",string(blackfriday.MarkdownCommon([]byte(wikiText)))))
	html.Style().Set("width","40%")
	html.Style().Set("min-width","40%")
	html.Style().Set("word-break","break-all")
	
	
    	tb = gwu.NewTextBox(wikiText)
	tb.SetRows(50)
	tb.SetCols(80)
	//tb.Style().Set("width","100%")
	//tb.Style().Set("min-width","20em")
    	tb.AddSyncOnETypes(gwu.ETYPE_KEY_UP)
    	p.Add(tb)
	p.Add(html)


        v := gwu.NewPanel()
	//v.Style().SetFullHeight().SetBorderRight2(2, gwu.BRD_STYLE_SOLID, "#777777")
	//v.Style().Set("width","20%")
        p.Add(v)
	
	
    
    tb.AddEHandlerFunc(func(e gwu.Event) {
    		wikiText = tb.Text()
		html.SetHtml(fmt.Sprintf("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM%v",string(blackfriday.MarkdownCommon([]byte(tb.Text())))))
		e.MarkDirty(html)
        	ioutil.WriteFile(
			fmt.Sprintf("wikiPages/%s", fileName), 
			[]byte(wikiText), os.FileMode(os.O_WRONLY|os.O_CREATE|os.O_TRUNC|0777))
    }, gwu.ETYPE_CHANGE, gwu.ETYPE_KEY_UP)
    
    	newPageBox = gwu.NewTextBox("New Page Name")
	newPageBox.SetRows(1)
	newPageBox.SetCols(20)
        v.Add(newPageBox)

        newPageButt:= gwu.NewButton("New Page")
	newPageButt.AddEHandler(&NewPageHandler{text: "Not used"}, gwu.ETYPE_CLICK)
        v.Add(newPageButt)
        v.AddVSpace(20)

	files, _ := ioutil.ReadDir("wikiPages") 
        for i,f := range files {
                b:= gwu.NewButton(f.Name() + " " + strconv.Itoa(i))
		b.AddEHandler(&MyButtonHandler2{text: f.Name()}, gwu.ETYPE_CLICK)
                v.Add(b)
        }

        v.AddVSpace(1000)


    // Create and start a GUI server (omitting error check)
server := gwu.NewServer("guitest", "localhost:8081")
    server.SetText("AlfaWiki")
win.SetTheme("debug")
win.AddHeadHtml(`<link rel="stylesheet" type="text/css" href="/mystyle.css">`)
    server.AddWin(win)
	
	server.Start("main") // Also opens windows list in browser
	
	for {
		
	}
    
}
