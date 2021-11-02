package main

import (
	"log"
	"fmt"
		"net/http"
	
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

func mytext(t string, a,b,c,d float64){
	p5.Text(t,a,b+d)
}
func logErr(err error) {
	if err != nil {
		log.Printf(" error: %v\n", err)
	}
}
func main() {

	e := env.NewEnv()

	logErr(e.Define("stroke", stroke))
	logErr( e.Define("background", background))
	logErr( e.Define("strokewidth", p5.StrokeWidth))
	logErr( e.Define("fill", fill))
	logErr( e.Define("ellipse", p5.Ellipse))
	logErr( e.Define("arc", p5.Arc))
	logErr( e.Define("rectangle", p5.Rect))
	logErr( e.Define("triangle", p5.Triangle))
	logErr( e.Define("color", col))
	logErr( e.Define("clear", clear))
	logErr( e.Define("textsize", p5.TextSize))
	logErr( e.Define("text", mytext))


	r := gin.Default()
	r.GET("/immediate/clear", func(c *gin.Context) {
		clear()
	})
	r.GET("/command/:str", func(c *gin.Context) {
		script := c.Param("str")
		go addThunk(func(s string) func() {
			return func() {

				//log.Println("Drawing", script)
				_, err := vm.Execute(e, nil, s)
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

var lastMouse string
func draw() {



	if p5.Event.Mouse.Pressed {
		if p5.Event.Mouse.Buttons.Contain(p5.ButtonLeft) {
			p5.Stroke(color.Black)
			p5.Fill(color.RGBA{R: 255, A: 255})
	}
	resp, err := http.Get(fmt.Sprintf("http://localhost:8081/click?x=%v&y=%v&action=move",p5.Event.Mouse.Position.X,p5.Event.Mouse.Position.Y ))
	if err == nil {
		defer resp.Body.Close()
	}
	if lastMouse != "pressed" {
		resp, err := http.Get(fmt.Sprintf("http://localhost:8081/click?x=%v&y=%v&action=press",p5.Event.Mouse.Position.X,p5.Event.Mouse.Position.Y ))
		if err == nil {
			defer resp.Body.Close()
		}
	}
} else {
	if lastMouse == "pressed" {
	


		    resp, err := http.Get(fmt.Sprintf("http://localhost:8081/click?x=%v&y=%v&action=release",p5.Event.Mouse.Position.X,p5.Event.Mouse.Position.Y ))
		    if err == nil {
				defer resp.Body.Close()
		    }
		}
	}



		if p5.Event.Mouse.Pressed {
			lastMouse = "pressed"
		} else {
			lastMouse=""
		}


		    

		


	for _, f := range thunkList {
		f()
	}
}
