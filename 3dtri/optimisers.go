//This package contains all the routines to set up and manipulate the "genome" that we are trying to optimise.  It receives calls from the gui:  InitOptimiser, Process, and StopOptimiser
package main

import (
	//"math"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"time"

	"github.com/donomii/glim"
	"github.com/go-gl/mathgl/mgl32"
)

//Contains the 'global' render data
type RenderState struct {
	RenderPix    []byte
	RefImages    [][]byte
	DiffBuff     []byte
    Views        []View
}

//Holds all the data to import/export
type StateExport struct {
	Points          []float32   //Triangle data (or other shapes)
	Colours         []float32   //Vertex colours
    Fitness         int64       //Current difference in fit from the reference picture
    Views           []View
}

//Contains the input photo + control data for one "view" of the scene
//
//Will eventually hold camera angles and translation as well
type View struct {
    Pix         []byte  //The input photo
    Width       int     //Width, in pixels
    Height      int     //Height in pixels
    Angle       euler   //The euler angles to position the camera, looking towards the origin
}

var state RenderState

type euler []float32

func InitOptimiser() {
	scale = 1.0
	rand.Seed(time.Now().Unix())
	log.Printf("Initialiser callback...")
	old = make([]float32, 0)
	new = make([]float32, 0)
	oldColor = make([]float32, 0)
	newColor = make([]float32, 0)
	i := 0
	var x, y float32
	for x = -1.0; x < 1.0; x = x + 0.3 {
		for y = -1.0; y < 1.0; y = y + 0.3 {
			old = append(old, triangleDataRaw...)
			new = append(new, triangleDataRaw...)
			oldColor = append(oldColor, colorDataRaw...)
			newColor = append(newColor, colorDataRaw...)

			//old[i] =rand.Float32()*2.0-1.0 // v+ rand.Float32()*0.2*scale-0.1*scale
			//x :=rand.Float32()*0.5-0.25 // v+ rand.Float32()*0.2*scale-0.1*scale
			//y :=rand.Float32()*0.5-0.25 // v+ rand.Float32()*0.2*scale-0.1*scale
			old[i] = x
			old[i+1] = y
			old[i+2] = 1.0

			oldColor[i] = x
			oldColor[i+1] = y
			oldColor[i+2] = 1.0

			old[i+3] = x + 0.3
			old[i+4] = y
			old[i+5] = -1.0

			old[i+6] = x
			old[i+7] = y + 0.3
			old[i+8] = 0.0
			i = i + 9
		}
	}

/*
	if len(os.Args) > 1 {
		fname = os.Args[1]
		log.Println("Loading file: ", fname)
		refImage, rx, ry = glim.LoadImage(fname)
		log.Printf("Loaded reference image %v:%v\n", rx, ry)
	} else {
		log.Fatal("please give a reference image on the command line")
	}
	state.RefImage = refImage
*/

	//Prepare a blank byte array to hold the difference pic
	diffBuff := make([]byte, len(state.RenderPix))
	for i, _ := range diffBuff {
		diffBuff[i] = 0
	}

	state.DiffBuff = diffBuff
	cameraAngles := []euler{
		euler{0.0, 0.0, 0.0},
		euler{0.0, 3.14159 / 2.0, 0.0},
		euler{0.0, -3.14159 / 2.0, 0.0},
		euler{3.14159 / 2.0, 0.0, 0.0},
		euler{-3.14159 / 2.0, 0.0, 0.0},
		euler{0.0, 3.14159, 0.0},
	}
	files := []string{
		"input/front.png",
		"input/rside.png",
		"input/lside.png",
		"input/top.png",
		"input/bottom.png",
		"input/back.png",
	}
	for i, fname := range files {
		refImage, x, y := glim.LoadImage(fname)
		state.RefImages = append(state.RefImages, refImage)
        rx = x
        ry = y
        state.Views = append(state.Views, View{refImage, rx, ry, cameraAngles[i]})
	}

	go OptimiserWorker()

	currDiff = 999999999999999
	startDrawing = true
}

func StopOptimiser() {
	log.Printf("Stopping...")
	//Save your data
}

var mutateIndex int
var mutateColIndex int = 1
var dump bool
var scale float32

// Abs64 returns the absolute value of x.
func Abs64(x int64) int64 {
	if x < 0 {
		return -x
	}
	return x
}

func copyBytes(a, b []float32) {
	for i, _ := range b {
		a[i] = b[i]
	}
}

// Abs32 returns the absolute value of x.
func Abs32(x uint32) uint32 {
	if x < 0 {
		return -x
	}
	return x
}

