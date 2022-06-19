package main

import (
	"image/color"
	"log"

	"bytes"
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	"golang.org/x/image/font/gofont/gosmallcaps"
)

var haveGamepad = false

//Create an enum to represent the rendering layers: guylayer, bulletlayer, treelayer, cloudlayer
const ( // iota is reset to 0
	grassLayer   = iota
	guyLayer     = iota
	monsterLayer = iota
	bulletLayer  = iota
	treeLayer    = iota
	cloudLayer   = iota
	hudLayer     = iota
)

type Tile struct {
	ecs.BasicEntity
	common.RenderComponent
	common.SpaceComponent
}

type Guy struct {
	ecs.BasicEntity
	common.CollisionComponent
	common.RenderComponent
	common.SpaceComponent
	CreatureComponent
}

type GameData struct {
	Score int
}

var Game GameData

type DefaultScene struct{}

func (*DefaultScene) Preload() {
	err := engo.Files.Load("damnation.png", "example.tmx", "deep_elf_annihilator.png", "tentacled_starspawn.png", "rock2.png")
	if err != nil {
		log.Println(err)
	}

	engo.Files.LoadReaderData("go.ttf", bytes.NewReader(gosmallcaps.TTF))

	// Register the gamepad
	err = engo.Input.RegisterGamepad("Player1")
	if err != nil {
		println("Unable to find suitable Gamepad. Error was: ", err.Error())
		haveGamepad = false
	} else {
		haveGamepad = true
	}
}

func (*DefaultScene) Setup(u engo.Updater) {
	w, _ := u.(*ecs.World)

	common.SetBackground(color.White)

	// Add all of the systems
	w.AddSystem(&common.RenderSystem{})
	w.AddSystem(&common.CollisionSystem{Solids: 1 | 2})

	//w.AddSystem(&FallingSystem{})

	w.AddSystem(&ControlSystem{})
	w.AddSystem(&RockSpawnSystem{})

	w.AddSystem(&HUDTextSystem{})

	texture, err := common.LoadedSprite("deep_elf_annihilator.png")
	if err != nil {
		log.Println(err)
	}

	// Create an entity
	guy := Guy{BasicEntity: ecs.NewBasic()}
	guy.Name = "Player"
	w.AddSystem(&ChasingSystem{target: &guy, world: w})
	w.AddSystem(&BulletSpawnSystem{target: &guy, world: w})
	w.AddSystem(&BulletSystem{target: &guy, world: w})
	w.AddSystem(&DeathSystem{Player: &guy})
	// Initialize the components, set scale to 4x
	guy.RenderComponent = common.RenderComponent{
		Drawable: texture,
		Scale:    engo.Point{2, 2},
	}
	guy.SetZIndex(guyLayer)
	guy.SpaceComponent = common.SpaceComponent{
		Position: engo.Point{500, 500},
		Width:    texture.Width() * guy.RenderComponent.Scale.X,
		Height:   texture.Height() * guy.RenderComponent.Scale.Y,
	}
	guy.CollisionComponent = common.CollisionComponent{
		Main: 1, Group: 1,
	}
	guy.SetMaxHitPoints(10)
	guy.SetHitPoints(10)

	// Add it to appropriate systems
	for _, system := range w.Systems() {
		switch sys := system.(type) {
		case *common.RenderSystem:
			sys.Add(&guy.BasicEntity, &guy.RenderComponent, &guy.SpaceComponent)
		case *common.CollisionSystem:
			sys.Add(&guy.BasicEntity, &guy.CollisionComponent, &guy.SpaceComponent)
		case *ControlSystem:
			sys.Add(&guy.BasicEntity, &guy.SpaceComponent)
		}
	}
	/*
		err = engo.Input.RegisterGamepad("Player1")
		if err != nil {
			println("Unable to find suitable Gamepad. Error was: ", err.Error())
		}
	*/
	initMap(&guy, w)
}

func (*DefaultScene) Type() string { return "Game" }

func main() {
	opts := engo.RunOptions{
		Title:          "Dungeon Crawl Bullet Hell",
		Width:          1024,
		Height:         1024,
		StandardInputs: true,
		Fullscreen:     false,
		FPSLimit:       30,
	}

	engo.Run(opts, &DefaultScene{})
}

//Initialises the background map
func initMap(character *Guy, w *ecs.World) {

	resource, err := engo.Files.Resource("example.tmx")
	if err != nil {
		panic(err)
	}
	tmxResource := resource.(common.TMXResource)
	levelData := tmxResource.Level

	// Create render and space components for each of the tiles
	tileComponents := make([]*Tile, 0)
	for _, tileLayer := range levelData.TileLayers {
		for _, tileElement := range tileLayer.Tiles {
			if tileElement.Image != nil {

				tile := &Tile{BasicEntity: ecs.NewBasic()}
				tile.RenderComponent = common.RenderComponent{
					Drawable: tileElement,
					Scale:    engo.Point{1, 1},
				}
				tile.SpaceComponent = common.SpaceComponent{
					Position: tileElement.Point,
					Width:    0,
					Height:   0,
				}

				if tileLayer.Name == "grass" {
					tile.RenderComponent.SetZIndex(grassLayer)
				}

				if tileLayer.Name == "trees" {
					tile.RenderComponent.SetZIndex(treeLayer)
				}

				tileComponents = append(tileComponents, tile)
			}
		}
	}

	// Do the same for all image layers
	for _, imageLayer := range levelData.ImageLayers {
		for _, imageElement := range imageLayer.Images {
			if imageElement.Image != nil {
				tile := &Tile{BasicEntity: ecs.NewBasic()}
				tile.RenderComponent = common.RenderComponent{
					Drawable: imageElement,
					Scale:    engo.Point{1, 1},
				}
				tile.SpaceComponent = common.SpaceComponent{
					Position: imageElement.Point,
					Width:    0,
					Height:   0,
				}

				if imageLayer.Name == "clouds" {
					tile.RenderComponent.SetZIndex(cloudLayer)
				}

				tileComponents = append(tileComponents, tile)
			}
		}
	}

	// Add each of the tiles entities and its components to the render system along with the character
	for _, system := range w.Systems() {
		switch sys := system.(type) {
		case *common.RenderSystem:
			for _, v := range tileComponents {
				sys.Add(&v.BasicEntity, &v.RenderComponent, &v.SpaceComponent)
			}

		}
	}

	// Add the EntityScroller system which contains the space component of the character and is bounded to the tmx level dimensions
	w.AddSystem(&common.EntityScroller{SpaceComponent: &character.SpaceComponent, TrackingBounds: levelData.Bounds()})

}
