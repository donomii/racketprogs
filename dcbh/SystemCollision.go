package main

import (
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	"github.com/EngoEngine/engo/math"
)

// Shape is a shape used for a SpaceComponent's hitboxes. It is composed of
// Lines that make up the polygon's shape or an ellipse which makes up an ellpitical
// shape. N is the number of lines used to approximate the ellpse; N defaults to
// 25.
type Shape struct {
	Ellipse Ellipse
	Lines   []engo.Line
	N       int
}

// Project projects the shape onto the given vector.
func (s Shape) Project(p engo.Point, sc common.SpaceComponent) (min, max float32) {
	s.PolygonEllipse()
	sin, cos := math.Sincos(sc.Rotation * math.Pi / 180)
	l := engo.Line{
		P1: engo.Point{
			X: sc.Position.X + s.Lines[0].P1.X*cos - s.Lines[0].P1.Y*sin,
			Y: sc.Position.Y + s.Lines[0].P1.Y*cos + s.Lines[0].P1.X*sin,
		},
		P2: engo.Point{
			X: sc.Position.X + s.Lines[0].P2.X*cos - s.Lines[0].P2.Y*sin,
			Y: sc.Position.Y + s.Lines[0].P2.Y*cos + s.Lines[0].P2.X*sin,
		},
	}
	min = l.P1.X*p.X + l.P1.Y*p.Y
	max = min
	for _, line := range s.Lines {
		l = engo.Line{
			P1: engo.Point{
				X: sc.Position.X + line.P1.X*cos - line.P1.Y*sin,
				Y: sc.Position.Y + line.P1.Y*cos + line.P1.X*sin,
			},
			P2: engo.Point{
				X: sc.Position.X + line.P2.X*cos - line.P2.Y*sin,
				Y: sc.Position.Y + line.P2.Y*cos + line.P2.X*sin,
			},
		}
		dot := l.P2.X*p.X + l.P2.Y*p.Y
		if dot < min {
			min = dot
		}
		if dot > max {
			max = dot
		}
	}
	return
}

// PolygonEllipse approximates the Ellipse as an N-sided polygon, determined by
// the shape's N value. If N is 0, it defaults to 25.
func (s *Shape) PolygonEllipse() {
	if engo.FloatEqual(s.Ellipse.Rx, 0) || engo.FloatEqual(s.Ellipse.Ry, 0) {
		return // not an ellipse
	}
	if s.N == 0 {
		s.N = 25
	}
	if len(s.Lines) != s.N {
		s.Lines = make([]engo.Line, s.N)
		theta := float32(2.0 * math.Pi / float32(s.N))
		sin, cos := math.Sincos(0.0)
		for i := 0; i < s.N; i++ {
			line := engo.Line{}
			line.P1 = engo.Point{
				X: s.Ellipse.Cx + s.Ellipse.Rx*sin,
				Y: s.Ellipse.Cy + s.Ellipse.Ry*cos,
			}
			sin, cos = math.Sincos(float32(i+1) * theta)
			line.P2 = engo.Point{
				X: s.Ellipse.Cx + s.Ellipse.Rx*sin,
				Y: s.Ellipse.Cy + s.Ellipse.Ry*cos,
			}
			s.Lines[i] = line
		}
	}
}

// Ellipse represnets an ellpitical shape.
// Cx and Cy are the x and y coordinates of the center of the ellipse.
// Rx and Ry are the x and y radii of the ellipse.
// N is the number of faces used for a polymeric representation of the ellipse
// for collision detection.
type Ellipse struct {
	Cx, Cy float32
	Rx, Ry float32
}

