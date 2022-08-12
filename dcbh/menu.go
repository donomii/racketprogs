package main

import (
	"bytes"

	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	"golang.org/x/image/font/gofont/gosmallcaps"
)

type MenuScene struct{}

func (*MenuScene) Preload() {
	engo.Files.LoadReaderData("go.ttf", bytes.NewReader(gosmallcaps.TTF))

	// Register the gamepad
	err := engo.Input.RegisterGamepad("Player1")
	if err != nil {
		println("Unable to find suitable Gamepad. Error was: ", err.Error())
		haveGamepad = false
	} else {
		haveGamepad = true
	}
}

func (*MenuScene) Setup(u engo.Updater) {
	w, _ := u.(*ecs.World)

	w.AddSystem(&common.RenderSystem{})

	//w.AddSystem(&FallingSystem{})

	w.AddSystem(&MenuControlSystem{})
	w.AddSystem(&MenuTextSystem{})

}

func (*MenuScene) Type() string { return "Menu" }
