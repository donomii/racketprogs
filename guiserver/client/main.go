package main

// Make a gui layout module

import (
	"fmt"
	"io/ioutil"
	"log"
	"runtime"

	//"math/rand"

	"github.com/donomii/goof"
	"github.com/veandco/go-sdl2/sdl"
	"github.com/veandco/go-sdl2/ttf"
)

type Box struct {
	Text        string
	Type        string
	Id          string
	X, Y, W, H  int
	SplitLayout string
	SplitRatio  float64
	Children    []*Box
	Callback    func(*Box, *Box, string, int, int)
}

var (
	top   *Box
	boxes map[string]*Box
	scale float64 = 0.5
)

var (
	surface  *sdl.Surface
	renderer sdl.Renderer
	window   sdl.Window
	font     *ttf.Font
	text     *sdl.Surface
)

const (
	fontPath = "test.ttf"
	fontSize = 12
)

func Add(b *Box, child *Box) {
	b.Children = append(b.Children, child)
}

func Remove(b *Box, id string) {
	for i, child := range b.Children {
		if child.Id == id {
			b.Children = append(b.Children[:i], b.Children[i+1:]...)
			return
		}
	}
}

func Get(b *Box, id string) *Box {
	if b.Id == id {
		return b
	}
	for _, child := range b.Children {
		res := Get(child, id)
		if res != nil {
			return res
		}
	}
	return nil
}

var testbox *Box = &Box{
	Text:        "TestWindow",
	Type:        "window",
	Id:          "testbox",
	X:           50,
	Y:           50,
	W:           300,
	H:           300,
	SplitLayout: "horizontal",
	SplitRatio:  0.5,
	Children: []*Box{
		{
			Id: "testbox_child1",
		},
		{
			Id: "testbox_child2",
		},
	},
}

type txtcall struct {
	X, Y float64
	Str  string
	Size float64
}

var (
	testlist []*Box
	TextList []txtcall
)

func Text(x, y float64, str string, size float64) {
	TextList = append(TextList, txtcall{x, y, str, size})
}

func drawText(x, y float64, str string, size float64) {
	// Load the font for our text
	var err error
	//if font, err = ttf.OpenFont("test.ttf", int(size)); err != nil {
	//	return
	//}
	//defer font.Close()
	// Create a red text with the font
	if text, err = font.RenderUTF8Blended(str, sdl.Color{R: 0, G: 255, B: 255, A: 255}); err != nil {
		return
	}
	defer text.Free()

	// Draw the text around the center of the window
	if err = text.Blit(nil, surface, &sdl.Rect{X: int32(x), Y: int32(y), W: 0, H: 0}); err != nil {
		return
	}

	// Update the window surface with what we have drawn
	// window.UpdateSurface()
}

func Render(b *Box, parent *Box, hoverX, hoverY, offsetX, offsetY int) []string {
	hoverTarget := []string{}

	ch := b.Children
	Text(scale*float64(b.X+offsetX), scale*float64(b.Y+offsetY), b.Text, scale*18)

	if b.Id != "" && hoverX >= int(scale*float64(b.X+offsetX)) && hoverX <= int(scale*float64(b.X+offsetX+b.W)) && hoverY >= int(scale*float64(b.Y+offsetY)) && hoverY <= int(scale*float64(b.Y+offsetY+b.H)) {
		hoverTarget = []string{b.Id}
	}

	if ch != nil && len(ch) > 0 {
		switch b.SplitLayout {
		case "horizontal":
			ch[0].X = b.X + offsetX
			ch[0].Y = b.Y + offsetY
			ch[0].W = int(float64(b.W) * b.SplitRatio)
			ch[0].H = b.H
			ch[1].X = ch[0].X + offsetX + ch[0].W
			ch[1].Y = b.Y + offsetY
			ch[1].W = b.W - ch[0].W
			ch[1].H = b.H
		case "vertical":
			ch[0].X = b.X + offsetX
			ch[0].Y = b.Y + offsetY
			ch[0].W = b.W
			ch[0].H = int(float64(b.H) * b.SplitRatio)
			ch[1].X = b.X + offsetX
			ch[1].Y = ch[0].Y + offsetY + ch[0].H
			ch[1].W = b.W
			ch[1].H = b.H - ch[0].H
		default:
			panic("invalid split layout" + b.SplitLayout)

		}
	}

	drawBox(scale*float64(b.X+offsetX), scale*float64(b.Y+offsetY), scale*float64(b.W), scale*float64(b.H), 0x99990000)
	for _, child := range b.Children {
		res := Render(child, b, hoverX, hoverY, b.X+offsetX, b.Y+offsetY)

		hoverTarget = append(hoverTarget, res...)

	}
	return hoverTarget
}