func separationOfAxes(sc, other common.SpaceComponent, hb, otherHB Shape) (bool, engo.Point) {
	sin, cos := math.Sincos(sc.Rotation * math.Pi / 180)
	othersin, othercos := math.Sincos(other.Rotation * math.Pi / 180)
	overlap := float32(math.MaxFloat32)
	smallestAxis := engo.Point{}
	axes := []engo.Point{}
	for _, axis := range hb.Lines {
		pt := engo.Point{
			X: axis.P2.X*cos - axis.P2.Y*sin - axis.P1.X*cos + axis.P1.Y*sin,
			Y: axis.P2.Y*cos + axis.P2.X*sin - axis.P1.Y*cos - axis.P1.X*sin,
		}
		norm, _ := pt.Normalize()
		axes = append(axes, engo.Point{
			X: norm.Y * -1,
			Y: norm.X,
		})
	}
	otherAxes := []engo.Point{}
	for _, axis := range otherHB.Lines {
		pt := engo.Point{
			X: axis.P2.X*othercos - axis.P2.Y*othersin - axis.P1.X*othercos + axis.P1.Y*othersin,
			Y: axis.P2.Y*othercos + axis.P2.X*othersin - axis.P1.Y*othercos - axis.P1.X*othersin,
		}
		norm, _ := pt.Normalize()
		otherAxes = append(otherAxes, engo.Point{
			X: norm.Y * -1,
			Y: norm.X,
		})
	}
	for _, axis := range axes {
		p1min, p1max := hb.Project(axis, sc)
		p2min, p2max := otherHB.Project(axis, other)
		if p2min > p1max {
			return false, engo.Point{}
		}
		var o float32
		if p1min < p2min {
			if p1max < p2max {
				o = p1max - p2min
			} else {
				o = p1max - p1min
			}
		} else {
			if p1max < p2max {
				o = p2max - p1min
			} else {
				o = p1max - p1min
			}
		}
		if o < overlap {
			overlap = o
			smallestAxis = axis
		}
	}
	for _, axis := range otherAxes {
		p1min, p1max := hb.Project(axis, sc)
		p2min, p2max := otherHB.Project(axis, other)
		if p2min > p1max {
			return false, engo.Point{}
		}
		var o float32
		if p1min < p2min {
			if p1max < p2max {
				o = p1max - p2min
			} else {
				o = p1max - p1min
			}
		} else {
			if p1max < p2max {
				o = p2max - p1min
			} else {
				o = p1max - p1min
			}
		}
		if o < overlap {
			overlap = o
			smallestAxis = axis
		}
	}
	return true, engo.Point{X: -1 * smallestAxis.X * overlap, Y: -1 * smallestAxis.Y * overlap}
}

// triangleArea computes the area of the triangle given by the three points
func triangleArea(p1, p2, p3 engo.Point) float32 {
	// Law of cosines states: (note a2 = math.Pow(a, 2))
	// a2 = b2 + c2 - 2bc*cos(alpha)
	// This ends in: alpha = arccos ((-a2 + b2 + c2)/(2bc))
	a := p1.PointDistance(p3)
	b := p1.PointDistance(p2)
	c := p2.PointDistance(p3)
	alpha := math.Acos((-math.Pow(a, 2) + math.Pow(b, 2) + math.Pow(c, 2)) / (2 * b * c))

	// Law of sines state: a / sin(alpha) = c / sin(gamma)
	height := (c / math.Sin(math.Pi/2)) * math.Sin(alpha)

	return (b * height) / 2
}

// CollisionComponent keeps track of the entity's collisions.
//
// Main tells the system to check all collisions against this entity.
//
// Group tells which collision group his entity belongs to.
//
// Extra is the allowed buffer for detecting collisions.
//
// Collides is all the groups this component collides with ORed together
type CollisionComponent struct {
	// if a.Main & (bitwise) b.Group, items can collide
	// if a.Main == 0, it will not loop for other items
	Main, Group CollisionGroup
	Extra       engo.Point
	Collides    CollisionGroup
}

// CollisionMessage is sent whenever a collision is detected by the CollisionSystem.
type CollisionMessage struct {
	Entity collisionEntity
	To     collisionEntity
	Groups CollisionGroup
}

// CollisionGroup is intended to be used in bitwise comparisons
// The user is expected to create a const ( a = 1 << iota \n b \n c etc)
// for the different kinds of collisions they hope to use
type CollisionGroup byte

// Type implements the engo.Message interface
func (CollisionMessage) Type() string { return "CollisionMessage" }

type collisionEntity struct {
	*ecs.BasicEntity
	*CollisionComponent
	*common.SpaceComponent
	*KindComponent
}

// CollisionSystem is a system that detects collisions between entities, sends a message if collisions
// are detected, and updates their SpaceComponent so entities cannot pass through Solids.
type CollisionSystem struct {
	// Solids, used to tell which collisions should be treated as solid by bitwise comparison.
	// if a.Main & b.Group & sys.Solids{ Collisions are treated as solid.  }
	Solids CollisionGroup

	entities []collisionEntity
}

// Add adds an entity to the CollisionSystem. To be added, the entity has to have a basic, collision, and space component.
func (c *CollisionSystem) Add(basic *ecs.BasicEntity, collision *CollisionComponent, space *common.SpaceComponent, kind *KindComponent) {
	c.entities = append(c.entities, collisionEntity{basic, collision, space, kind})
}

