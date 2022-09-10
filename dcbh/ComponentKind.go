package main

// DirectionComponent keeps track of the position, size, and rotation of entities.
type KindComponent struct {
	Kind string
}

func (c *KindComponent) GetKind() string {
	return c.Kind
}

func (c *KindComponent) SetKind(kind string) {
	c.Kind = kind
}