var (
	lastPress                    bool
	dragItem                     string
	clickTarget                  string
	dragStartX, dragStartY       int
	ItemPosStartX, ItemPosStartY int
)

func MoveToEnd(id string, boxes []*Box) {
	for i, b := range boxes {
		if b.Id == id {
			boxes = append(boxes[:i], boxes[i+1:]...)
			boxes = append(boxes, b)
			return
		}
	}
}

func RenderAll(x, y int) []string {
	hoverTarget := []string{}
	for _, b := range top.Children {
		targets := Render(b, nil, x, y, top.X, top.Y)
		if len(targets) > 0 && targets[0] != dragItem {
			hoverTarget = targets
		}
	}
	return hoverTarget
}

func draw(mouseX, mouseY int, action string) {
	fmt.Printf("mscrx mscry %v,%v %v\n", mouseX, mouseY, action)
	/*if scrollY > 1.0 {
		scrollY = 1.0
	}
	if scrollY < -1.0 {
		scrollY = -1.0
	}*/

	hoverTarget := RenderAll(mouseX, mouseY)
	if len(hoverTarget) > 0 {
		fmt.Printf("hover %v\n", hoverTarget[0])
	}

	switch action {
	case "press":
		fmt.Printf("Pressed at %v,%v\n", mouseX, mouseY)
		dragStartX = int(mouseX)
		dragStartY = int(mouseY)

		dragItem = top.Id
		if len(hoverTarget) > 0 {
			dragItem = hoverTarget[0]
			clickTarget = hoverTarget[len(hoverTarget)-1]
			MoveToEnd(dragItem, top.Children)
		}
		dragItemBox := boxes[dragItem]
		ItemPosStartX = dragItemBox.X
		ItemPosStartY = dragItemBox.Y

	case "release":
		fmt.Printf("Released at %v,%v\n", mouseX, mouseY)
		if goof.AbsInt(mouseX-dragStartX) > 5 || goof.AbsInt(mouseY-dragStartY) > 5 {
			fmt.Printf("Dragged from %v,%v to %v,%v\n", dragStartX, dragStartY, mouseX, mouseY)
			if len(hoverTarget) > 0 {
				ht := hoverTarget[0]
				fmt.Println("Dropping over:", ht)

				if dragItem != top.Id {
					hoverTargetBox := boxes[ht]
					dragItemBox := boxes[dragItem]
					if hoverTargetBox != nil {
						box := Get(hoverTargetBox, ht)
						fmt.Printf("Found box: %+v\n", box)
						if box != nil && box.Callback != nil {
							box.Callback(dragItemBox, hoverTargetBox, "drop", mouseX, mouseY)
						}
					}
				}
			}

		} else {
			fmt.Printf("Clicked at %v,%v\n", mouseX, mouseY)
			if len(hoverTarget) > 0 {
				ht := hoverTarget[0]
				fmt.Println("Hovering over:", ht)

				activeBox := boxes[ht]
				if activeBox != nil {
					box := Get(activeBox, clickTarget)
					if box != nil && box.Callback != nil {
						box.Callback(activeBox, nil, "click", mouseX, mouseY)
					}
				}
			}
		}
		dragItem = ""
		clickTarget = ""
	case "wheel":
		fmt.Printf("Wheel at %v,%v\n", mouseX, mouseY)
		scale = scale + float64(mouseY)/100.0
	default:
		if dragItem != "" {
			fmt.Printf("Dragging %v to %v,%v\n", dragItem, mouseX, mouseY)
			if len(hoverTarget) > 0 {
				fmt.Println("Hovering over:", hoverTarget[0])
			}
			dragBox := boxes[dragItem]
			if dragBox != nil {
				// box := Get(dragBox, dragItem)
				// if box != nil {
				dragBox.X = ItemPosStartX + int(float64(int(mouseX)-dragStartX)/scale)
				dragBox.Y = ItemPosStartY + int(float64(int(mouseY)-dragStartY)/scale)
				//}
			}

		}
	}
}

func drawBox(x, y, w, h float64, color uint32) {
	rect := sdl.Rect{int32(x), int32(y), int32(w), int32(h)}
	surface.FillRect(&rect, color)
}

func init() {
	runtime.LockOSThread()
}