func CalcDiff(renderPix, refImage, diffBuff []byte) int64 {
	diff := int64(0)
	//Calculate the difference between each picture by comparing the pixels, skipping the alpha channel
	//for i, v := range renderPix {
	for y := 0; y < ry; y++ {
		for x := 0; x < rx; x++ {
			for z := 0; z < 3; z++ {
				i := (x+y*rx)*4 + z
				//ii := (x + (ry-y-1)*rx) * 4 +z
				//if (i+1) % 4 == 0 || (i) % 4 == 0 || (i+3) % 4 == 0 {
				//if (i+1) % 4 == 0  {
				//log.Printf("renderAlpha: %v, refAlpha: %v\n", renderPix[i], refImage[i])
				//diffBuff[i] = 255
				//renderPix[i]=255
				//continue
				//}
				//fmt.Println(ii, ry, y)

				d := Abs64(int64(renderPix[i]) - int64(refImage[i]))
				if dump {
					log.Printf("%v - %v = %v\n", renderPix[i], refImage[i], d)
				}
				diff = diff + d
				//diffBuff[i] = byte(uint8(d)) //FIXME
			}
		}
	}
	return diff
}

func ReadStateFromFile(filename string) ([]float32, []float32, int64) {
	jdata, _ := ioutil.ReadFile(filename)
	var out StateExport
	json.Unmarshal(jdata, &out)
	return out.Points, out.Colours, out.Fitness
}

func DumpDetails(renderPix, diffBuff []byte) {
	s := StateExport{old, oldColor, currDiff, state.Views}
	state_json, _ := json.Marshal(s)
	//log.Printf("o: %p, n: %p\n", old, new)
	ioutil.WriteFile(fmt.Sprintf("%v/state_%v.json", checkpointDir, unique), state_json, 0777)
	ioutil.WriteFile(fmt.Sprintf("%v/current.json", checkpointDir), state_json, 0777)

	status := fmt.Sprintf("#Number of times we have modified and tested the parameters (for this run)\nCycle: %v\n#How well the current state matches the target picture(0 is exact match)\nFitness: %v\nView angle1: %v", unique, currDiff, state.Views[0].Angle)
	ioutil.WriteFile(fmt.Sprintf("%v/statistics.txt", checkpointDir), []byte(status), 0777)

	//Save render and diff pics
	//glim.SaveBuff(rx, ry, renderPix, fmt.Sprintf("pix/%v_render.png", unique))
	//glim.SaveBuff(rx, ry, diffBuff,  fmt.Sprintf("pix/%v_diff.png", unique))
	//ioutil.WriteFile(fmt.Sprintf("pix/%v_%v_%v_color_dump.txt", unique, diff, currDiff), []byte(fmt.Sprintf("\nold: %3.2v%v\nnew: %3.2v%v\n", oldColor, currDiff, newColor, diff)), 0777)
	//ioutil.WriteFile(fmt.Sprintf("pix/%v_%v_%v_position_dump.txt", unique, diff, currDiff), []byte(fmt.Sprintf("\nold: %3.2v%v\nnew: %3.2v%v\n", old, currDiff, new, diff)), 0777)
}

func CompareAndSwap(diff int64) {
	//If the new picture is less different to the reference than the previous best, make this the new best
	if (diff < currDiff) && startDrawing {
		copyBytes(old, new)
		copyBytes(oldColor, newColor)
		currDiff = diff
	} else {
		copyBytes(new, old)
		copyBytes(newColor, oldColor)
	}
}

func Mutate(scale float32) {

	//------------------- Now make the new frame
	mutateIndex = mutateIndex + 1
	if mutateIndex >= len(old) {
		mutateIndex = 0
	}

	mutateColIndex = mutateColIndex + 1
	if mutateColIndex >= len(oldColor) {
		mutateColIndex = 0
	}
	//log.Printf("MutatColIndex: %v\n", mutateColIndex)

	//if startDrawing {
	//log.Printf("Scale: %v\n", scale)
	coin := rand.Float32()
	if coin < 0.0 {
		//i := int(rand.Float32()*float32(len(oldColor)))
		//i:=mutateColIndex
		//m:= rand.Float32()*2.0*scale-1.0*scale
		//newColor[i] = newColor[i] + m
		//log.Printf("Final: %v\n", newColor[i])
	} else {
		//i := int(rand.Float32()*float32(len(old)))
		ic := mutateColIndex
		newColor[ic] = oldColor[ic] + rand.Float32()*4.0*scale - 2.0*scale
		new[mutateIndex] = old[mutateIndex] + rand.Float32()*2.0*scale - 1.0*scale
		//newColor[ic] = oldColor[ic] + 0.05
		//log.Printf("Move: %v\n", ic)
	}
	//}
	clampAll(new)
	//clampAll01(newColor)

	//Force the alpha channel to 1.0, we aren't doing transparent triangles yet
	for iii := 3; iii < len(newColor); iii = iii + 4 {
		newColor[iii] = 1.0
	}
}

func renderAll2(triangles, colours []float32, views []View) ([][]byte, int64) {
	outbytes := [][]byte{}
	diff := int64(0)
	for i := 0; i < len(views); i = i + 1 {
		a := views[i].Angle
		ref := views[i].Pix
		p2 := renderSide(new, newColor, a)
		outbytes = append(outbytes, p2)
		diff2 := CalcDiff(p2, ref, state.DiffBuff)
		diff = diff + diff2
	}
	return outbytes, diff
}

func RenderIt(triangles, colours []float32) []byte {
	//log.Println("Optimiser: Sending request to renderer")
	DrawRequestCh <- DrawRequest{triangles, colours}
	//log.Println("Optimiser: Fetching result from renderer")
	res := <-DrawResultCh
	return res.Render
}

