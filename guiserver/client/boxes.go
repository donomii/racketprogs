package main

import (
	. "../../autoparser"
	"fmt"
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
	AstNode       Node
	DrawOrderList []*Box
}

// Add a child to a box.  The child will be drawn after the box is drawn.
func Add(b *Box, child *Box) {
	b.Children = append(b.Children, child)
	b.DrawOrderList = append(b.DrawOrderList, child)
	boxes[b.Id] = b //  For quick lookups by id
}

// Adds a box to the global box list
func AddBox(parent *Box, text string, n Node) {
	b := &Box{
		Id:   fmt.Sprintf("testbox_%v", id),
		Text: text,
		X:    cursorX,
		Y:    cursorY,
		W:    100,
		H:    100,
		Callback: func(from, to *Box, event string, x, y int) {
			if from != nil && to != nil {
				fmt.Printf("%v at %v,%v from %v, to %v\n", event, x, y, from.Id, to.Id)
			}
		},
		AstNode: n,
	}
	id = id + 1
	cursorX = cursorX + 100
	boxes[b.Id] = b
	parent.Children = append(parent.Children, b)
}

// Takes an AST from autoparser and creates a box tree from it
func BoxTree(b *Box, t []Node, indent int, newlines bool) {
	for _, v := range t {
		if v.List == nil {
			if v.Str == "" {
				// fmt.Print(".")
				AddBox(b, v.Raw+" ", v)
			} else {
				AddBox(b, "『"+v.Str+"』", v)
			}
		} else {
			if len(v.List) == 0 && (v.Note == "\n" || v.Note == "artifact") {
				cursorY = cursorY + 100
				cursorX = indent * 100
				continue
			}
			// If the current expression contains 3 or more sub expressions, break it across lines
			if ContainsLists(v.List, 3) {
				if CountTree(v.List) > 50 {

					cursorY = cursorY + 100
					cursorX = (indent + 1) * 100
				}
				n := &Box{SplitLayout: "free", AstNode: v}
				Add(b, n)
				// AddBox(n, "(", v)

				BoxTree(n, v.List, indent+2, true)
				cursorY = cursorY + 100
				cursorX = indent * 100
				// AddBox(n, ")", v)
			} else {
				n := &Box{SplitLayout: "free", AstNode: v}
				Add(b, n)
				// AddBox(n, "(", v)
				// fmt.Print(v.Note, "current length: ",len(v.List))
				BoxTree(n, v.List, indent+2, false)
				// AddBox(n, ")", v)

			}
		}
		if newlines {
			cursorY = cursorY + 100
			cursorX = indent * 100

		}
	}
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
