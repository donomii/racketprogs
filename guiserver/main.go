package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"sync"
	"time"

	"image/color"

	"github.com/gin-gonic/gin"
	"github.com/go-p5/p5"
	"github.com/mattn/anko/env"
	"github.com/mattn/anko/vm"
)

var thunkList []func() = []func(){}
var newThunkList []func() = []func(){}
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
	newThunkList = append(newThunkList, thunk)
	mu.Unlock()
}

func clearList() {
	mu.Lock()
	fmt.Println("Cleared render list")
	thunkList = []func(){}
	for _, thunk := range newThunkList {
		thunkList = append(thunkList, thunk)
	}
	newThunkList = []func(){}
	mu.Unlock()
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
	//err = e.Define("clearList", clearList)
	err = e.Define("textsize", p5.TextSize)
	err = e.Define("text", p5.Text)
	err = e.Define("exit", os.Exit)
	if err != nil {
		log.Printf("define error: %v\n", err)
	}

	r := gin.Default()
	//r := gin.New()

	r.GET("/command/:str", func(c *gin.Context) {
		script := c.Param("str")
		fmt.Println("Adding thunk ", script)
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

	r.GET("/immediate/commit", func(c *gin.Context) {
		clearList()
		c.Writer.Write([]byte("Made command list active"))
	})

	r.POST("/command/i", func(c *gin.Context) {

	})

	go r.Run(":8081") // listen and serve on 0.0.0.0:8081 (for windows "localhost:8081")

	p5.Run(setup, draw)
}

func setup() {
	p5.Canvas(800, 800)
	p5.Background(color.Gray{Y: 220})
}

var MouseDown bool

func draw() {
	t := time.Now()
	//We don't need to finish event processing before rendering
	func() {
		log.Printf("%+v\n", p5.Event)
		switch {

		case p5.Event.Mouse.Pressed:
			if !MouseDown {
				log.Printf(fmt.Sprintf("http://localhost:8001/event/q?name=buttondown&id=1&x=%v&y=%v",
					p5.Event.Mouse.Position.X,
					p5.Event.Mouse.Position.Y))
				http.Get(fmt.Sprintf("http://localhost:8001/event/q?name=buttondown&id=1&x=%v&y=%v", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y))
				MouseDown = true
			} else {
				//http.Get(fmt.Sprintf("http://localhost:8001/event/q?name=position&id=1&x=%v&y=%v", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y))
			}
		case !p5.Event.Mouse.Pressed:
			if MouseDown {
				log.Printf(fmt.Sprintf("http://localhost:8001/event/q?name=buttonup&id=1&x=%v&y=%v",
					p5.Event.Mouse.Position.X,
					p5.Event.Mouse.Position.Y))
				http.Get(fmt.Sprintf("http://localhost:8001/event/q?name=buttonup&id=1&x=%v&y=%v", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y))
				MouseDown = false
			} else {
				//http.Get(fmt.Sprintf("http://localhost:8001/event/q?name=position&id=1&x=%v&y=%v", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y))
			}
		default:
			//http.Get(fmt.Sprintf("http://localhost:8001/event/q?name=position&id=1&x=%v&y=%v", p5.Event.Mouse.Position.X, p5.Event.Mouse.Position.Y))
		}
	}()

	fmt.Printf("Thunks: %v, newthunks: %v\n", thunkList, newThunkList)

	for _, f := range thunkList {
		f()
	}

	fmt.Printf("Rendered %v thunks in %v milliseconds\n", len(thunkList), t.Sub(time.Now()).Milliseconds())
}
