//go:build !sdl
// +build !sdl

package main

import (
	"fmt"

	. "../../autoparser"
)

type Box struct {
	Text          string
	Type          string
	Id            string
	X, Y, W, H    int
	SplitLayout   string
	SplitRatio    float64
	Children      []*Box
	Callback      func(*Box, *Box, string, int, int)
	AstNode       *Node
	DrawOrderList []*Box
	Scale float64
}

// Add a child to a parent box.  The child box  will be drawn after the parent box is drawn.
func Add(b *Box, x,y int, child *Box) {
	b.Children = append(b.Children, child)
	b.DrawOrderList = append(b.DrawOrderList, child)
	boxes[b.Id] = b //  For quick lookups by id
}

// Creates a box and adds it to the given parent
func AddBox(parent *Box,x,y int, text string, n *Node)int {
	size:=int(36 *scale)
	l := len(text)
	b := &Box{
		Id:   fmt.Sprintf("testbox_%v", id),
		Text: text,
		X:    x,
		Y:    y,
		W:    l*size,
		H:    100,
		Scale: 1.0,
		Callback: func(from, to *Box, event string, x, y int) {
			if from != nil && to != nil {
				fmt.Printf("%v at %v,%v from %v, to %v\n", event, x, y, from.Id, to.Id)
			}
		},
		AstNode: n,
	}
	id = id + 1
	cursorX = cursorX + l*size
	boxes[b.Id] = b
	parent.Children = append(parent.Children, b)
	return l*size
}

// Takes an AST from autoparser and creates a box tree from it
func BoxTree(b *Box,  x,y int,t []Node, indent int, newlines bool) (int,int){
	ox:=x
	oy := y
	for _, v := range t {
		
		if v.List == nil {
			dx := 0
			if v.Str == "" {
				// fmt.Print(".")
				dx=AddBox(b, x,y, v.Raw+" ", &v)
			} else {
				dx=AddBox(b, x,y,"『"+v.Str+"』", &v)
			}
			x=x+dx
		} else {
			if len(v.List) == 0 && (v.Note == "\n" || v.Note == "artifact") {
				y=y+ 100
				x = x+ 100
				continue
			}
			// If the current expression contains 3 or more sub expressions, break it across lines
			if ContainsLists(v.List, 3) {
				if CountTree(v.List) > 50 {

					y=y + 100
					x = (indent + 1) * 100
				}
				n := &Box{SplitLayout: "free", AstNode: &v, Scale:1}
				Add(b,x,y, n)
				// AddBox(n, "(", v)

				_, dy := BoxTree(n,x,y, v.List, indent+2, true)
				y=y + 100+ dy
				x = x+ 100
				// AddBox(n, ")", v)
			} else {
				n := &Box{SplitLayout: "free", AstNode: &v, Scale:1}
				Add(b, x,y,n)
				// AddBox(n, "(", v)
				// fmt.Print(v.Note, "current length: ",len(v.List))
				_,dy := BoxTree(n,x,y, v.List, indent+2, false)
				y=y + dy
				// AddBox(n, ")", v)

			}
		}
		if newlines {
			y=y + 100

		}
	}
	return x-ox,y-oy
}

// Finds id in an array of boxes, and moves it to the end of the array
func MoveToEnd(id string, boxes []*Box) {
	for i, b := range boxes {
		if b.Id == id {
			boxes = append(boxes[:i], boxes[i+1:]...)
			boxes = append(boxes, b)
			return
		}
	}
}

// Recursively searches through box and all children and returns the first box with the given id
func SearchChildTrees(b *Box, id string) *Box {
	if b.Id == id {
		return b
	}
	for _, child := range b.Children {
		res := SearchChildTrees(child, id)
		if res != nil {
			return res
		}
	}
	return nil
}

// Searches the child list for a box with the given id and removes it.  Not recursive.
func RemoveChild(b *Box, id string) {
	for i, child := range b.Children {
		if child.Id == id {
			b.Children = append(b.Children[:i], b.Children[i+1:]...)
			return
		}
	}
}
