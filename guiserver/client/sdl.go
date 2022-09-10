//go:build sdl
// +build sdl

package main

import (
	"fmt"
	"log"
	"os"

	"github.com/veandco/go-sdl2/sdl"
	"github.com/veandco/go-sdl2/ttf"
)

var (
	surface *sdl.Surface
	window  *sdl.Window
	font    *ttf.Font
	text    *sdl.Surface
)

func InitGraphics() {
	var err error
	if err := ttf.Init(); err != nil {
		return
	}
	// defer ttf.Quit()

	if err := sdl.Init(sdl.INIT_EVERYTHING); err != nil {
		panic(err)
	}
	// defer sdl.Quit()

	window, err = sdl.CreateWindow("test", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED,
		800, 600, sdl.WINDOW_SHOWN)
	if err != nil {
		panic(err)
	}
	// defer window.Destroy()

	surface, err = window.GetSurface()
	if err != nil {
		panic(err)
	}

	// Load the font for our text
	if font, err = ttf.OpenFont(fontPath, fontSize); err != nil {
		return
	}
	// defer font.Close()
}

func MainGraphicsLoop() {
	surface, err := window.GetSurface()
	if err != nil {
		panic(err)
	}
	TextList = []txtcall{}
	running := true
	var mouseX, mouseY int = 0, 0
	var action string
	var updateNeeded bool = true
	for running {
		if updateNeeded {
			surface.FillRect(nil, 0)
			drawText(scale*float64(top.X), scale*float64(top.Y), top.Text, 18)
			draw(mouseX, mouseY, action)

			TextList = []txtcall{}
			updateNeeded = false
		}
		action = ""

		// drawBox(0, 0, 200, 200, 0xffff0000)
		// rect := sdl.Rect{0, 0, 200, 200}
		// surface.FillRect(&rect, 0xffff0000)
		window.UpdateSurface()
		for event := sdl.PollEvent(); event != nil; event = sdl.PollEvent() {
			log.Printf("event: %+v\n", event)
			log.Printf("type: %T\n", event)
			updateNeeded = true
			switch t := event.(type) {
			case sdl.QuitEvent:
				println("Quit")
				running = false
				break
			case sdl.MouseMotionEvent:
				mouseX = int(t.X)
				mouseY = int(t.Y)

				// fmt.Println("Mouse", t.Which, "moved by", t.XRel, t.YRel, "at", t.X, t.Y)
			case sdl.MouseButtonEvent:
				mouseX = int(t.X)
				mouseY = int(t.Y)

				if t.State == sdl.PRESSED {
					action = "press"
					// fmt.Println("Mouse", t.Which, "button", t.Button, "pressed at", t.X, t.Y)
				} else {
					action = "release"
					// fmt.Println("Mouse", t.Which, "button", t.Button, "released at", t.X, t.Y)
				}
			case sdl.MouseWheelEvent:
				mouseX = int(t.X)
				mouseY = int(t.Y)
				action = "wheel"
				if t.X != 0 {
					// fmt.Println("Mouse", t.Which, "wheel scrolled horizontally by", t.X)
				} else {
					// fmt.Println("Mouse", t.Which, "wheel scrolled vertically by", t.Y)
				}

			case sdl.KeyboardEvent:
				keyCode := t.Keysym.Sym
				keys := ""

				// Modifier keys
				switch sdl.Keymod(t.Keysym.Mod) {
				case sdl.KMOD_LALT:
					keys += "Left Alt"
				case sdl.KMOD_LCTRL:
					keys += "Left Control"
				case sdl.KMOD_LSHIFT:
					keys += "Left Shift"
				case sdl.KMOD_LGUI:
					keys += "Left Meta or Windows key"
				case sdl.KMOD_RALT:
					keys += "Right Alt"
				case sdl.KMOD_RCTRL:
					keys += "Right Control"
				case sdl.KMOD_RSHIFT:
					keys += "Right Shift"
				case sdl.KMOD_RGUI:
					keys += "Right Meta or Windows key"
				case sdl.KMOD_NUM:
					keys += "Num Lock"
				case sdl.KMOD_CAPS:
					keys += "Caps Lock"
				case sdl.KMOD_MODE:
					keys += "AltGr Key"

				}

				switch keyCode {
				case sdl.K_ESCAPE:
					os.Exit(0)
				case sdl.K_DELETE:
					dispatch("DELETE-LEFT", currentEditor)
				case sdl.K_RETURN:

					fallthrough
				case sdl.K_RETURN2:
					ActiveBufferInsert(currentEditor, "")
					fmt.Println("Printing tree")
					PrintBoxTree(*top, 0, true)
				default:
					ActiveBufferInsert(currentEditor, string(keyCode))
				}
				currentEditBox.Text = ActiveBufferText(currentEditor)
				currentEditBox.AstNode.Str = ActiveBufferText(currentEditor)
				if keyCode < 10000 {
					if keys != "" {
						keys += " + "
					}

					// If the key is held down, this will fire
					if t.Repeat > 0 {
						keys += string(keyCode) + " repeating"
					} else {
						if t.State == sdl.RELEASED {
							keys += string(keyCode) + " released"
						} else if t.State == sdl.PRESSED {
							keys += string(keyCode) + " pressed"
						}
					}

				}

				if keys != "" {
					fmt.Println(keys)
				}

			}
		}
	}
}

func drawBox(x, y, w, h float64, color uint32) {
	rect := sdl.Rect{int32(x), int32(y), int32(w), int32(h)}
	surface.FillRect(&rect, color)
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
