package main

// Make a gui layout module

import (
	"fmt"
	"image/color"
	"io/ioutil"
	"log"

	//"math/rand"

	"github.com/donomii/goof"
	"github.com/go-p5/p5"
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

var testlist []*Box

func Render(b *Box, parent *Box, hoverX, hoverY, offsetX, offsetY int) []string {
	hoverTarget := []string{}

	ch := b.Children
	p5.TextSize(scale * 18)
	p5.Text(b.Text, scale*float64(b.X+offsetX), scale*float64(b.Y+offsetY))
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

	p5.StrokeWidth(2)
	p5.Fill(color.RGBA{B: 255, A: 208})
	p5.Quad(scale*float64(b.X+offsetX), scale*float64(b.Y+offsetY), scale*float64(b.X+offsetX+b.W), scale*float64(b.Y+offsetY), scale*float64(b.X+offsetX+b.W), scale*float64(b.Y+offsetY+b.H), scale*float64(b.X+offsetX), scale*float64(b.Y+offsetY+b.H))
	for _, child := range b.Children {
		res := Render(child, b, hoverX, hoverY, b.X+offsetX, b.Y+offsetY)

		hoverTarget = append(hoverTarget, res...)

	}
	return hoverTarget
}

func setup() {
	p5.Canvas(400, 400)
	p5.Background(color.Gray{Y: 220})
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

var scrollX, scrollY, lastScrollX, lastScrollY float64

func draw() {
	mouseX := int(p5.Event.Mouse.Position.X)
	mouseY := int(p5.Event.Mouse.Position.Y)

	scrollX = p5.Event.Mouse.Scroll.X - lastScrollX
	scrollY = p5.Event.Mouse.Scroll.Y - lastScrollY
	lastScrollX = p5.Event.Mouse.Scroll.X
	lastScrollY = p5.Event.Mouse.Scroll.Y

	fmt.Printf("mscrx mscry %v,%v scrollx scrolly %v %v\n", p5.Event.Mouse.Scroll.X, p5.Event.Mouse.Scroll.Y, scrollX, scrollY)
	/*if scrollY > 1.0 {
		scrollY = 1.0
	}
	if scrollY < -1.0 {
		scrollY = -1.0
	}*/

	if p5.Event.Mouse.Scroll.Y >= 0 {
		scale = 1.0 + p5.Event.Mouse.Scroll.Y/10.0
	} else {
		scale = 1.0 / 10.0 / goof.AbsFloat64(p5.Event.Mouse.Scroll.Y)
	}

	hoverTarget := RenderAll(int(p5.Event.Mouse.Position.X), int(p5.Event.Mouse.Position.Y))

	event := ""
	if !lastPress && p5.Event.Mouse.Pressed {
		event = "press"
		lastPress = true
	} else if lastPress && !p5.Event.Mouse.Pressed {
		event = "release"
		lastPress = false
	}
	switch event {
	case "press":
		fmt.Printf("Pressed at %v,%v\n", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y)
		dragStartX = int(p5.Event.Mouse.Position.X)
		dragStartY = int(p5.Event.Mouse.Position.Y)

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
		fmt.Printf("Released at %v,%v\n", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y)
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
			fmt.Printf("Clicked at %v,%v\n", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y)
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
	default:
		if dragItem != "" {
			fmt.Printf("Dragging %v to %v,%v\n", dragItem, p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y)
			if len(hoverTarget) > 0 {
				fmt.Println("Hovering over:", hoverTarget[0])
			}
			dragBox := boxes[dragItem]
			if dragBox != nil {
				// box := Get(dragBox, dragItem)
				// if box != nil {
				dragBox.X = ItemPosStartX + int(float64(int(p5.Event.Mouse.Position.X)-dragStartX)/scale)
				dragBox.Y = ItemPosStartY + int(float64(int(p5.Event.Mouse.Position.Y)-dragStartY)/scale)
				//}
			}

		}
	}
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

	p5.Run(setup, draw)
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
