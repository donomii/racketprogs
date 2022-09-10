//go:build !sdl
// +build !sdl

package main

// Routines to handle mouse movement, keyboard, and window events

import (
	"log"

	"github.com/go-gl/glfw/v3.3/glfw"
)

var selected int

func handleKeys(window *glfw.Window) {
	window.SetKeyCallback(func(w *glfw.Window, key glfw.Key, scancode int, action glfw.Action, mods glfw.ModifierKey) {
		log.Printf("Got key %c,%v,%v,%v", key, key, mods, action)

		/*if key == 301 {
			hideWindow()
			return
		}
		*/
		/*
				EscapeKeyCode := 256
			MacEscapeKeyCode := 53
			MacF12KeyCode := 301

					if action > 0 {
						if key == glfw.Key(MacF12KeyCode) || key == 109 {
							doKeyPress("HideWindow")
						}
						// ESC
						if key == glfw.Key(EscapeKeyCode) || key == glfw.Key(MacEscapeKeyCode) {
							// os.Exit(0)
							log.Println("Escape pressed")
							wantExit = true
							doKeyPress("HideWindow")
							return
						}

						if key == 265 {
							doKeyPress("SelectPrevious")
						}

						if key == 264 {
							doKeyPress("SelectNext")
						}

						if key == 257 {
							doKeyPress("Activate")
						}

						if key == 259 {
							doKeyPress("Backspace")
						}

						UpdateBuffer(ed, input)
						update = true
					}
		*/
	})

	window.SetCharModsCallback(func(w *glfw.Window, char rune, mods glfw.ModifierKey) {
		/*
			text := fmt.Sprintf("%c", char)
			input = input + text
			UpdateBuffer(ed, input)
			update = true
		*/
	})
}

func handleFocus(window *glfw.Window) {
	/*
		window.SetFocusCallback(func(w *glfw.Window, focused bool) {
			log.Printf("Focus changed to %v\n", focused)
			if !focused {
				invalidCoords = true
				log.Println("Marked coords as invalid")
			}
		})
	*/
}

func handleMouse(window *glfw.Window) {
	window.SetMouseButtonCallback(func(w *glfw.Window, button glfw.MouseButton, action glfw.Action, mods glfw.ModifierKey) {
		if button == glfw.MouseButtonLeft {
			if action == glfw.Press {
				log.Println("Mouse button pressed")

				fX, fY := window.GetCursorPos()
				mouseX, mouseY = int(fX), int(fY)
				draw_action = "press"

			}
		}

		if button == glfw.MouseButtonLeft {
			if action == glfw.Release {
				draw_action = "release"
			}
		}
	})
}

func handleScroll(window *glfw.Window) {
	window.SetScrollCallback(func(w *glfw.Window, xoff float64, yoff float64) {
		if yoff > 0 {
			log.Println("Scroll up")
			draw_action = "wheel up"
		} else {
			log.Println("Scroll down")
			draw_action = "wheel down"
		}

		mouseY = int(yoff)
		// draw_action = "wheel"
	})
}

func handleMouseMove(window *glfw.Window) {
	window.SetCursorPosCallback(func(w *glfw.Window, xpos float64, ypos float64) {
		mouseX, mouseY = int(xpos), int(ypos)
		/*
			// fmt.Printf("Mouse moved to %v,%v\n", xpos, ypos)
			if invalidCoords {
				lastMouseX = xpos
				lastMouseY = ypos
			} else {
				lastMouseX = mouseX
				lastMouseY = mouseY
			}
			mouseX = xpos
			mouseY = ypos
			X, Y := window.GetPos()
			globalMouseX = xpos - float64(X)
			globalMouseY = ypos - float64(Y)

			log.Printf("Mouse moved to %v,%v, last X,Y: %v,%v\n", mouseX, mouseY, lastMouseX, lastMouseY)
			if mouseDrag && !invalidCoords {

				deltaX := globalMouseX - dragStartX
				deltaY := globalMouseY - dragStartY
				log.Printf("deltaX: %v, deltaY: %v, mouseX: %v, mouseY: %v, dragStartX: %v, dragStartY: %v, dragOffSetX: %v, dragOffSetY: %v\n", deltaX, deltaY, mouseX, mouseY, dragStartX, dragStartY, dragOffSetX, dragOffSetY)
				log.Printf("globalMouseX: %v, globalMouseY: %v\n", globalMouseX, globalMouseY)
				if (deltaX > 10) || (deltaX < -10) || (deltaY > 10) || (deltaY < -10) {
					windowPosX += int(mouseX - dragOffSetX)
					windowPosY += int(mouseY - dragOffSetY)
					log.Printf("Dragged to %v,%v\n", windowPosX, windowPosY)
					window.SetPos(int(windowPosX), int(windowPosY))
				}
			}

			invalidCoords = false
			log.Println("Marked coords as valid")
		*/
	})
}
