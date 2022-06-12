package main

import (
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	"image/color"
	"math/rand"
)

type Rock struct {
	ecs.BasicEntity
	common.CollisionComponent
	common.RenderComponent
	common.SpaceComponent
}

type RockSpawnSystem struct {
	world *ecs.World
}

func (rock *RockSpawnSystem) New(w *ecs.World) {
	rock.world = w
}

func (*RockSpawnSystem) Remove(ecs.BasicEntity) {}

func (rock *RockSpawnSystem) Update(dt float32) {
	// 4% change of spawning a rock each frame
	if rand.Float32() < .96 {
		return
	}

	position := engo.Point{
		X: rand.Float32() * engo.GameWidth(),
		Y: -32,
	}
	NewRock(rock.world, position)
}

func NewRock(world *ecs.World, position engo.Point) {
	rock := Rock{BasicEntity: ecs.NewBasic()}
	rock.Name = "enemy"
	switch rand.Intn(3) {
	case 0:
		yscale := 1.0 + rand.Float32()
		rock.RenderComponent = common.RenderComponent{
			Drawable: common.Circle{},
			Color:    color.RGBA{0, 0, 0, 255},
		}
		rock.SetZIndex(1)
		rock.SpaceComponent = common.SpaceComponent{
			Position: position,
			Width:    16 * 4,
			Height:   16 * 4 * yscale,
			Rotation: 45 * rand.Float32(),
		}
		rock.AddShape(common.Shape{
			Ellipse: common.Ellipse{
				Rx: 32,
				Ry: 32 * yscale,
				Cx: 32,
				Cy: 32 * yscale,
			},
		})
	case 1:
		texture, _ := common.LoadedSprite("rock2.png")
		rock.RenderComponent = common.RenderComponent{
			Drawable: texture,
			Scale:    engo.Point{X: 4, Y: 4},
		}
		rock.SetZIndex(1)
		rock.SpaceComponent = common.SpaceComponent{
			Position: position,
			Width:    texture.Width() * rock.RenderComponent.Scale.X,
			Height:   texture.Height() * rock.RenderComponent.Scale.Y,
			Rotation: 45 * rand.Float32(),
		}
		pts := []float32{4, 0, 12, 0, 16, 4, 16, 13, 13, 13, 13, 16, 3, 16, 3, 13, 0, 13, 0, 4, 4, 0}
		lines := []engo.Line{}
		for i := 0; i < len(pts)-3; i += 2 {
			line := engo.Line{
				P1: engo.Point{
					X: pts[i] * 4,
					Y: pts[i+1] * 4,
				},
				P2: engo.Point{
					X: pts[i+2] * 4,
					Y: pts[i+3] * 4,
				},
			}
			lines = append(lines, line)
		}
		rock.AddShape(common.Shape{Lines: lines})
	default:
		texture, _ := common.LoadedSprite("tentacled_starspawn.png")
		rock.RenderComponent = common.RenderComponent{
			Drawable: texture,
			Scale:    engo.Point{X: 2, Y: 2},
		}
		rock.SetZIndex(1)
		rock.SpaceComponent = common.SpaceComponent{
			Position: position,
			Width:    texture.Width() * rock.RenderComponent.Scale.X,
			Height:   texture.Height() * rock.RenderComponent.Scale.Y,
			Rotation: 45 * rand.Float32(),
		}
	}
	rock.CollisionComponent = common.CollisionComponent{Group: 1, Main: 1}
	rock.CollisionComponent = common.CollisionComponent{Group: 2, Main: 2}

	for _, system := range world.Systems() {
		switch sys := system.(type) {
		case *common.RenderSystem:
			sys.Add(&rock.BasicEntity, &rock.RenderComponent, &rock.SpaceComponent)
		case *common.CollisionSystem:
			sys.Add(&rock.BasicEntity, &rock.CollisionComponent, &rock.SpaceComponent)
		case *FallingSystem:
			sys.Add(&rock.BasicEntity, &rock.SpaceComponent)
		case *ChasingSystem:
			sys.Add(&rock.BasicEntity, &rock.SpaceComponent)
		}
	}
}
