package main

import (
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
)

type chasingEntity struct {
	*ecs.BasicEntity
	*common.SpaceComponent
}

type ChasingSystem struct {
	entities []chasingEntity
	world    *ecs.World
	target   *Guy
}

func (f *ChasingSystem) Add(basic *ecs.BasicEntity, space *common.SpaceComponent) {
	f.entities = append(f.entities, chasingEntity{basic, space})
}

func (f *ChasingSystem) Remove(basic ecs.BasicEntity) {
	for i, e := range f.entities {
		if e.BasicEntity.ID() == basic.ID() {
			f.entities = append(f.entities[:i], f.entities[i+1:]...)
			break
		}
	}
}

//Purge entity from all systems
func (f *ChasingSystem) Purge(basic ecs.BasicEntity) {
	for _, system := range f.world.Systems() {
		switch system.(type) {
		case *ChasingSystem:
		default:
			system.Remove(basic)
		}
	}
}

func (f *ChasingSystem) Update(dt float32) {
	speed := 40 * dt

	for _, e := range f.entities {

		//e.SpaceComponent.Position.Y += speed

		if f.target.SpaceComponent.Position.Y > e.SpaceComponent.Position.Y {
			e.SpaceComponent.Position.Y += speed
		} else {
			e.SpaceComponent.Position.Y -= speed
		}

		if f.target.SpaceComponent.Position.X > e.SpaceComponent.Position.X {
			e.SpaceComponent.Position.X += speed
		} else {
			e.SpaceComponent.Position.X -= speed
		}

		if e.SpaceComponent.Position.Y > engo.GameHeight() {
			f.Remove(*e.BasicEntity)
		}
	}
}

func (f *ChasingSystem) New(world *ecs.World, guy *Guy) {
	f.world = world
}
