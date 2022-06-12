package main

import (
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	"log"
)

type DeathSystem struct {
	world *ecs.World
}

func (d *DeathSystem) New(w *ecs.World) {
	d.world = w
	// Subscribe to ScoreMessage
	engo.Mailbox.Listen("CollisionMessage", func(message engo.Message) {
		_, isCollision := message.(common.CollisionMessage)
		colMess := message.(common.CollisionMessage)

		if isCollision {
			if colMess.Entity.Name == "Player" {
				log.Printf("Collsition: %+v, %+v", colMess.Entity.BasicEntity, colMess.To.BasicEntity)
				log.Println("DEAD")
				d.Purge(*colMess.To.GetBasicEntity())
			} else {
				if colMess.To.BasicEntity.Name == "enemy" && colMess.Entity.BasicEntity.Name == "bullet" {
					log.Printf("Collision: %+v, %+v", colMess.Entity.BasicEntity, colMess.To.BasicEntity)
					d.Purge(*colMess.Entity.GetBasicEntity())
					d.Purge(*colMess.To.GetBasicEntity())
				}
			}
		}
	})

	engo.Mailbox.Listen("AgeDeathMessage", func(message engo.Message) {
		d.Purge(message.(AgeDeathMessage).Entity)
	})

}

func (f *DeathSystem) Remove(basic ecs.BasicEntity) {

}

func (f *DeathSystem) Purge(e ecs.BasicEntity) {

	for _, system := range f.world.Systems() {
		switch system.(type) {
		case *DeathSystem:
		default:
			system.Remove(e)
		}
	}
}

func (*DeathSystem) Update(float32) {}
