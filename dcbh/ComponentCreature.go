package main

import ()

// CreatureComponent keeps track of the position, size, and rotation of entities.
type CreatureComponent struct {
	HitPoints    int
	MaxHitPoints int
}

func (c *CreatureComponent) GetCreatureComponent() *CreatureComponent {
	return c
}

func (c *CreatureComponent) SetHitPoints(hp int) {
	c.HitPoints = hp
}

func (c *CreatureComponent) SetMaxHitPoints(hp int) {
	c.MaxHitPoints = hp
}

func (c *CreatureComponent) GetHitPoints() int {
	return c.HitPoints
}

func (c *CreatureComponent) GetMaxHitPoints() int {
	return c.MaxHitPoints
}

func (c *CreatureComponent) Damage(damage int) {
	c.HitPoints -= damage
}

func (c *CreatureComponent) isDead() bool {
	return c.HitPoints <= 0
}
