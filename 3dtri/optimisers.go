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
    Pix         []byte      //The input photo
    Width       int         //Width, in pixels
    Height      int         //Height in pixels
    Angle       euler       //The euler angles to position the camera, looking towards the origin
    Translate   []float32   //Translation vector, applied after rotation
}

var state RenderState

type euler []float32

func addTriangle() {
    old = append(old, triangleDataRaw...)
    new = append(new, triangleDataRaw...)
    oldColor = append(oldColor, colorDataRaw...)
    newColor = append(newColor, colorDataRaw...)
}

func extrudeTriangle() {
    nTri := len(old)/3
    addTriangle()
    t := rand.Intn(nTri)
    old = append(old, triangleDataRaw...)
    new = append(new, triangleDataRaw...)
    oldColor = append(oldColor, colorDataRaw...)
    newColor = append(newColor, colorDataRaw...)
    old[nTri*3]   = old[t*3]
    old[nTri*3+1] = old[t*3+1]
    old[nTri*3+2] = old[t*3+2]
}

func max32(a, b float32) float32 {
    if a > b {
        return a
    } else {
        return b
    }
}

func triangleArea ( indexes []float32) float32 {
    if strOpts["poly_mode"] == "TRIANGLES" {
    a:=mgl32.Vec3{indexes[0], indexes[1], indexes[2]}
    b:=mgl32.Vec3{indexes[3], indexes[4], indexes[5]}
    c:=mgl32.Vec3{indexes[6], indexes[7], indexes[8]}
    /*
    This is the real area, but if we use this we end up with long thin triangles
    aa:= a.Sub(c)
    bb:= b.Sub(c)
    v3:=aa.Cross(bb)
    l:= v3.Len()
    return l
    */

    longSide := max32(a.Len(), max32(b.Len(),c.Len()))
    length := longSide*longSide*longSide*longSide*longSide*longSide*longSide*longSide
    if length < 1.0 {
        length = 1.0/(1.0-length)
    }
    return length*10000.0
    } else {
        return 0.0
    }
}

func InitOptimiser() {
	scale = 1.0
	rand.Seed(time.Now().Unix())
	log.Printf("Initialiser callback...")
	old = make([]float32, 0)
	new = make([]float32, 0)
	oldColor = make([]float32, 0)
	newColor = make([]float32, 0)
    //Must have one triangle, no matter what
    addTriangle()
    for i:=0; i<intOpts["triCount"]; i++ {
            extrudeTriangle()
            randomiseTriangle(i, old)
    }
/*
	i := 0
	var x, y float32
	for x = -1.0; x < 1.0; x = x + 0.5 {
		for y = -1.0; y < 1.0; y = y + 0.5 {
            addTriangle()

            for i:= 0; i<9; i=i+1 {
                old[i] =rand.Float32()*2.0-1.0 // v+ rand.Float32()*0.2*scale-0.1*scale
            }
			//x :=rand.Float32()*0.5-0.25 // v+ rand.Float32()*0.2*scale-0.1*scale
			//y :=rand.Float32()*0.5-0.25 // v+ rand.Float32()*0.2*scale-0.1*scale
			old[i] = 0.0 //x
			old[i+1] = 0.0 //y
			old[i+2] = 0.0

			oldColor[i] = 0.0 //x
			oldColor[i+1] = 0.0 //y
			oldColor[i+2] = 0.0 //1.0

			old[i+3] = 0.0 //x + 0.3
			old[i+4] = 0.0 //y
			old[i+5] = 0.0 //-1.0

			old[i+6] = 0.0 //x
			old[i+7] = 0.0 //y + 0.3
			old[i+8] = 0.0
			i = i + 9
		}
	}
*/

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
	diffBuff := make([]byte, 4096*4096*4)
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
        log.Println("Loading ", fname)
		refImage, x, y := glim.LoadImage(fname)
		state.RefImages = append(state.RefImages, refImage)
        state.Views = append(state.Views, View{refImage, x, y, cameraAngles[i], []float32{0.0, 0.0, 0.0}})
	}

	go OptimiserWorker()

	currDiff = 999999999999999
	startDrawing = true
    for i, v := range old {
        new[i] = v
    }
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