func renderSide(triangles, colours []float32, angle euler) []byte {
	x := mgl32.Rotate3DX(angle[0])
	y := mgl32.Rotate3DY(angle[1])
	z := mgl32.Rotate3DZ(angle[2])
	sideTris := make([]float32, len(triangles))
	for i := 0; i < len(triangles); i = i + 3 {
		v := mgl32.Vec3{triangles[i], triangles[i+1], triangles[i+2]}
		v1 := x.Mul3x1(v)
		v1 = y.Mul3x1(v1)
		v1 = z.Mul3x1(v1)
		sideTris[i] = v1[0]
		sideTris[i+1] = v1[1]
		sideTris[i+2] = v1[2]
	}
	return RenderIt(sideTris, newColor)
}

func randomiseTriangle(index int, triangles []float32) {
	for i := index * 9; i < index*9+9; i++ {
		triangles[i] = rand.Float32()*2.0 - 1.0
	}
}

func randomiseColour(index int, colours []float32) {
	for i := index * 12; i < index*12+12; i++ {
		colours[i] = rand.Float32() * 1.0
	}
}

func evaluateTriangle(index int, triangles []float32) {
	temp := []float32{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
	for i := 0; i < 9; i++ {
		temp[i] = triangles[index+i]
		triangles[index+i] = 0.0
	}
	_, diff := renderAll2(new, newColor, state.Views)
	if Abs64(diff-currDiff) < 5 {
		randomiseTriangle(index, new)
		randomiseColour(index, newColor)
		pix, diff := renderAll2(new, newColor, state.Views)
		currDiff = diff
		dumpAll(pix)
		for i := 0; i < len(new); i++ {
			old[i] = new[i]
			oldColor[i] = newColor[i]
		}
	} else {
		for i := 0; i < 9; i++ {
			triangles[index+i] = temp[i]
		}
	}
}

func swapTriangles(n1, n2 int, triangles []float32) {
	temp := []float32{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
	for i := 0; i < 9; i++ {
		temp[i] = triangles[n1+i]
	}
	for i := 0; i < 9; i++ {
		triangles[n1+i] = triangles[n2+i]
	}
	for i := 0; i < 9; i++ {
		triangles[n2+i] = temp[i]
	}
}

func r (s float32) float32 {
    return rand.Float32()*s-s/2.0
}

func randomiseView(views []View, index int) ([]View) {
    newA := make([]View, len(views))
    oldV := views[index]
    newE := euler{oldV.Angle[0]+r(0.1), oldV.Angle[1]+r(0.1), oldV.Angle[2]+r(0.1) }
    newV := View{
        Pix: oldV.Pix,
        Width: oldV.Width,
        Height: oldV.Height,
        Angle: newE,
    }
    for i, v := range views {
        if (i == index) {
            newA[i] = newV
        } else {
            newA[i] = v
        }
    }
    return newA
}

func OptimiserWorker() {
	<-DrawResultCh
	pix := [][]byte{}
	diff := int64(0)
	for {
		nTriangles := len(new) / 9
		log.Println("Processing ", nTriangles, " triangles")
		//scale = scale -0.001
		scale = rand.Float32()
		if scale < 0.1 {
			scale = 1.0
		}
		log.Println("Chose scale: ", scale)
		log.Println("Starting shaker")
/*
		for zz := 0; zz < 100; zz++ {
			for zzz := 0; zzz < nTriangles*9; zzz++ {
				Mutate(scale)
			}
			pix, diff = renderAll2(new, newColor, state.Views)
			dumpAll(pix)
			CompareAndSwap(diff)
		}
*/

        for i, _ := range state.Views {
            newV := randomiseView(state.Views, i)
            pix, diff = renderAll2(old, oldColor, newV)
            if (diff < currDiff) && startDrawing {
                state.Views = newV
                currDiff = diff
            }
        }

		log.Println("Starting dead triangle randomiser")
		if unique > 10 { //FIXME, link to average fitness change per second
			for currentTriangle := 0; currentTriangle < nTriangles; currentTriangle++ {
				if !(currentTriangle < len(new)/9) {
					currentTriangle = 0
				}
				evaluateTriangle(currentTriangle, new)
			}
		}
		log.Println("Starting triangle tweaker")
		for zz := 0; zz < 10; zz++ {
			for zzz := 0; zzz < len(old); zzz++ {
				for i := -1; i < 2; i++ {
					//Mutate(float32(i)/50.0)
					Mutate(scale)
					pix, diff = renderAll2(new, newColor, state.Views)
					dumpAll(pix)
					CompareAndSwap(diff)
				}
			}
		}
	}
}

func dumpAll(pix [][]byte) {
	if unique%101 == 1 {
		saveNum = saveNum + 1
		go DumpDetails(state.RenderPix, state.DiffBuff)
		go dumpPics(pix)
	}
}

func dumpPics(pix [][]byte) {
	n := 0
	for _, p := range pix {
		n = n + 1
		go glim.SaveBuff(rx, ry, p, fmt.Sprintf("pix/side_%d_%05d.png", n, saveNum))
	}
}
