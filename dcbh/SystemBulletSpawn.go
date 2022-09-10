package main

import (
	"math/rand"

	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
)

type Bullet struct {
	ecs.BasicEntity
	CollisionComponent
	common.RenderComponent
	common.SpaceComponent
	DirectionComponent
	LifeTimeComponent
	KindComponent
}

type BulletSpawnSystem struct {
	world  *ecs.World
	target *Guy
}

func (rock *BulletSpawnSystem) New(w *ecs.World) {
	rock.world = w
}

func (*BulletSpawnSystem) Remove(ecs.BasicEntity) {}

func (rock *BulletSpawnSystem) Update(dt float32) {
	// 4% change of spawning a rock each frame
	if rand.Float32() < .96 {
		return
	}

	position := engo.Point{
		X: rock.target.Position.X,
		Y: rock.target.Position.Y,
	}
	NewBullet(rock.world, position)
}

func NewBullet(world *ecs.World, position engo.Point) {
	bull := Bullet{BasicEntity: ecs.NewBasic()}
	bull.Kind = "bullet"

	texture, _ := common.LoadedSprite("damnation.png")
	bull.RenderComponent = common.RenderComponent{
		Drawable: texture,
		Scale:    engo.Point{X: 1, Y: 1},
	}
	bull.SetZIndex(bulletLayer)
	bull.SpaceComponent = common.SpaceComponent{
		Position: position,

		Width:    texture.Width() * bull.RenderComponent.Scale.X,
		Height:   texture.Height() * bull.RenderComponent.Scale.Y,
		Rotation: 45 * rand.Float32(),
	}
	bull.DirectionComponent = DirectionComponent{
		Direction: engo.Point{
			X: rand.Float32()*2 - 1,
			Y: rand.Float32()*2 - 1,
		},
	}

	bull.CollisionComponent = CollisionComponent{Group: 2, Main: 2}
	bull.LifeTimeComponent = LifeTimeComponent{MaxLifeTime: 3}

	for _, system := range world.Systems() {
		switch sys := system.(type) {
		case *common.RenderSystem:
			sys.Add(&bull.BasicEntity, &bull.RenderComponent, &bull.SpaceComponent)
		case *CollisionSystem:
			sys.Add(&bull.BasicEntity, &bull.CollisionComponent, &bull.SpaceComponent, &bull.KindComponent)
		case *BulletSystem:
			sys.Add(&bull)
		}
	}
}