func CalcDiff(renderPix, refImage, diffBuff []byte, width, height int) int64 {
	diff := int64(0)
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			for z := 0; z < 3; z++ {
				i := (x+y*width)*4 + z
				d := Abs64(int64(renderPix[i]) - int64(refImage[i]))
				if dump {
					log.Printf("%v - %v = %v\n", renderPix[i], refImage[i], d)
				}
				diff = diff + d
                if strategies["diffs"] {
                    diffBuff[i] = byte(uint8(d)) //FIXME
                }
			}
		}
	}
    for i:=0; i<len(old); i=i+9 {
        area := int64(triangleArea(old[i:i+9]))
        diff = diff + area*area
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
    obj := []byte(export_obj(old))
	//log.Printf("o: %p, n: %p\n", old, new)
	ioutil.WriteFile(fmt.Sprintf("%v/current.json", checkpointDir), state_json, 0777)
	ioutil.WriteFile(fmt.Sprintf("%v/backup.json", checkpointDir), state_json, 0777)

	ioutil.WriteFile(fmt.Sprintf("%v/current.obj", checkpointDir), obj, 0777)
	ioutil.WriteFile(fmt.Sprintf("%v/backup.obj", checkpointDir), obj, 0777)

	status := fmt.Sprintf("#Number of times we have modified and tested the parameters (for this run)\nCycle: %v\n#How well the current state matches the target picture(0 is exact match)\nFitness: %v\nView angle1: %v", unique, currDiff, state.Views[0].Angle)
	ioutil.WriteFile(fmt.Sprintf("%v/statistics.txt", checkpointDir), []byte(status), 0777)

	//Save render and diff pics
	//glim.SaveBuff(rx, ry, renderPix, fmt.Sprintf("pix/%v_render.png", unique))
	//glim.SaveBuff(rx, ry, diffBuff,  fmt.Sprintf("pix/%v_diff.png", unique))
	//ioutil.WriteFile(fmt.Sprintf("pix/%v_%v_%v_color_dump.txt", unique, diff, currDiff), []byte(fmt.Sprintf("\nold: %3.2v%v\nnew: %3.2v%v\n", oldColor, currDiff, newColor, diff)), 0777)
	//ioutil.WriteFile(fmt.Sprintf("pix/%v_%v_%v_position_dump.txt", unique, diff, currDiff), []byte(fmt.Sprintf("\nold: %3.2v%v\nnew: %3.2v%v\n", old, currDiff, new, diff)), 0777)
}

func CompareAndSwap(diff int64, pix [][]byte ) {
	//If the new picture is less different to the reference than the previous best, make this the new best
	if (diff < currDiff) && startDrawing {
		copyBytes(old, new)
		copyBytes(oldColor, newColor)
		currDiff = diff
        dumpAll(pix, state.Views)
	} else {
		copyBytes(new, old)
		copyBytes(newColor, oldColor)
	}
}

func MutateColour(scale float32) {

	mutateColIndex = mutateColIndex + 1
	if mutateColIndex >= len(oldColor) {
		mutateColIndex = 0
	}
    ic := mutateColIndex
    newColor[ic] = oldColor[ic] + rand.Float32()*4.0*scale - 2.0*scale

	//Force the alpha channel to 1.0, we aren't doing transparent triangles yet
	for iii := 3; iii < len(newColor); iii = iii + 4 {
		newColor[iii] = 1.0
	}
}

func Mutate(scale float32) {

	//------------------- Now make the new frame
	mutateIndex = mutateIndex + 1
	if mutateIndex >= len(old) {
		mutateIndex = 0
	}

    new[mutateIndex] = old[mutateIndex] + rand.Float32()*2.0*scale - 1.0*scale

}

func renderAll2(triangles, colours []float32, views []View) ([][]byte, int64) {
	outbytes := [][]byte{}
	diff := int64(0)
	for i := 0; i < len(views); i = i + 1 {
		a := views[i].Angle
		ref := views[i].Pix
		p2 := renderSide(new, newColor, a, views[i].Width, views[i].Height)
		outbytes = append(outbytes, p2)
		diff2 := CalcDiff(p2, ref, state.DiffBuff, views[i].Width, views[i].Height)
        if strategies["diffs"] {
            dumpDiff(state.DiffBuff, i, views[i].Width, views[i].Height)
        }
		diff = diff + diff2
	}
	return outbytes, diff
}

func RenderIt(triangles, colours []float32, width, height int) []byte {
	//log.Println("Optimiser: Sending request to renderer")
	DrawRequestCh <- DrawRequest{triangles, colours, width, height}
	//log.Println("Optimiser: Fetching result from renderer")
	res := <-DrawResultCh
	return res.Render
}

