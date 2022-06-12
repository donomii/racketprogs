package main

import (
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
)

type fallingEntity struct {
	*ecs.BasicEntity
	*common.SpaceComponent
}

type FallingSystem struct {
	entities []fallingEntity
	world    *ecs.World
}

func (f *FallingSystem) Add(basic *ecs.BasicEntity, space *common.SpaceComponent) {
	f.entities = append(f.entities, fallingEntity{basic, space})
}

func (f *FallingSystem) Remove(basic ecs.BasicEntity) {
	for i, e := range f.entities {
		if e.BasicEntity.ID() == basic.ID() {
			for _, system := range f.world.Systems() {
				switch system.(type) {
				case *FallingSystem:
				default:
					system.Remove(*e.BasicEntity)
				}
			}
			f.entities = append(f.entities[:i], f.entities[i+1:]...)
			break
		}
	}
}

func (f *FallingSystem) Update(dt float32) {
	speed := 400 * dt

	for _, e := range f.entities {
		e.SpaceComponent.Position.Y += speed

		if e.SpaceComponent.Position.Y > engo.GameHeight() {
			f.Remove(*e.BasicEntity)
		}
	}
}

func (f *FallingSystem) New(world *ecs.World) {
	f.world = world
}