func main() {
	testlist = []*Box{}
	boxes = map[string]*Box{}

	// Load entire file main.go into var
	data, err := ioutil.ReadFile("main.go")
	if err != nil {
		log.Fatal(err)
	}
	// Convert to string
	source := string(data)
	// Parse source into AST
	ast := ParseGo(source, "main.go")
	// Print AST
	BoxTree(ast, 0, true)

	// Generate 20 random testboxes

	// dump boxes
	for k, v := range boxes {
		fmt.Println(k, v)
	}
	top = &Box{
		Text:        "TestWindow",
		Type:        "top",
		Id:          "top_test_1",
		X:           0,
		Y:           0,
		W:           400,
		H:           400,
		SplitLayout: "",
		SplitRatio:  0.5,
		Children:    testlist,
	}
	boxes[top.Id] = top

	if err = ttf.Init(); err != nil {
		return
	}
	defer ttf.Quit()

	if err := sdl.Init(sdl.INIT_EVERYTHING); err != nil {
		panic(err)
	}
	defer sdl.Quit()

	window, err := sdl.CreateWindow("test", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED,
		800, 600, sdl.WINDOW_SHOWN)
	if err != nil {
		panic(err)
	}
	defer window.Destroy()

	surface, err = window.GetSurface()
	if err != nil {
		panic(err)
	}

	// Load the font for our text
	if font, err = ttf.OpenFont(fontPath, fontSize); err != nil {
		return
	}
	defer font.Close()

	surface.FillRect(nil, 0)
	TextList = []txtcall{}
	running := true
	var mouseX, mouseY int = 0, 0
	var action string
	var updateNeeded bool = true
	for running {
		if updateNeeded {
			surface.FillRect(nil, 0)
			draw(mouseX, mouseY, action)
			for _, v := range TextList {
				drawText(v.X, v.Y, v.Str, v.Size)
			}
			TextList = []txtcall{}
			updateNeeded = false
		}
		action = ""

		// drawBox(0, 0, 200, 200, 0xffff0000)
		// rect := sdl.Rect{0, 0, 200, 200}
		// surface.FillRect(&rect, 0xffff0000)
		window.UpdateSurface()
		for event := sdl.PollEvent(); event != nil; event = sdl.PollEvent() {
			updateNeeded = true
			switch t := event.(type) {
			case *sdl.QuitEvent:
				println("Quit")
				running = false
				break
			case *sdl.MouseMotionEvent:
				mouseX = int(t.X)
				mouseY = int(t.Y)

				// fmt.Println("Mouse", t.Which, "moved by", t.XRel, t.YRel, "at", t.X, t.Y)
			case *sdl.MouseButtonEvent:
				mouseX = int(t.X)
				mouseY = int(t.Y)

				if t.State == sdl.PRESSED {
					action = "press"
					// fmt.Println("Mouse", t.Which, "button", t.Button, "pressed at", t.X, t.Y)
				} else {
					action = "release"
					// fmt.Println("Mouse", t.Which, "button", t.Button, "released at", t.X, t.Y)
				}
			case *sdl.MouseWheelEvent:
				mouseX = int(t.X)
				mouseY = int(t.Y)
				action = "wheel"
				if t.X != 0 {
					// fmt.Println("Mouse", t.Which, "wheel scrolled horizontally by", t.X)
				} else {
					// fmt.Println("Mouse", t.Which, "wheel scrolled vertically by", t.Y)
				}
			}
		}
	}
}

var (
	id               int
	cursorX, cursorY int = 0, 50
)

func AddBox(text string) {
	b := &Box{
		Id:   fmt.Sprintf("testbox_%v", id),
		Text: text,
		X:    cursorX,
		Y:    cursorY,
		W:    100,
		H:    100,
		Callback: func(from, to *Box, event string, x, y int) {
			fmt.Printf("%v at %v,%v from %v, to %v\n", event, x, y, from.Id, to.Id)
		},
	}
	id = id + 1
	cursorX = cursorX + 100
	boxes[b.Id] = b

	testlist = append(testlist, b)
}

// lalala))) ululu
func BoxTree(t []Node, indent int, newlines bool) {
	for _, v := range t {
		if v.List == nil {
			if v.Str == "" {
				// fmt.Print(".")
				AddBox(v.Raw + " ")
			} else {
				AddBox("『" + v.Str + "』")
			}
		} else {
			if len(v.List) == 0 && (v.Note == "\n" || v.Note == "artifact") {
				cursorY = cursorY + 100
				cursorX = indent * 100
				continue
			}
			// If the current expression contains 3 or more sub expressions, break it across lines
			if containsLists(v.List, 3) {
				if countTree(v.List) > 50 {

					cursorY = cursorY + 100
					cursorX = (indent + 1) * 100
				}
				AddBox("(")

				BoxTree(v.List, indent+2, true)
				cursorY = cursorY + 100
				cursorX = indent * 100
				AddBox(")")
			} else {
				AddBox("(")
				// fmt.Print(v.Note, "current length: ",len(v.List))
				BoxTree(v.List, indent+2, false)
				AddBox(")")

			}
		}
		if newlines {
			cursorY = cursorY + 100
			cursorX = indent * 100

		}
	}
}