func renderSide(triangles, colours []float32, angle euler, width, height int) []byte {
	x := mgl32.Rotate3DX(angle[0])
	y := mgl32.Rotate3DY(angle[1])
	z := mgl32.Rotate3DZ(angle[2])
	sideTris := make([]float32, len(triangles))
	for i := 0; i < len(triangles); i = i + 3 {
		v := mgl32.Vec3{triangles[i], triangles[i+1], triangles[i+2]}
		v1 := x.Mul3x1(v)
		v2 := y.Mul3x1(v1)
		v3 := z.Mul3x1(v2)
		sideTris[i] = v3[0]
		sideTris[i+1] = v3[1]
		sideTris[i+2] = v3[2]
	}
	return RenderIt(sideTris, newColor, width, height)
}

func randomiseTriangle(index int, triangles []float32) {
    p := []float32{rand.Float32()*2.0 - 1.0, rand.Float32()*2.0 - 1.0, rand.Float32()*2.0 - 1.0}
	for i := index * 9; i < index*9+9; i=i+3 {
        triangles[i] = p[0]
        triangles[i+1] = p[1]
        triangles[i+2] = p[2]
	}
}

func randomisePoint(index int, triangles []float32) {
	for i := index; i < index+3; i++ {
        new := rand.Float32()*2.0 - 1.0
        triangles[i] = new
	}
}

func randomiseColour(index int, colours []float32) {
	for i := index * 12; i < index*12+12; i++ {
		colours[i] = rand.Float32() * 1.0
	}
}


func randomisePointColour(index int, colours []float32) {
	for i := index ; i < index+4; i++ {
		colours[i] = rand.Float32() * 1.0
	}
}



//Fix this so it doesn't access global vars
func evaluatePoint(index int, triangles []float32) {
    //log.Println("Checking point ", index)
	temp := []float32{0.0, 0.0, 0.0}
	for i := 0; i < 3; i++ {
		temp[i] = new[index+i]
		new[index+i] = 0.0
	}
	_, diff := renderAll2(new, newColor, state.Views)

    if oldColor[index*4/3] > 0.95 {
        diff = currDiff
        log.Println("Resetting triangle that is background colour: ", index)
    }
	if diff<currDiff {
        //Removing this point improves the picture
        log.Println("Resetting point ", index)
		randomisePoint(index, new)
		randomisePointColour(index, newColor)
		pix, diff := renderAll2(new, newColor, state.Views)
		currDiff = diff
		dumpAll(pix, state.Views)
		for i := 0; i < len(new); i++ {
			old[i] = new[i]
			oldColor[i] = newColor[i]
		}
	} else {
		for i := 0; i < 3; i++ {
			new[index+i] = temp[i]
		}
	}
}