// Remove removes an entity from the CollisionSystem.
func (c *CollisionSystem) Remove(basic ecs.BasicEntity) {
	delete := -1
	for index, e := range c.entities {
		if e.BasicEntity.ID() == basic.ID() {
			delete = index
			break
		}
	}
	if delete >= 0 {
		c.entities = append(c.entities[:delete], c.entities[delete+1:]...)
	}
}

// Update checks the entities for collision with eachother. Only Main entities are check for collision explicitly.
// If one of the entities are solid, the SpaceComponent is adjusted so that the other entities don't pass through it.
func (c *CollisionSystem) Update(dt float32) {
	for i1, e1 := range c.entities {
		if e1.CollisionComponent.Main == 0 {
			//Main cannot pass bitwise comparison with any other items. Do not loop.
			continue // with other entities
		}

		var collided CollisionGroup

		for i2, e2 := range c.entities {
			if i1 == i2 {
				continue // with other entities, because we won't collide with ourselves
			}
			cgroup := e1.CollisionComponent.Main & e2.CollisionComponent.Group
			if cgroup == 0 {
				continue //Items are not in a comparible group dont bother
			}

			offsetA := engo.Point{X: e1.CollisionComponent.Extra.X / 2, Y: e1.CollisionComponent.Extra.Y / 2}
			offsetB := engo.Point{X: e2.CollisionComponent.Extra.X / 2, Y: e2.CollisionComponent.Extra.Y / 2}
			if overlaps, mtd := e1.Overlaps(*e2.SpaceComponent, offsetA, offsetB); overlaps {
				if cgroup&c.Solids > 0 {
					if e2.CollisionComponent.Main&e1.CollisionComponent.Group&c.Solids != 0 {
						//collision of equals (both main)
						e1.SpaceComponent.Position.X += mtd.X / 2
						e1.SpaceComponent.Position.Y += mtd.Y / 2
						e2.SpaceComponent.Position.X -= mtd.X / 2
						e2.SpaceComponent.Position.Y -= mtd.Y / 2
						//As the entities are no longer overlapping
						//e2 wont collide as main
						engo.Mailbox.Dispatch(CollisionMessage{Entity: e2, To: e1, Groups: cgroup})
					} else {
						//collision with one main
						e1.SpaceComponent.Position.X += mtd.X
						e1.SpaceComponent.Position.Y += mtd.Y
					}
				}

				//collided can now list the types of collision
				collided = collided | cgroup
				engo.Mailbox.Dispatch(CollisionMessage{Entity: e1, To: e2, Groups: cgroup})

				//update the position tracker of e1
				entityAABB := e1.SpaceComponent.AABB()
				offset := engo.Point{X: e1.CollisionComponent.Extra.X / 2, Y: e1.CollisionComponent.Extra.Y / 2}
				entityAABB.Min.X -= offset.X
				entityAABB.Min.Y -= offset.Y
				entityAABB.Max.X += offset.X
				entityAABB.Max.Y += offset.Y
			}
		}

		e1.CollisionComponent.Collides = collided
	}
}

// IsIntersecting tells if two engo.AABBs intersect.
func IsIntersecting(rect1 engo.AABB, rect2 engo.AABB) bool {
	if rect1.Max.X > rect2.Min.X && rect1.Min.X < rect2.Max.X && rect1.Max.Y > rect2.Min.Y && rect1.Min.Y < rect2.Max.Y {
		return true
	}

	return false
}

// MinimumTranslation tells how much an entity has to move to no longer overlap another entity.
func MinimumTranslation(rect1 engo.AABB, rect2 engo.AABB) engo.Point {
	mtd := engo.Point{}

	left := rect2.Min.X - rect1.Max.X
	right := rect2.Max.X - rect1.Min.X
	top := rect2.Min.Y - rect1.Max.Y
	bottom := rect2.Max.Y - rect1.Min.Y

	if left > 0 || right < 0 {
		return mtd
		//box doesn't intercept
	}

	if top > 0 || bottom < 0 {
		return mtd
		//box doesn't intercept
	}
	if math.Abs(left) < right {
		mtd.X = left
	} else {
		mtd.X = right
	}

	if math.Abs(top) < bottom {
		mtd.Y = top
	} else {
		mtd.Y = bottom
	}

	if math.Abs(mtd.X) < math.Abs(mtd.Y) {
		mtd.Y = 0
	} else {
		mtd.X = 0
	}

	return mtd
}
