package main

import (
	"io/ioutil"

	"github.com/gin-gonic/gin"
	"github.com/philippgille/gokv/badgerdb"
)

var chans map[string]chan []byte

func GetChan(key string) chan []byte {
	ch, ok := chans[key]
	if !ok {
		ch = make(chan []byte, 1000)
		chans[key] = ch
	}
	return ch
}

func main() {
	StartKVstore()
	chans = make(map[string]chan []byte)

	r := gin.Default()

	r.GET("/subscribe/:topic", func(c *gin.Context) {
		key := c.Param("topic")
		ch := GetChan(key)
		c.Writer.Write(<-ch)
	})
	r.POST("/publish/:topic", func(c *gin.Context) {
		data, _ := ioutil.ReadAll(c.Request.Body)
		key := c.Param("topic")
		ch := GetChan(key)
		ch <- data
	})

	r.POST("/store/:key", func(c *gin.Context) {
		data, _ := ioutil.ReadAll(c.Request.Body)
		key := c.Param("key")
		StoreObject(key, data)
	})

	r.GET("/fetch/:key", func(c *gin.Context) {
		key := c.Param("key")
		c.Writer.Write(LoadObject(key))
	})

	r.GET("/operational", func(c *gin.Context) {

		c.Writer.Write([]byte("Database operational"))
	})

	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}

var KVstore badgerdb.Store
var err error

func StartKVstore() {
	options := badgerdb.DefaultOptions // Address: "localhost:6379", Password: "", DB: 0

	// Create client
	KVstore, err = badgerdb.NewStore(options)
	if err != nil {
		panic(err)
	}

}

func StoreObject(id string, m []byte) {
	err := KVstore.Set(id, m)
	if err != nil {
		panic(err)
	}
}

func LoadObject(id string) []byte {
	retrievedVal := new([]byte)
	found, err := KVstore.Get(id, retrievedVal)
	if err != nil {
		panic(err)
	}
	if !found {
		panic("Value not found")
	}
	return *retrievedVal
}

func DeleteObject(id string) {
	err := KVstore.Delete(id)
	if err != nil {
		panic(err)
	}
}