//Fix this so it doesn't access global vars
func evaluateTriangle(tri_index int, triangles []float32) {
    log.Println("Checking triangle ", tri_index)
    index := tri_index*3
	temp := []float32{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
	for i := 0; i < 9; i++ {
		temp[i] = new[index+i]
		new[index+i] = 0.0
	}
	_, diff := renderAll2(new, newColor, state.Views)

    if oldColor[tri_index*4] >0.95 {
        diff = currDiff
        log.Println("Resetting triangle that is background colour: ", tri_index)
    }
	if Abs64(diff-currDiff) < 5 {
        log.Println("Resetting triangle ", tri_index)
		randomiseTriangle(tri_index, new)
		randomiseColour(tri_index, newColor)
		pix, diff := renderAll2(new, newColor, state.Views)
		currDiff = diff
		dumpAll(pix, state.Views)
		for i := 0; i < len(new); i++ {
			old[i] = new[i]
			oldColor[i] = newColor[i]
		}
	} else {
		for i := 0; i < 9; i++ {
			new[index+i] = temp[i]
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
    //Create a mutated angle
    newE := euler{oldV.Angle[0]+r(0.1), oldV.Angle[1]+r(0.1), oldV.Angle[2]+r(0.1) }
    //Create a mutated translate
    newT := []float32{oldV.Translate[0]+r(0.1), oldV.Translate[1]+r(0.1), oldV.Translate[2]+r(0.1) }
    newV := View{
        Pix: oldV.Pix,
        Width: oldV.Width,
        Height: oldV.Height,
        Angle: newE,
        Translate: newT,
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

func registerDiff (in []int64, ind, val int64) ([]int64, int64) {
    in[ind] = val
    ind = ind+1
    if ! (ind < int64(len(in)) ) {
        ind = 0
    }
    log.Println("Old diffs: ", in)
    return in, ind
}

func OptimiserWorker() {
	<-DrawResultCh
	pix := [][]byte{}
	diff := int64(0)
    diffArray := []int64{0,0,0,0,0,0,0,0,0,0}
    nextDiffArray := int64(0)
	for {
		nTriangles := len(new) / 9
		log.Println("Processing ", nTriangles, " triangles")
		//scale = scale -0.001
		scale = rand.Float32()
		if scale < 0.1 {
			scale = 0.1
		}
		log.Println("Chose scale: ", scale)

		pix, diff = renderAll2(old, oldColor, state.Views)
		currDiff = diff
        var oldDiff = currDiff

        diffArray, nextDiffArray = registerDiff(diffArray, nextDiffArray, currDiff)

        if strategies["shaker"] {
            log.Println("Starting shaker with scale at ", scale)
            for zz := 0; zz < 10; zz++ {
                for zzz:=0; zzz<len(new);zzz=zzz+1 {
                    Mutate(scale/10.0)
                }
                pix, diff = renderAll2(new, newColor, state.Views)
                CompareAndSwap(diff, pix)
            }
            diffArray, nextDiffArray = registerDiff(diffArray, nextDiffArray, currDiff)
        }
        

        if strategies["dead_triangle"] {
            log.Println("Starting dead triangle randomiser")
            if unique > 10000 { //FIXME, link to average fitness change per second
                for currentTriangle := 0; currentTriangle < nTriangles; currentTriangle = currentTriangle +1 {
                    evaluateTriangle(currentTriangle, new)
              }
            }
            diffArray, nextDiffArray = registerDiff(diffArray, nextDiffArray, currDiff)
        }


        if strategies["dead_point"] {
            log.Println("Starting dead point randomiser")
            //if unique > 1000 { //FIXME, link to average fitness change per second
                for currentPoint := 0; currentPoint < len(new); currentPoint = currentPoint + 3 {
                    evaluatePoint(currentPoint, new)
              //  }
            }
            diffArray, nextDiffArray = registerDiff(diffArray, nextDiffArray, currDiff)
        }


        if strategies["tweak"] {
            log.Println("Starting triangle tweaker")
            for zz := 0; zz < 1; zz++ {
                for zzz := 0; zzz < len(old); zzz++ {
                    Mutate(scale)
                    pix, diff = renderAll2(new, newColor, state.Views)
                    CompareAndSwap(diff, pix)

                    MutateColour(scale)
                    pix, diff = renderAll2(new, newColor, state.Views)
                    CompareAndSwap(diff, pix)

                    for _, _ := range []int{-11, -7, -5, -3, -1, 1, 3, 5, 7, 11} {
                    Mutate(scale)
                    pix, diff = renderAll2(new, newColor, state.Views)
                    CompareAndSwap(diff, pix)
                    }
                }
            }
            diffArray, nextDiffArray = registerDiff(diffArray, nextDiffArray, currDiff)
        }


        if strategies["view"] {
            log.Println("Starting view mutator")
            for i, _ := range state.Views {
                newV := randomiseView(state.Views, i)
                pix, diff = renderAll2(old, oldColor, newV)
                if (diff < currDiff) && startDrawing {
                    state.Views = newV
                    currDiff = diff
                }
            }
            diffArray, nextDiffArray = registerDiff(diffArray, nextDiffArray, currDiff)
        }

		go DumpDetails(state.RenderPix, state.DiffBuff)
        if currDiff == oldDiff {
            //We have probably reached a stable state, we should either quit or change things a bit
            log.Println("Reached stability, adding triangle")
            addTriangle()
        }
        clampAll(old)
        clampAll01(oldColor)
        log.Println("Current fitness: ", currDiff)
    }
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


func dumpAll(pix [][]byte, views []View) {
//	if unique%11 == 1 {
		saveNum = saveNum + 1
		go DumpDetails(state.RenderPix, state.DiffBuff)
		go dumpPics(pix, views)
//	}
}

func dumpPics(pix [][]byte, views []View) {
	n := 0
	for i, p := range pix {
		n = n + 1
		go glim.SaveBuff(views[i].Width, views[i].Height, p, fmt.Sprintf("pix/side_%d_%05d.png", n, saveNum))
	}
}

func dumpDiff(pix []byte, ind int, width, height int) {
    go glim.SaveBuff(width, height, pix, fmt.Sprintf("diffs/diff_%d.png", ind))
}

//FIXME
func CopyState(in RenderState) RenderState {
    //err := deepcopy.Copy(dst interface{}, src interface{})
    return in
}
    
func export_obj(vertexes []float32) string {
    out := ""
    faces := ""
    for i:=0; i<len(vertexes) ; i=i+3 {
        out = fmt.Sprintf("%vv %v %v %v\n", out, vertexes[i], vertexes[i+1], vertexes[i+2])
        faces = fmt.Sprintf("%vf %v %v %v\n", faces, i+1, i+2, i+3)
    }
    return fmt.Sprintf("%s%s", out, faces)
}
