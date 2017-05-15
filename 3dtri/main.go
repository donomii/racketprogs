// Copyright 2014 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build darwin linux windows

// An app that draws a green triangle on a red background.
//
// Note: This demo is an early preview of Go 1.5. In order to build this
// program as an Android APK using the gomobile tool.
//
// See http://godoc.org/golang.org/x/mobile/cmd/gomobile to install gomobile.
//
// Get the basic example and use gomobile to build or install it on your device.
//
//   $ go get -d golang.org/x/mobile/example/basic
//   $ gomobile build golang.org/x/mobile/example/basic # will build an APK
//
//   # plug your Android device to your computer or start an Android emulator.
//   # if you have adb installed on your machine, use gomobile install to
//   # build and deploy the APK to an Android target.
//   $ gomobile install golang.org/x/mobile/example/basic
//
// Switch to your device or emulator to start the Basic application from
// the launcher.
// You can also run the application on your desktop by running the command
// below. (Note: It currently doesn't work on Windows.)
//   $ go install golang.org/x/mobile/example/basic && basic
package main

import "math/rand"
import "flag"
import "github.com/pkg/profile"
import (
	"encoding/binary"
	"encoding/json"
	"errors"
	"io/ioutil"
	"log"
	"net"
	"runtime"
	_ "strings"

	"github.com/donomii/glim"
	"golang.org/x/mobile/event/key"

	"golang.org/x/mobile/app"
	"golang.org/x/mobile/event/lifecycle"
	"golang.org/x/mobile/event/mouse"
	"golang.org/x/mobile/event/paint"
	"golang.org/x/mobile/event/size"
	"golang.org/x/mobile/exp/app/debug"
	"golang.org/x/mobile/exp/f32"
	"golang.org/x/mobile/exp/gl/glutil"
	"golang.org/x/mobile/gl"
	//"math"
	"fmt"
	"image"
	"os"
	"time"
	//"math/rand"
	_ "image/jpeg"
	_ "image/png"

	"github.com/donomii/sceneCamera"
)
import "github.com/go-gl/mathgl/mgl32"
import "golang.org/x/mobile/exp/sensor"

var old, new, prevDrawTriangles []float32
var oldColor, newColor, prevDrawColors []float32
var currDiff int64
var unique int
var saveNum int

var defaultFilePerms = 0777

var multiSample = uint(1) //Make the internal pixel buffer larger to enable multisampling and eventually GL anti-aliasing
var pixelTweakX = 0
var pixelTweakY = 0
var cursorX = 0
var cursorY = 0
var clientWidth = uint(800 * multiSample)
var clientHeight = uint(600 * multiSample)
var u8Pix []uint8
var (
	startDrawing    bool
	imageData       image.Image
	imageBounds     image.Rectangle
	images          *glutil.Images
	fps             *debug.FPS
	program         gl.Program
	position        gl.Attrib
	u_Texture       gl.Uniform
	a_TexCoordinate gl.Attrib
	colour          gl.Attrib
	buf             gl.Buffer
	tbuf            gl.Buffer

	screenWidth  int
	screenHeight int

	green        float32
	red          float32
	blue         float32
	touchX       float32
	touchY       float32
	selection    int
	gallery      []string
	reCalcNeeded bool
	prevTime     int64
)

var scanOn = true
var triBuff []byte
var vTrisf map[string][]float32
var vBuffs map[string]gl.Buffer

var vCols map[string][]byte
var vColsf map[string][]float32
var vColBuffs map[string]gl.Buffer

var trans mgl32.Mat4
var theatreCamera mgl32.Mat4
var transU gl.Uniform
var recursion int = 4
var threeD bool = false
var polyCount int
var clock float32 = 0.0
var Tex gl.Texture
var sceneCam *sceneCamera.SceneCamera
var outputDir string = "./"
var pixDir string = "./"
var checkpointDir string = "./"

var viewAngle [3]float32

var texAlignData = f32.Bytes(binary.LittleEndian,
	0.0, 0.0, // top left
	0.0, 1.0, // top left
	1.0, 0.0, // top left
	0.0, 1.0, // top left
	1.0, 1.0, // top left
	1.0, 0.0, // top left
)

var triangleDataRaw = []float32{
	-1.0, 1.0, 0.0, // top left
	-1.0, -1.0, 0.0, // bottom left
	1.0, 1.0, 0.0, // bottom right
}

