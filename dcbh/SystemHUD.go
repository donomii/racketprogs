package main

import (
	"image/color"
	"log"

	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
)

// Text is an entity containing text printed to the screen
type Text struct {
	ecs.BasicEntity
	common.SpaceComponent
	common.RenderComponent
}

// HUDTextSystem prints the text to our HUD based on the current state of the game
type HUDTextSystem struct {
	text Text
}

// New is called when the system is added to the world.
// Adds text to our HUD that will update based on the state of the game.
func (h *HUDTextSystem) New(w *ecs.World) {
	fnt := &common.Font{
		URL:  "go.ttf",
		FG:   color.Black,
		Size: 24,
	}
	fnt.CreatePreloaded()

	h.text = Text{BasicEntity: ecs.NewBasic()}
	h.text.RenderComponent.Drawable = common.Text{
		Font: fnt,
		Text: "Hello, world!",
	}
	h.text.SetShader(common.TextHUDShader)
	h.text.RenderComponent.SetZIndex(1001)
	h.text.SpaceComponent = common.SpaceComponent{
		Position: engo.Point{X: 0, Y: engo.WindowHeight() - 200},
		Width:    200,
		Height:   200,
	}
	for _, system := range w.Systems() {
		switch sys := system.(type) {
		case *common.RenderSystem:
			sys.Add(&h.text.BasicEntity, &h.text.RenderComponent, &h.text.SpaceComponent)
		}
	}

	engo.Mailbox.Listen("HUDTextMessage", func(message engo.Message) {
		log.Printf("Received message: %v", message.(HUDTextMessage))
		h.text.RenderComponent.Drawable = common.Text{
			Font: fnt,
			Text: message.(HUDTextMessage).Text,
		}

	})
}

// Update is called each frame to update the system.
func (h *HUDTextSystem) Update(dt float32) {}

// Remove takes an enitty out of the system.
// It does nothing as HUDTextSystem has no entities.
func (h *HUDTextSystem) Remove(entity ecs.BasicEntity) {}

// HUDTextMessage updates the HUD text based on messages sent from other systems
type HUDTextMessage struct {
	ecs.BasicEntity
	Text string
}

const HUDTextMessageType string = "HUDTextMessage"

// Type implements the engo.Message Interface
func (HUDTextMessage) Type() string {
	return HUDTextMessageType
}
