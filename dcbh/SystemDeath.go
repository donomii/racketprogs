package main

import (
	"fmt"
	"github.com/EngoEngine/ecs"
	"github.com/EngoEngine/engo"
	"github.com/EngoEngine/engo/common"
	"log"
)

type DeathSystem struct {
	world  *ecs.World
	Score  int
	Player *Guy
}

type PlayerStateChangeMessage struct {
	ecs.BasicEntity
	Player *Guy
	Score  int
}

func (m PlayerStateChangeMessage) Type() string {
	return "PlayerStateChangeMessage"
}

func (d *DeathSystem) New(w *ecs.World) {

	d.world = w
	// Subscribe to ScoreMessage
	engo.Mailbox.Listen("CollisionMessage", func(message engo.Message) {
		//log.Printf("Received message: %v", message.(common.CollisionMessage))
		_, isCollision := message.(common.CollisionMessage)
		colMess := message.(common.CollisionMessage)

		if isCollision {
			if colMess.Entity.Name == "Player" {
				player := colMess.Entity
				d.Player.Damage(1)
				engo.Mailbox.Dispatch(PlayerStateChangeMessage{BasicEntity: ecs.NewBasic(), Player: d.Player})
				log.Printf("Collsition: %+v, %+v", player.BasicEntity, colMess.To.BasicEntity)

				d.Purge(*colMess.To.GetBasicEntity())
				if d.Player.isDead() {
					log.Printf("Player is dead")
					engo.SetSceneByName("Menu", false)
				}
			} else if colMess.To.Name == "Player" {
				player := colMess.To
				d.Player.Damage(1)
				engo.Mailbox.Dispatch(PlayerStateChangeMessage{BasicEntity: ecs.NewBasic(), Player: d.Player})
				log.Printf("Collsition: %+v, %+v", player.BasicEntity, colMess.Entity.BasicEntity)

				d.Purge(*colMess.Entity.GetBasicEntity())
				if d.Player.isDead() {
					log.Printf("Player is dead")
					engo.SetSceneByName("Menu", false)
					//os.Exit(0)
				}

			} else {
				if colMess.To.BasicEntity.Name == "enemy" && colMess.Entity.BasicEntity.Name == "bullet" {
					d.Score++
					//log.Printf("Collision: %+v, %+v", colMess.Entity.BasicEntity, colMess.To.BasicEntity)
					log.Printf("Score: %+v", d.Score)
					log.Printf("Hit points: %+v", d.Player.GetHitPoints())
					engo.Mailbox.Dispatch(HUDTextMessage{
						BasicEntity: ecs.NewBasic(),
						Text:        fmt.Sprintf("%+v kills", d.Score),
					})
					engo.Mailbox.Dispatch(PlayerStateChangeMessage{BasicEntity: ecs.NewBasic(), Player: d.Player, Score: d.Score})

					d.Purge(*colMess.Entity.GetBasicEntity())
					d.Purge(*colMess.To.GetBasicEntity())
				}
			}
		}
	})

	engo.Mailbox.Listen("AgeDeathMessage", func(message engo.Message) {
		//log.Printf("Received message: %v", message.(AgeDeathMessage))
		d.Purge(message.(AgeDeathMessage).Entity)
	})

}

func (f *DeathSystem) Remove(basic ecs.BasicEntity) {

}

func (f *DeathSystem) Purge(e ecs.BasicEntity) {

	for _, system := range f.world.Systems() {
		switch system.(type) {

		default:
			system.Remove(e)
		}
	}
}

func (*DeathSystem) Update(float32) {}