var colorDataRaw = []float32{
	0.0, 0.0, 0.0, 1.0,
	0.0, 0.0, 0.0, 1.0,
	0.0, 0.0, 0.0, 1.0,
}

func do_profile() {
	//defer profile.Start(profile.MemProfile).Stop()
	//defer profile.Start(profile.TraceProfile).Stop()
	defer profile.Start(profile.CPUProfile).Stop()
	time.Sleep(60 * time.Second)
}

func main() {
	DrawRequestCh = make(chan DrawRequest, 10)
	DrawResultCh = make(chan DrawResult, 10)
	pixDir = fmt.Sprintf("%v/%v", outputDir, "pix")
	checkpointDir = fmt.Sprintf("%v/%v", outputDir, "checkpoints")

	os.MkdirAll(pixDir, 0777)
	os.MkdirAll(checkpointDir, 0777)

	resumeFile := flag.String("resume", "", "File containing resume data")
	flag.Parse()

	log.Printf("Starting main...")

	InitOptimiser()
	if *resumeFile != "" {
		old, oldColor = ReadStateFromFile(*resumeFile)
	}

	sceneCam = sceneCamera.New()
	runtime.GOMAXPROCS(2)
	app.Main(func(a app.App) {
		log.Printf("Starting app...")
		reCalcNeeded = true
		var glctx gl.Context
		var sz size.Event
		sensor.Notify(a)
		theatreCamera = mgl32.Ident4()
		trans = mgl32.Ident4()
		trans = trans.Mul4(mgl32.Translate3D(0.0, 0.0, 1.0))
		if threeD {
			trans = compose(trans, mgl32.Scale3D(1.6, 0.6, 1.0))
		}
		theatreCamera = mgl32.LookAt(0.0, 0.0, 0.6, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
		for e := range a.Events() {
			switch e := a.Filter(e).(type) {
			case sensor.Event:
				delta := e.Timestamp - prevTime
				prevTime = e.Timestamp
				scale := float32(36000000.0 / float32(delta))
				sceneCam.ProcessEvent(e)

				var sora_vec mgl32.Vec3 //The real sora
				sora_vec = mgl32.Vec3{float32(e.Data[1]) / scale, -float32(e.Data[0]) / scale, float32(-e.Data[2]) / scale / float32(3.14)}

				if threeD {
				} else {
					theatreCamera = theatreCamera.Mul4(mgl32.Translate3D(sora_vec[1]/scale, -sora_vec[0]/scale, 0.0))
				}
			case lifecycle.Event:
				switch e.Crosses(lifecycle.StageVisible) {
				case lifecycle.CrossOn:
					glctx, _ = e.DrawContext.(gl.Context)
					onStart(glctx)
					sensor.Enable(sensor.Gyroscope, 10*time.Millisecond)
					a.Send(paint.Event{})
				case lifecycle.CrossOff:
					sensor.Disable(sensor.Gyroscope)
					onStop(glctx)
					glctx = nil
				}
			case size.Event:
				sz = e
				reCalcNeeded = true
				//reDimBuff(int(sz.WidthPx),int(sz.HeightPx))
				touchX = float32(sz.WidthPx / 2)
				touchY = float32(sz.HeightPx * 9 / 10)
				if sz.Orientation == size.OrientationLandscape {
					//threeD = true
				} else {
					threeD = false
				}
			case paint.Event:
				if glctx == nil || e.External {
					// As we are actively painting as fast as
					// we can (usually 60 FPS), skip any paint
					// events sent by the system.
					continue
				}

				onPaint(glctx, sz)
				a.Publish()
				// Drive the animation by preparing to paint the next frame
				// after this one is shown.
				a.Send(paint.Event{})
			case key.Event:
			case mouse.Event:
				//log.Printf("%v", e)
				//cursorX = int(e.X/2)
				//cursorY = int(e.Y)
			}
		}
	})
}

var connectCh chan bool

func externalIP() (string, error) {
	ifaces, err := net.Interfaces()
	if err != nil {
		return "", err
	}
	for _, iface := range ifaces {
		if iface.Flags&net.FlagUp == 0 {
			continue // interface down
		}
		if iface.Flags&net.FlagLoopback != 0 {
			continue // loopback interface
		}
		addrs, err := iface.Addrs()
		if err != nil {
			return "", err
		}
		for _, addr := range addrs {
			var ip net.IP
			switch v := addr.(type) {
			case *net.IPNet:
				ip = v.IP
			case *net.IPAddr:
				ip = v.IP
			}
			if ip == nil || ip.IsLoopback() {
				continue
			}
			ip = ip.To4()
			if ip == nil {
				continue // not an ipv4 address
			}
			return ip.String(), nil
		}
	}
	return "", errors.New("are you connected to the network?")
}

func reDimBuff(x, y int) {
	log.Printf("Resizing screen to %v, %v", x, y)
	screenWidth = (pixelTweakX + x) * int(multiSample)
	clientWidth = uint(pixelTweakX+x) * multiSample
	screenHeight = (pixelTweakY + y) * int(multiSample)
	clientHeight = uint(pixelTweakY+y) * multiSample
	dim := clientWidth * clientHeight * 4
	u8Pix = make([]uint8, dim, dim)
}

var fname string

var refImage []byte
var rx int = 10
var ry int = 10

func UploadBufferData(glctx gl.Context, b gl.Buffer, data []byte) {
	glctx.BindBuffer(gl.ARRAY_BUFFER, b)
	//log.Printf("Data: %v elements for buffer %v\n", len(data), b)
	glctx.BufferData(gl.ARRAY_BUFFER, data, gl.DYNAMIC_DRAW)
}

func onStart(glctx gl.Context) {
	scale = 0.1
	rand.Seed(time.Now().Unix())
	log.Printf("Onstart callback...")

	//For some reason, the framework feeds us the wrong window size at start.  Luckily we can query the context directly
	screenWidth, screenHeight = glim.ScreenSize(glctx)
	log.Printf("Start viewport: %v,%v\n", screenWidth, screenHeight)
	reCalcNeeded = true
	//reDimBuff(int(screenWidth),int(screenHeight))

	if len(os.Args) > 1 {
		fname = os.Args[1]
		log.Println("Loading file: ", fname)
		refImage, rx, ry = glim.LoadImage(fname)
		log.Printf("Loaded reference image %v:%v\n", rx, ry)
	} else {
		log.Fatal("please give a reference image on the command line")
	}
	var err error
	program, err = glutil.CreateProgram(glctx, vertexShader, fragmentShader)
	if err != nil {
		log.Printf("error creating GL program: %v", err)
		os.Exit(1)
		return
	}

	position = glctx.GetAttribLocation(program, "position")
	a_TexCoordinate = glctx.GetAttribLocation(program, "a_TexCoordinate")
	transU = glctx.GetUniformLocation(program, "transform")
	u_Texture = glctx.GetUniformLocation(program, "u_Texture")
	//fmt.Println("Creating buffers")

	buf = glctx.CreateBuffer()
	triangleData := f32.Bytes(binary.LittleEndian, new...)
	UploadBufferData(glctx, buf, triangleData)

	tbuf = glctx.CreateBuffer()
	colorData := f32.Bytes(binary.LittleEndian, newColor...)
	UploadBufferData(glctx, tbuf, colorData)

	Tex = glctx.CreateTexture()
	glctx.BindTexture(gl.TEXTURE_2D, Tex)

	glctx.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
	glctx.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
}

func onStop(glctx gl.Context) {
	log.Printf("Stopping...")
	os.Exit(0)
	//glctx.DeleteProgram(program)
	//glctx.DeleteBuffer(buf)
	//fps.Release()
	//images.Release()
}

func transpose(m mgl32.Mat4) mgl32.Mat4 {
	var r mgl32.Mat4
	for i, v := range []int{0, 4, 8, 12, 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15} {
		r[i] = m[v]
	}
	//fmt.Println(r)
	return r
}

func clampAll(data []float32) {
	for i, v := range data {
		if v < -1.0 {
			data[i] = -1.0
		}
		if v > 1.0 {
			data[i] = 1.0
		}
	}
}

func clampAll01(data []float32) {
	for i, v := range data {
		if v < 0 {
			data[i] = 0
		}
		if v > 1.0 {
			data[i] = 1.0
		}
	}
}

func sumArray(a []float32) float32 {
	ret := float32(0)
	for _, v := range a {
		ret = ret + v
	}
	return ret
}

func loadPic(fname string) image.Image {
	reader, err := os.Open(fname)
	if err != nil {
		panic(fmt.Sprintf("loadPic: %v %v", fname, err))
	}
	defer reader.Close()
	m, _, err1 := image.Decode(reader)
	if err1 != nil {
		panic(fmt.Sprintf("loadPic: %v %v", fname, err1))
	}
	return m
}

func readStateFromFile(filename string) ([]float32, []float32) {
	jdata, _ := ioutil.ReadFile(filename)
	var out StateExport
	json.Unmarshal(jdata, &out)
	return out.Points, out.Colours
}

func clearScreen(glctx gl.Context) {
	glctx.ClearColor(0, 0, 0, 1.0)
	glctx.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
}

func doDraw(glctx gl.Context, new, newColor []float32) {
	triangleData := f32.Bytes(binary.LittleEndian, new...)
	UploadBufferData(glctx, buf, triangleData)

	colorData := f32.Bytes(binary.LittleEndian, newColor...)
	UploadBufferData(glctx, tbuf, colorData)

	//glctx.Enable(gl.BLEND)
	//glctx.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	//glctx.Enable( gl.DEPTH_TEST );
	//glctx.DepthFunc( gl.LEQUAL );
	//glctx.DepthMask(true)
	//glctx.ClearColor(newColor[0],newColor[1],newColor[2],255)
	glctx.ClearColor(0, 0, 0, 1.0)
	glctx.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
	glctx.UseProgram(program)

	glctx.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
	glctx.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)

	var view mgl32.Mat4
	view = compose(theatreCamera, trans)
	glctx.UniformMatrix4fv(transU, view[0:16])

	glctx.BindBuffer(gl.ARRAY_BUFFER, buf)
	glctx.EnableVertexAttribArray(position)
	glctx.VertexAttribPointer(position, 3, gl.FLOAT, false, 0, 0)

	glctx.BindBuffer(gl.ARRAY_BUFFER, tbuf)
	glctx.EnableVertexAttribArray(a_TexCoordinate)
	glctx.VertexAttribPointer(a_TexCoordinate, 4, gl.FLOAT, false, 0, 0)

	glctx.Viewport(0, 0, rx, ry)
	glctx.DrawArrays(gl.TRIANGLES, 0, len(new)/3)

	glctx.DisableVertexAttribArray(position)
	glctx.DisableVertexAttribArray(a_TexCoordinate)
}

