//go:build !sdl
// +build !sdl

package main

import (
	"image/color"
	"os"
	"time"

	"github.com/donomii/glim"
	"github.com/go-gl/glfw/v3.3/glfw"
)

var (
	win   *glfw.Window
	state *State

	ed               *GlobalConfig // The text editor
	transfer_texture []uint8       // The texture buffer to transfer to the GPU

	form           *glim.FormatParams
	edWidth        = 800
	edHeight       = 600
	mouseX, mouseY int
	draw_action    string
)

func InitGraphics() {
	win, state = gfxStart(800, 600, "test", false)
	transfer_texture = make([]uint8, 3000*3000*4)

	edWidth = 800
	edHeight = 600
	ed = NewEditor()
	// Create a text formatter.  This controls the appearance of the text, e.g. colour, size, layout
	form = glim.NewFormatter()
	ed.ActiveBuffer.Formatter = form
	SetFont(ed.ActiveBuffer, fontSize)

	handleKeys(win)
	handleMouse(win)
	handleMouseMove(win)
	handleFocus(win)
	handleScroll(win)

	win.SetSizeCallback(func(w *glfw.Window, width int, height int) {
		edWidth = width
		edHeight = height
	})
}

func StartMain() {
	for !win.ShouldClose() {

		// Make a random number between 0 and 255
		// r := uint8(rand.Intn(255))
		drawBox(0, 0, float64(edWidth), float64(edHeight), 0, 0, 0, 255)
		draw(mouseX, mouseY, draw_action)
		draw_action = ""
		gfxMain(win, state, transfer_texture, edWidth, edHeight)

		glfw.PollEvents()
		time.Sleep(time.Millisecond * 30)

	}
	os.Exit(0)
}

func drawBox(x, y, w, h float64, r, g, b, a uint8) {
	// fmt.Println("Box at ", x, y, w, h)
	// fmt.Println("Colour ", r, g, b, a)
	glim.DrawBox(int(x), int(y), int(w), int(h), edWidth, edHeight, transfer_texture, color.RGBA{r, g, b, a})
}

func drawText(x, y float64, str string, size float64) {
	f := glim.NewFormatter()
	f.Colour = &glim.RGBA{255, 255, 255, 255}
	glim.RenderPara(f, int(x), int(y), 0, 0, edWidth, edHeight, edWidth, edHeight, 0, 0, transfer_texture, str, false, true, false)
}
