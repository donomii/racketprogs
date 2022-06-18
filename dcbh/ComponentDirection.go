package main

import (
	"github.com/EngoEngine/engo"
)

// DirectionComponent keeps track of the position, size, and rotation of entities.
type DirectionComponent struct {
	Direction engo.Point
}

func (c *DirectionComponent) GetDirectionComponent() *DirectionComponent {
	return c
}

func (c *DirectionComponent) SetDirection(direction engo.Point) {
	c.Direction = direction
}
