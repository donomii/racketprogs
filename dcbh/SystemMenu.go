package main

import (
	"image/color"
	_ "log"

	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
)

// MenuTextSystem prints the text to our HUD based on the current state of the game
type MenuTextSystem struct {
	text       Text
	HpFraction float32
}

// New is called when the system is added to the world.
// Adds text to our HUD that will update based on the state of the game.
func (h *MenuTextSystem) New(w *ecs.World) {
	h.HpFraction = 1.0
	fnt := &common.Font{
		URL:  "go.ttf",
		FG:   color.White,
		Size: 24,
	}
	fnt.CreatePreloaded()

	h.text = Text{BasicEntity: ecs.NewBasic()}
	h.text.RenderComponent.Drawable = common.Text{
		Font: fnt,
		Text: "Dungeon Crawl Bullet Hell.  Press Enter to start.",
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
	rectangle1 := MyShape{BasicEntity: ecs.NewBasic()}
	rectangle1.SpaceComponent = common.SpaceComponent{Position: engo.Point{10, 10}, Width: h.HpFraction * (engo.WindowWidth() - 20), Height: 50}
	rectangle1.RenderComponent = common.RenderComponent{Drawable: common.Rectangle{BorderWidth: 1, BorderColor: color.White}, Color: color.RGBA{255, 255, 0, 255}}

	for _, system := range w.Systems() {
		switch sys := system.(type) {
		case *common.RenderSystem:
			sys.Add(&rectangle1.BasicEntity, &rectangle1.RenderComponent, &rectangle1.SpaceComponent)
		}
	}
	rectangle1.SetZIndex(1001)
	rectangle1.SetShader(common.LegacyHUDShader)

	engo.Mailbox.Listen("WindowResizeMessage", func(msg engo.Message) {
		//log.Printf("Received message: %v", msg.(engo.WindowResizeMessage))
		/*winResMessage, ok := msg.(engo.WindowResizeMessage)
		if !ok {
			return
		}
		*/

	})

}

// Update is called each frame to update the system.
func (h *MenuTextSystem) Update(dt float32) {}

// Remove takes an entity out of the system.
// It does nothing as MenuTextSystem has no entities.
func (h *MenuTextSystem) Remove(entity ecs.BasicEntity) {}
