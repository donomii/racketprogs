package main

//Make a gui layout module

import (
	"fmt"
	"image/color"

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
	Callback    func(string, int, int)
}

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
		&Box{
			Id: "testbox_child1",
		},
		&Box{
			Id: "testbox_child2",
		},
	},
}

func Render(b *Box, parent *Box, hoverX, hoverY int) []string {
	hoverTarget := []string{}

	ch := b.Children
	p5.TextSize(18)
	p5.Text(b.Text, float64(b.X), float64(b.Y))
	if b.Id != "" && hoverX >= b.X && hoverX <= b.X+b.W && hoverY >= b.Y && hoverY <= b.Y+b.H {
		hoverTarget = []string{b.Id}
	}

	if ch != nil && len(ch) > 0 {
		switch b.SplitLayout {
		case "horizontal":
			ch[0].X = b.X
			ch[0].Y = b.Y
			ch[0].W = int(float64(b.W) * b.SplitRatio)
			ch[0].H = b.H
			ch[1].X = ch[0].X + ch[0].W
			ch[1].Y = b.Y
			ch[1].W = b.W - ch[0].W
			ch[1].H = b.H
		case "vertical":
			ch[0].X = b.X
			ch[0].Y = b.Y
			ch[0].W = b.W
			ch[0].H = int(float64(b.H) * b.SplitRatio)
			ch[1].X = b.X
			ch[1].Y = ch[0].Y + ch[0].H
			ch[1].W = b.W
			ch[1].H = b.H - ch[0].H
		default:
			panic("invalid split layout" + b.SplitLayout)

		}
	}

	p5.StrokeWidth(2)
	p5.Fill(color.RGBA{B: 255, A: 208})
	p5.Quad(float64(b.X), float64(b.Y), float64(b.X+b.W), float64(b.Y), float64(b.X+b.W), float64(b.Y+b.H), float64(b.X), float64(b.Y+b.H))
	for _, child := range b.Children {
		res := Render(child, b, hoverX, hoverY)

		hoverTarget = append(hoverTarget, res...)

	}
	return hoverTarget
}

func setup() {
	p5.Canvas(400, 400)
	p5.Background(color.Gray{Y: 220})
}

var lastPress bool
var dragTarget string
var clickTarget string
var dragStartX, dragStartY int

func draw() {
	mouseX := int(p5.Event.Mouse.Position.X)
	mouseY := int(p5.Event.Mouse.Position.Y)

	hoverTarget := Render(testbox, nil, int(p5.Event.Mouse.Position.X), int(p5.Event.Mouse.Position.Y))
	fmt.Println("Hovering over:", hoverTarget)
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
		if len(hoverTarget) > 0 {
			dragTarget = hoverTarget[0]
			clickTarget = hoverTarget[len(hoverTarget)-1]
			dragStartX = int(p5.Event.Mouse.Position.X)
			dragStartY = int(p5.Event.Mouse.Position.Y)
		}
	case "release":
		fmt.Printf("Released at %v,%v\n", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y)
		if goof.AbsInt(mouseX-dragStartX) > 5 || goof.AbsInt(mouseY-dragStartY) > 5 {
			fmt.Printf("Dragged from %v,%v to %v,%v\n", dragStartX, dragStartY, mouseX, mouseY)
			box := Get(testbox, dragTarget)
			if box != nil && box.Callback != nil {
				box.Callback("drop", mouseX, mouseY)
			}
		} else {
			fmt.Printf("Clicked at %v,%v\n", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y)
			box := Get(testbox, clickTarget)
			if box != nil && box.Callback != nil {
				box.Callback("click", mouseX, mouseY)
			}
		}
		dragTarget = ""
		clickTarget = ""
	default:
		if dragTarget != "" {
			fmt.Printf("Dragging %v to %v,%v\n", dragTarget, p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y)
			box := Get(testbox, dragTarget)
			if box != nil {
				box.X = int(p5.Event.Mouse.Position.X)
				box.Y = int(p5.Event.Mouse.Position.Y)
			}

		}

	}
}

func main() {

	p5.Run(setup, draw)
}
