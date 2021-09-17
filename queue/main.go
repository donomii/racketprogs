package main

import (
	"io/ioutil"

	"github.com/gin-gonic/gin"
)

func main() {
	Q := make(chan []byte, 1000)
	r := gin.Default()
	r.GET("/subscribe/:topic", func(c *gin.Context) {
		c.Writer.Write(<-Q)
	})
	r.POST("/publish/:topic", func(c *gin.Context) {
		data, _ := ioutil.ReadAll(c.Request.Body)
		Q <- data
	})
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
