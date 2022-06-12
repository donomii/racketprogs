package main

import (
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	"log"
)

type controlEntity struct {
	*ecs.BasicEntity
	*common.SpaceComponent
}

type ControlSystem struct {
	entities []controlEntity
	player   *Guy
}

func (c *ControlSystem) Add(basic *ecs.BasicEntity, space *common.SpaceComponent) {
	c.entities = append(c.entities, controlEntity{basic, space})
}

func (c *ControlSystem) Remove(basic ecs.BasicEntity) {
	delete := -1
	for index, e := range c.entities {
		if e.BasicEntity.ID() == basic.ID() {
			delete = index
			break
		}
	}
	if delete >= 0 {
		c.entities = append(c.entities[:delete], c.entities[delete+1:]...)
	}
}

func (c *ControlSystem) Update(dt float32) {
	speed := 400 * dt

	var gamepad *engo.Gamepad
	if haveGamepad {
		// Retrieve the Gamepad
		gamepad = engo.Input.Gamepad("Player1")
	} else {

		gamepad = nil

	}

	for _, e := range c.entities {
		hori := engo.Input.Axis(engo.DefaultHorizontalAxis)
		e.SpaceComponent.Position.X += speed * hori.Value()

		vert := engo.Input.Axis(engo.DefaultVerticalAxis)
		e.SpaceComponent.Position.Y += speed * vert.Value()

		if gamepad != nil {
			log.Printf("gamepad %+v", gamepad)
			if gamepad.DpadUp.Down() {
				e.SpaceComponent.Position.Y -= speed
			} else if gamepad.DpadDown.Down() {
				e.SpaceComponent.Position.Y += speed
			} else if gamepad.DpadLeft.Down() {
				e.SpaceComponent.Position.X -= speed
			} else if gamepad.DpadRight.Down() {
				e.SpaceComponent.Position.X += speed
			}

		}

	}

}