type DrawRequest struct {
	Triangles, Colours []float32
}

type DrawResult struct {
	Render []byte
}

var DrawRequestCh chan DrawRequest
var DrawResultCh chan DrawResult

var lastTris, lastCols []float32

func onPaint(glctx gl.Context, sz size.Event) {
	//log.Println("Starting paint")
	unique = unique + 1
	if unique%2 == 1 {
		doDraw(glctx, lastTris, lastCols)
		return
	}

	prevDrawColors = newColor
	prevDrawTriangles = new

	//Wait until the graphics card has finished drawing
	glctx.Flush()
	glctx.Finish()

	//Fetch screen from graphics card
	renderPix := glim.CopyScreen(glctx, rx, ry)

	//log.Println("Sending result to optimiser")
	DrawResultCh <- DrawResult{renderPix}
	//log.Println("Fetching request from optimiser")
	req := <-DrawRequestCh
	doDraw(glctx, req.Triangles, req.Colours)
	lastTris = req.Triangles
	lastCols = req.Colours
	glctx.Flush()
	glctx.Finish()
}

const vertexShader = `#version 100
precision mediump float;
uniform mat4 transform;

attribute vec4 a_TexCoordinate; // Per-vertex texture coordinate information we will pass in.
attribute vec4 position;
varying vec4 color;

void main() {
        gl_Position = transform * position;
        color = a_TexCoordinate;
}
`

const fragmentShader = `#version 100
precision mediump float;
varying vec4 color;
void main() {
    gl_FragColor = color;
}
`

func compose(a, b mgl32.Mat4) mgl32.Mat4 {
	return a.Mul4(b)
}

func compose3(a, b, c mgl32.Mat4) mgl32.Mat4 {
	t := b.Mul4(c)
	return a.Mul4(t)
}

func checkGlErr(glctx gl.Context) {
	err := glctx.GetError()
	if err > 0 {
		fmt.Printf("GLerror: %v\n", err)
		panic("GLERROR")
	}
}
