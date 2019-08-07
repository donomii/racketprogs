package main 

import (
	"os"
	"math/rand"
    "io/ioutil"
    "fmt"
    "github.com/donomii/goof"
    "github.com/donomii/glim"
)


// Abs64 returns the absolute value of x.
 func Abs64(x int64) int64 {
     if x < 0 {
         return -x
     }
     return x
 }

func CalcDiff(renderPix, refImage []byte, width, height int) (int64, []byte) {
	diffbuff := make([]byte, len(refImage))
     diff := int64(0)
     for y := 0; y < height; y++ {
         for x := 0; x < width; x++ {
             for z := 0; z < 3; z++ {
                 i := (x+y*width)*4 + z
                 d := Abs64(int64(renderPix[i]) - int64(refImage[i]))
                 diff = diff + d
		 diffbuff[i] = byte(d)
             }
         }
     }
     return diff, diffbuff
 }

 func mutate(genome []float32, scale float32) []float32{
	ng := make([]float32, len(genome))
	for i,v := range genome {
		if i<7 {
			ng[i] = v
		} else {
		tmp := v + scale * (rand.Float32()  * float32(2.0) - 1.0)
		if tmp < 0.0 { tmp = 0.0 }
		if tmp > 1.0 { tmp = 1.0}
		ng[i] = tmp
	}
	}
	return ng
 }

 func render(newGen []float32, x, y int) []byte {
    cam, elements := unpackGenome(newGen)
 //fmt.Println(genscene(cam, elements))
    ioutil.WriteFile("scene.pov", []byte(genscene(cam, elements)), 0644)
    goof.QC([]string{"c:/Program Files/POV-Ray/v3.7/bin/pvengine64.exe", fmt.Sprintf("+W%v", x), fmt.Sprintf("+H%v", y), "/RENDER","scene.pov", "/EXIT"})
       renderImage, _, _ := glim.LoadImage("scene.png")
       return renderImage

    }

func main() {

    oldGen :=defaultGenome()
    refImage, x, y := glim.LoadImage("../input-sphere/front.png")
    diff,_ := CalcDiff(refImage, refImage, x, y)
    fmt.Printf("Self diff is %v\n", diff)

    renderImage := render(oldGen, x, y)
    oldDiff, _ := CalcDiff(refImage, renderImage, x, y)
    oldRender := renderImage


    count := 5
    saveCount:=0
    for {
	    count = count + 1
	    scale := float32(1)/float32(count)
	    scale = 0.01
	    if scale < 0.001 {
		    os.Exit(0)
	    }
	    for i:=1 ;i<3; i++ {
    newGen := mutate(oldGen, scale)
    renderImage := render(newGen, x, y)
    diff, diffbuff := CalcDiff(refImage, renderImage, x, y)
    fmt.Printf("Old diff is %v\n", oldDiff)
    fmt.Printf("Render diff is %v\n", diff)
    if diff < oldDiff {
    goof.QC([]string{"cp", "scene.png", fmt.Sprintf("progress%05d.png", saveCount)})
	go glim.SaveBuff(x, y, diffbuff, fmt.Sprintf("refdiff%05d.png", saveCount))
    		saveCount=saveCount+1
	    oldDiff = diff
	    oldGen = newGen
    _, xbuff := CalcDiff(oldRender, renderImage, x, y)
	go glim.SaveBuff(x, y, xbuff, fmt.Sprintf("diff%05d.png", saveCount))
    oldRender = renderImage
    }
}
}

}
