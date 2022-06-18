package main

import (
	"fmt"
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	"log"
)

type DeathSystem struct {
	world     *ecs.World
	Score     int
	HitPoints int
}

func (d *DeathSystem) New(w *ecs.World) {
	d.world = w
	// Subscribe to ScoreMessage
	engo.Mailbox.Listen("CollisionMessage", func(message engo.Message) {
		_, isCollision := message.(common.CollisionMessage)
		colMess := message.(common.CollisionMessage)

		if isCollision {
			if colMess.Entity.Name == "Player" {
				player := colMess.Entity
				d.HitPoints--
				log.Printf("Collsition: %+v, %+v", player.BasicEntity, colMess.To.BasicEntity)
				log.Println("DEAD")
				d.Purge(*colMess.To.GetBasicEntity())
			} else {
				if colMess.To.BasicEntity.Name == "enemy" && colMess.Entity.BasicEntity.Name == "bullet" {
					d.Score++
					//log.Printf("Collision: %+v, %+v", colMess.Entity.BasicEntity, colMess.To.BasicEntity)
					log.Printf("Score: %+v", d.Score)
					log.Printf("Hit points: %+v", d.HitPoints)
					engo.Mailbox.Dispatch(HUDTextMessage{
						BasicEntity: ecs.NewBasic(),
						Text:        fmt.Sprintf("Score: %+v", d.Score),
					})

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
