package main

import (
	pmoolib "../pmoolib"
	"encoding/json"
	"io/ioutil"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/philippgille/gokv/file"
)

var chans map[string]chan []byte
var mode string = "files"

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
		start := time.Now()
		msg := <-ch
		elapsed := time.Since(start)
		if elapsed.Seconds() > 20 {
			ch <- msg
			c.Writer.Write([]byte{})
			return
		}
		c.Writer.Write(msg)
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

	r.GET("/find/:propname/:propval", func(c *gin.Context) {
		propname := c.Param("propname")
		propval := c.Param("propval")
		res := findObjects(propname, propval)
		out, _ := json.Marshal(res)
		c.Writer.Write(out)
	})

	r.GET("/operational", func(c *gin.Context) {

		c.Writer.Write([]byte("Database operational"))
	})

	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}

var KVstore file.Store
var err error

func findObjects(propname, propval string) []string {
	res := pmoolib.SearchObjects(propname, propval)
	return res
}

func StartKVstore() {
	options := file.DefaultOptions // Address: "localhost:6379", Password: "", DB: 0
	options.Directory = "objects"
	// Create client
	KVstore, err = file.NewStore(options)
	if err != nil {
		panic(err)
	}

}

func StoreObject(id string, m []byte) {
	if mode == "files" {
		ioutil.WriteFile("objects/"+id+".json", m, 0644)
	} else {
		err := KVstore.Set(id, m)
		if err != nil {
			panic(err)
		}
	}
}

func LoadObject(id string) []byte {
	if mode == "files" {
		data, _ := ioutil.ReadFile("objects/" + id + ".json")
		return data
	} else {
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
}

func DeleteObject(id string) {
	if mode == "files" {
		os.Remove("objects/" + id + ".json")
	} else {
		err := KVstore.Delete(id)
		if err != nil {
			panic(err)
		}
	}
}
