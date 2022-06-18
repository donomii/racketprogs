package main

import (
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
)

type BulletSystem struct {
	entities []*Bullet
	world    *ecs.World
	target   *Guy
}

func (f *BulletSystem) Add(bull *Bullet) {
	f.entities = append(f.entities, bull)
}

func (f *BulletSystem) Remove(basic ecs.BasicEntity) {
	for i, e := range f.entities {
		if e.BasicEntity.ID() == basic.ID() {
			f.entities = append(f.entities[:i], f.entities[i+1:]...)
			break
		}
	}
}

//Purge entity from all systems
func (f *BulletSystem) Purge(basic ecs.BasicEntity) {
	for _, system := range f.world.Systems() {
		switch system.(type) {
		case *BulletSystem:
		default:
			system.Remove(basic)
		}
	}
}

func (f *BulletSystem) Update(dt float32) {
	speed := 40 * dt

	for _, e := range f.entities {

		//e.SpaceComponent.Position.Y += speed

		dir := e.GetDirectionComponent().Direction

		e.SpaceComponent.Position.Y = e.SpaceComponent.Position.Y - speed*dir.Y

		e.SpaceComponent.Position.X -= speed * dir.X

		if e.SpaceComponent.Position.Y > engo.GameHeight() {
			f.Remove(e.BasicEntity)
		}
		e.GetLifeTimeComponent().AddTime(dt)
		e.GetLifeTimeComponent().CheckDead(e.BasicEntity)
	}
}

func (f *BulletSystem) New(world *ecs.World, guy *Guy) {
	f.world = world
}

// LifeTimeComponent keeps track of the position, size, and rotation of entities.
type LifeTimeComponent struct {
	MaxLifeTime float32
	CurrentAge  float32
}

// AddShape adds a shape to the LifeTimeComponent for use as a hitbox. A LifeTimeComponent
// can have any number of shapes attached to it. The shapes are made up of a
// []engo.Line, with each line defining a face of the shape. The coordinates are
// such that (0,0) is the upper left corner of the LifeTimeComponent. If no shapes
// are added, the LifeTimeComponent is treated as an AABB.
func (sc *LifeTimeComponent) AddTime(t float32) {
	sc.CurrentAge += t
}

func (sc *LifeTimeComponent) SetAge(t float32) {
	sc.CurrentAge = t
}

func (sc *LifeTimeComponent) SetMaxLifeTime(t float32) {
	sc.MaxLifeTime = t
}
func (sc *LifeTimeComponent) GetAge() float32 {
	return sc.CurrentAge
}

func (sc *LifeTimeComponent) GetMaxLifeTime() float32 {
	return sc.MaxLifeTime
}

func (sc *LifeTimeComponent) CheckDead(ent ecs.BasicEntity) {
	if sc.CurrentAge > sc.MaxLifeTime {
		engo.Mailbox.Dispatch(AgeDeathMessage{Entity: ent, Age: sc.CurrentAge})
	}
}

func (sc *LifeTimeComponent) GetLifeTimeComponent() *LifeTimeComponent {
	return sc
}

// CollisionMessage is sent whenever a collision is detected by the CollisionSystem.
type AgeDeathMessage struct {
	Entity ecs.BasicEntity
	Age    float32
}

// Type implements the engo.Message interface
func (AgeDeathMessage) Type() string { return "AgeDeathMessage" }
