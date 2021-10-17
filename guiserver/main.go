package main

import (
	"log"
	"sync"

	"github.com/gin-gonic/gin"
	"github.com/go-p5/p5"
	"github.com/mattn/anko/env"
	"github.com/mattn/anko/vm"
	"image/color"
)

var thunkList []func() = []func(){}
var mu sync.Mutex

func col(r, g, b, a uint8) color.RGBA {
	return color.RGBA{r, g, b, a}
}

func fill(r, g, b, a uint8) {
	p5.Fill(color.RGBA{r, g, b, a})
}

func stroke(r, g, b, a uint8) {
	p5.Stroke(color.RGBA{r, g, b, a})
}

func background(r, g, b, a uint8) {
	p5.Background(color.RGBA{r, g, b, a})
}

func addThunk(thunk func()) {
	mu.Lock()
	thunkList = append(thunkList, thunk)
	mu.Unlock()
}

func clear() {
	thunkList = []func(){}

}

func main() {

	e := env.NewEnv()

	err := e.Define("stroke", stroke)
	err = e.Define("background", background)
	err = e.Define("strokewidth", p5.StrokeWidth)
	err = e.Define("fill", fill)
	err = e.Define("ellipse", p5.Ellipse)
	err = e.Define("arc", p5.Arc)
	err = e.Define("rectangle", p5.Rect)
	err = e.Define("triangle", p5.Triangle)
	err = e.Define("color", col)
	err = e.Define("clear", clear)
	err = e.Define("textsize", p5.TextSize)
	err = e.Define("text", p5.Text)
	if err != nil {
		log.Printf("define error: %v\n", err)
	}

	r := gin.Default()

	r.GET("/command/:str", func(c *gin.Context) {
		script := c.Param("str")
		addThunk(func(s string) func() {
			return func() {

				//log.Println("Drawing", script)
				_, err = vm.Execute(e, nil, s)
				if err != nil {
					log.Printf("execute error: %v while executing %v\n", err, s)
				}

			}
		}(script))

		c.Writer.Write([]byte("Command loaded"))
	})

	r.POST("/command/i", func(c *gin.Context) {

	})

	go r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")

	p5.Run(setup, draw)
}

func setup() {
	p5.Canvas(800, 800)
	p5.Background(color.Gray{Y: 220})
}

func draw() {
	for _, f := range thunkList {
		f()
	}
}
