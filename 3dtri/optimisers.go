//This package contains all the routines to set up and manipulate the "genome" that we are trying to optimise.  It receives calls from the gui:  InitOptimiser, Process, and StopOptimiser
package main

import (
    //"math"
    "github.com/go-gl/mathgl/mgl32"
    "io/ioutil"
    "github.com/donomii/glim"
    "os"
    "math/rand"
    "time"
    "log"
    "fmt"
    "encoding/json"
)

func InitOptimiser() {
    scale = 1.0
    rand.Seed(time.Now().Unix())
    log.Printf("Initialiser callback...")
    old = make([]float32,0)
    new = make([]float32,0)
    oldColor = make([]float32,0)
    newColor = make([]float32,0)
    i :=0
     var x,y float32
     for x=-1.0; x<1.0; x=x+0.6 {
     for y=-1.0; y<1.0; y=y+0.6 {
        old = append(old,triangleDataRaw...)
        new = append(new,triangleDataRaw...)
        oldColor = append(oldColor,colorDataRaw...)
        newColor = append(newColor,colorDataRaw...)
    
        //old[i] =rand.Float32()*2.0-1.0 // v+ rand.Float32()*0.2*scale-0.1*scale
        //x :=rand.Float32()*0.5-0.25 // v+ rand.Float32()*0.2*scale-0.1*scale
        //y :=rand.Float32()*0.5-0.25 // v+ rand.Float32()*0.2*scale-0.1*scale
        old[i] = x
        old[i+1] = y
        old[i+2] = 1.0

        oldColor[i] = x
        oldColor[i+1] = y
        oldColor[i+2] = 1.0


        old[i+3] = x+0.1
        old[i+4] = y
        old[i+5] = -1.0

        old[i+6] = x
        old[i+7] = y+0.1
        old[i+8] = 0.0
        i = i + 9
    }}


    if len(os.Args)>1 {
        fname = os.Args[1]
        log.Println("Loading file: ", fname)
        refImage, rx, ry = glim.LoadImage(fname)
        log.Printf("Loaded reference image %v:%v\n", rx, ry)
    } else {
        log.Fatal("please give a reference image on the command line")
    }
    state.RefImage  = refImage
    go resetDiff()
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

func copyBytes (a, b []float32) {
    for i,_:= range b{
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

func CalcDiff(renderPix, refImage, diffBuff []byte) int64{
  diff :=int64(0)
    //Calculate the difference between each picture by comparing the pixels, skipping the alpha channel
    //for i, v := range renderPix {
    for y := 0; y < ry; y++ {
        for x := 0; x < rx; x++ {
            for z:= 0 ; z< 3 ; z++ {
                i := (x + y * rx) * 4 + z
                //ii := (x + (ry-y-1)*rx) * 4 +z
                //if (i+1) % 4 == 0 || (i) % 4 == 0 || (i+3) % 4 == 0 {
                  //if (i+1) % 4 == 0  {
                    //log.Printf("renderAlpha: %v, refAlpha: %v\n", renderPix[i], refImage[i])
                    //diffBuff[i] = 255
                    //renderPix[i]=255
                    //continue
                //}
                //fmt.Println(ii, ry, y)

                d := Abs64(int64(renderPix[i])-int64(refImage[i]))
                if (dump) {log.Printf("%v - %v = %v\n", renderPix[i], refImage[i], d)}
                diff = diff + d
                //diffBuff[i] = byte(uint8(d)) //FIXME
            }
        }
    }
    return diff
}

type StateExport struct {
    Points  []float32
    Colours []float32
}

func ReadStateFromFile(filename string) ([]float32, []float32) {
    jdata, _ := ioutil.ReadFile(filename)
    var out StateExport
    json.Unmarshal(jdata, &out)
    return out.Points, out.Colours
}

func DumpDetails(renderPix, diffBuff []byte) {
        s:= StateExport{old, oldColor}
        state_json, _ := json.Marshal(s)
        //log.Printf("o: %p, n: %p\n", old, new)
        ioutil.WriteFile(fmt.Sprintf("%v/state_%v.json", checkpointDir, unique), state_json, 0777)
        ioutil.WriteFile(fmt.Sprintf("%v/current.json", checkpointDir), state_json, 0777)

        status := fmt.Sprintf("#Number of times we have modified and tested the parameters (for this run)\nCycle: %v\n#How well the current state matches the target picture(0 is exact match)\nFitness: %v\n", unique, currDiff)
        ioutil.WriteFile(fmt.Sprintf("%v/statistics.txt", checkpointDir), []byte(status), 0777)
        
        //ioutil.WriteFile(fmt.Sprintf("pix/%v_new_%v_%v_render.txt", unique, diff, currDiff), []byte(fmt.Sprintf("%v",newColor)), 0777)
        //Save render and diff pics
        //glim.SaveBuff(rx, ry, renderPix, fmt.Sprintf("pix/%v_render.png", unique))
        //glim.SaveBuff(rx, ry, diffBuff,  fmt.Sprintf("pix/%v_diff.png", unique))
        //ioutil.WriteFile(fmt.Sprintf("pix/%v_%v_%v_color_dump.txt", unique, diff, currDiff), []byte(fmt.Sprintf("\nold: %3.2v%v\nnew: %3.2v%v\n", oldColor, currDiff, newColor, diff)), 0777)
        //ioutil.WriteFile(fmt.Sprintf("pix/%v_%v_%v_position_dump.txt", unique, diff, currDiff), []byte(fmt.Sprintf("\nold: %3.2v%v\nnew: %3.2v%v\n", old, currDiff, new, diff)), 0777)
}


func CompareAndSwap(diff int64, renderPix, diffBuff []byte) {
    //If the new picture is less different to the reference than the previous best, make this the new best
    if (diff < currDiff)  && startDrawing {
        //log.Printf("Diff: %v is less than %v, copying new to old, saving as %v\n", diff, currDiff, unique)
        //ioutil.WriteFile(fmt.Sprintf("pix/diff_%v_%v_%v.txt", unique, diff, currDiff), []byte(fmt.Sprintf("%v",oldColor)), 0777)
        //glim.SaveBuff(rx, ry, diffBuff, fmt.Sprintf("pix/%v_%v_%v_new_choice_diff.png", unique, diff, currDiff))
        //glim.SaveBuff(rx, ry, renderPix, fmt.Sprintf("pix/%v_new_choice.png", unique))
        //log.Printf("(%v):*Changed* old: %p, new: %p\n", unique, oldColor, newColor)
        copyBytes(old,new)
        copyBytes(oldColor,newColor)
        //log.Printf("(%v) %v -> %v", unique, currDiff, diff)
        currDiff = diff
    } else {
        //log.Printf("Diff: %v is greater than %v, copying old to new, not saving\n", diff, currDiff)
        copyBytes(new,old)
        copyBytes(newColor,oldColor)
        //currDiff = currDiff + 100
    }
}

func Mutate (scale float32) {

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
            ic:=mutateColIndex
            newColor[ic] = oldColor[ic] + rand.Float32()*4.0*scale-2.0*scale
            new[mutateIndex]      = old[mutateIndex]      + rand.Float32()*2.0*scale-1.0*scale
            //newColor[ic] = oldColor[ic] + 0.05
            //log.Printf("Move: %v\n", ic)
          }
        //}
        clampAll(new)
        //clampAll01(newColor)

    //Force the alpha channel to 1.0, we aren't doing transparent triangles yet
    for iii:=3;iii<len(newColor);iii=iii+4 {
      newColor[iii]=1.0
    }
}


type RenderState struct {
    RenderPix []byte
    RefImage []byte
    DiffBuff []byte
}

var state RenderState

func renderAll(triangles, colours []float32) ([]byte, []byte, int64) {
    p1 := RenderIt(new, newColor)
    diff := CalcDiff(p1, state.RefImage, state.DiffBuff)
    p2 := renderSide(new, newColor)
    diff2 := CalcDiff(p2, state.RefImage, state.DiffBuff)
    diff = diff + diff2
    return p1, p2, diff
}


func RenderIt(triangles, colours []float32) []byte {
    //log.Println("Optimiser: Sending request to renderer")
    DrawRequestCh <- DrawRequest{triangles, colours}
    //log.Println("Optimiser: Fetching result from renderer")
    res := <- DrawResultCh
    return res.Render
}

func renderSide (triangles, colours []float32) []byte {
    r := mgl32.Rotate3DY(3.14159/2.0)
    sideTris := make([]float32, len(triangles))
    for i:= 0 ; i < len(triangles) ; i=i+3 {
        v := mgl32.Vec3{triangles[i], triangles[i+1], triangles[i+2]}
        v1 := r.Mul3x1(v)
        sideTris[i] = v1[0]
        sideTris[i+1] = v1[1]
        sideTris[i+2] = v1[2]
    }
    return RenderIt(sideTris, newColor)
}

func randomiseTriangle(index int, triangles []float32) {
    for i:=index*9; i<index*9+9; i++ {
        triangles[i] = rand.Float32()*2.0-1.0
    }
}

func randomiseColour(index int, colours []float32) {
    for i:=index*12; i<index*12+12; i++ {
        colours[i] = rand.Float32()*1.0
    }
}

func evaluateTriangle(index int, triangles []float32) {
    temp := []float32{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    for i:=0; i<9; i++ {
        temp[i] = triangles[index+i]
        triangles[index+i] = 0.0
    }
    state.RenderPix = RenderIt(new, newColor)
    diff := CalcDiff(state.RenderPix, state.RefImage, state.DiffBuff)
    p:= renderSide(new, newColor)
    diff2 := CalcDiff(p, state.RefImage, state.DiffBuff)
    diff = diff + diff2
    if Abs64(diff - currDiff)< 5 {
        randomiseTriangle(index, new)
        randomiseColour(index, newColor)
        state.RenderPix, _, currDiff = renderAll(new, newColor)
        for i:=0; i<len(new); i++ {
            old[i] = new[i]
            oldColor[i] = newColor[i]
        }
    } else {
        for i:=0; i<9; i++ {
            triangles[index+i] = temp[i]
        }
    }
}

func swapTriangles(n1, n2 int, triangles []float32) {
    temp := []float32{0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    for i:=0; i<9; i++ {
        temp[i] = triangles[n1+i]
    }
    for i:=0; i<9; i++ {
        triangles[n1+i] = triangles[n2+i]
    }
    for i:=0; i<9; i++ {
        triangles[n2+i] = temp[i]
    }
}

func OptimiserWorker() {
    <- DrawResultCh
    currentTriangle := 0
    for {
        nTriangles := len(new)/9
        log.Println("Processing ", nTriangles, " triangles")
        //scale = scale -0.001
        if scale < 0.1 {
            scale = 1.0
        }
        log.Println("Starting shaker")
        for zz:=0;zz<1000;zz++ {
            for zzz:=0; zzz<nTriangles*9; zzz++ {
                Mutate(1.0/25.0)
            }
            diff := int64(0)
            state.RenderPix, _, diff = renderAll(new, newColor)
            CompareAndSwap(diff, state.RenderPix, state.DiffBuff);
            Process(state)
        }

        if unique > 10 {  //FIXME, link to average fitness change per second
            for zzz:=0; zzz<nTriangles; zzz++ {
                currentTriangle = currentTriangle + 1
                if ! (currentTriangle < len(new)/9) {
                    currentTriangle = 0
                }
                //randomiseTriangle(currentTriangle, new)
                //randomiseColour(currentTriangle, newColor)
                //state.RenderPix = RenderIt(new, newColor)
                //Process(state)
                evaluateTriangle(currentTriangle, new)
            }
        }
        log.Println("Starting triangle tweaker")
        for zz:=0;zz<1;zz++ {
            for zzz:=0; zzz<nTriangles*9; zzz++ {
                for i := -1; i<2; i++ {
                    Mutate(float32(i)/50.0)
                    diff := int64(0)
                    state.RenderPix, _, diff = renderAll(new, newColor)
                    CompareAndSwap(diff, state.RenderPix, state.DiffBuff);
                    Process(state)
                }
            }
        }
    }
}
//Note that for reasons of speed, almost all the binary structs are modified in place.  If you want to keep the data between iterations, you need to copy it into a different spot in memory
func Process(state RenderState) {
         //Prepare a blank byte array to hold the difference pic
          diffBuff := make([]byte, len(state.RenderPix))
          for i, _ := range diffBuff {
              diffBuff[i] = 0
          }
        state.DiffBuff = diffBuff
    if unique % 1001 == 1 {
        saveNum = saveNum + 1
        go glim.SaveBuff(rx, ry, state.RenderPix, fmt.Sprintf("pix/render_%05d.png", saveNum))
        p := renderSide(new, newColor)
        go glim.SaveBuff(rx, ry, p, fmt.Sprintf("pix/side_%05d.png", saveNum))
        go DumpDetails(state.RenderPix, state.DiffBuff)
    }


}
