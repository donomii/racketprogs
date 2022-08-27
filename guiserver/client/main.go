package main

// Make a gui layout module

import (
	"fmt"
	"io/ioutil"
	"log"
	"runtime"
	"runtime/debug"

	//"math/rand"

	"github.com/donomii/goof"
)

var (
	currentEditor  *GlobalConfig
	currentEditBox *Box
)

var (
	top   *Box
	boxes map[string]*Box
	scale float64 = 0.5
)

const (
	fontPath = "test.ttf"
	fontSize = 12
)

type txtcall struct {
	X, Y float64
	Str  string
	Size float64
}

var TextList []txtcall

// Make list of text to draw, defer drawing until box layer is finished
func Text(x, y float64, str string, size float64) {
	TextList = append(TextList, txtcall{x, y, str, size})
}

func Render(b *Box, parent *Box, hoverX, hoverY, offsetX, offsetY int) []string {
	hoverTarget := []string{}

	ch := b.Children

	if b.Id != "" && hoverX >= int(scale*float64(b.X+offsetX)) && hoverX <= int(scale*float64(b.X+offsetX+b.W)) && hoverY >= int(scale*float64(b.Y+offsetY)) && hoverY <= int(scale*float64(b.Y+offsetY+b.H)) {
		if b.Id != dragItem {
			hoverTarget = []string{b.Id}
		}
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
		case "free":
			// Arbitrary layout
		default:
			panic("invalid split layout" + b.SplitLayout)

		}
	}

	drawBox(scale*float64(b.X+offsetX), scale*float64(b.Y+offsetY), scale*float64(b.W), scale*float64(b.H), 0x99990000)
	drawText(scale*float64(b.X+offsetX), scale*float64(b.Y+offsetY), b.Text, scale*18)
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
	//fmt.Printf("mscrx mscry %v,%v %v\n", mouseX, mouseY, action)
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
			MoveToEnd(dragItem, top.DrawOrderList)
		}
		dragItemBox := boxes[dragItem]
		ItemPosStartX = dragItemBox.X
		ItemPosStartY = dragItemBox.Y

	case "release":
		fmt.Printf("Released at %v,%v\n", mouseX, mouseY, hoverTarget)
		// If the mouse has moved the minimum distance to not be a click
		if goof.AbsInt(mouseX-dragStartX) > 5 || goof.AbsInt(mouseY-dragStartY) > 5 {
			fmt.Printf("Dragged from %v,%v to %v,%v\n", dragStartX, dragStartY, mouseX, mouseY)
			// if it released over a box
			if len(hoverTarget) > 0 {
				ht := hoverTarget[0]
				fmt.Println("Dropping over:", ht)

				// Not released over the background
				if dragItem != top.Id {
					hoverTargetBox := boxes[ht]
					dragItemBox := boxes[dragItem]
					// If we were able to find the box we are dropping onto
					if hoverTargetBox != nil {
						box := SearchChildTrees(hoverTargetBox, ht)
						fmt.Printf("Found box: %+v\n", box)
						if box != nil && box.Callback != nil {
							box.Callback(dragItemBox, hoverTargetBox, "drop", mouseX, mouseY)
						}
					}
				}
			}

		} else {
			// It's a click
			fmt.Printf("Clicked at %v,%v %v\n", mouseX, mouseY, hoverTarget)
			if dragItem != "" {
				dragItemBox := boxes[dragItem]
				if dragItemBox != nil {

					// Start editing ht
					currentEditor = NewEditor()
					currentEditBox = dragItemBox
					ActiveBufferInsert(currentEditor, currentEditBox.Text)
					fmt.Printf("Now editing %v\n", dragItem)

				}
			}
			if len(hoverTarget) > 0 {
				ht := hoverTarget[0]
				fmt.Println("Hovering over:", ht)

				activeBox := boxes[ht]
				if activeBox != nil {

					box := SearchChildTrees(activeBox, clickTarget)
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

func init() {
	runtime.LockOSThread()
	fmt.Println("Locked to main thread")
	debug.SetGCPercent(-1)
	InitGraphics()
	currentEditor = NewEditor()
}

func main() {
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
	}
	top.AstNode = Node{List: ast}
	boxes[top.Id] = top
	BoxTree(top, ast, 0, true)

	MainGraphicsLoop()
}

var (
	id               int
	cursorX, cursorY int = 0, 50
)

func PrintBoxTree(t Box, indent int, newlines bool) {
	for _, z := range t.Children {
		if len(z.Children) == 0 {
			fmt.Println(z.Text)
		} else {

			fmt.Print("\n")
			printIndent(indent+1, "_")

			fmt.Print("(")

			PrintBoxTree(*z, indent+2, true)
			fmt.Printf("\n")
			printIndent(indent, "_")
			fmt.Print(")\n")

		}
	}
	fmt.Print("\n")
	printIndent(indent, "_")
	if newlines {
		fmt.Print("\n")
		printIndent(indent, "_")
	}
}
