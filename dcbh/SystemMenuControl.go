package main

import (
	"log"

	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	//"log"
)

type MenuControlSystem struct {
	entities []controlEntity
	player   *Guy
}

func (c *MenuControlSystem) Add(basic *ecs.BasicEntity, space *common.SpaceComponent) {
	c.entities = append(c.entities, controlEntity{basic, space})
}

func (c *MenuControlSystem) Remove(basic ecs.BasicEntity) {
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

func (c *MenuControlSystem) Update(dt float32) {
	speed := 400 * dt

	//log.Printf("MenuControlSystem update")
	if engo.Input.Button("action").JustReleased() {
		log.Printf("Action button pressed")
		engo.SetSceneByName("Game", false)
	}
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
			//log.Printf("gamepad %+v", gamepad)
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
