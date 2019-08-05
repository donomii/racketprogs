package main 

import (
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

func CalcDiff(renderPix, refImage []byte, width, height int) int64 {
     diff := int64(0)
     for y := 0; y < height; y++ {
         for x := 0; x < width; x++ {
             for z := 0; z < 3; z++ {
                 i := (x+y*width)*4 + z
                 d := Abs64(int64(renderPix[i]) - int64(refImage[i]))
                 diff = diff + d
             }
         }
     }
     return diff
 }

func main() {

    refImage, x, y := glim.LoadImage("../input/front.png")
    diff := CalcDiff(refImage, refImage, x, y)
    fmt.Printf("Self diff is %v\n", diff)



    cam, elements := unpackGenome(defaultGenome())
    fmt.Println(genscene(cam, elements))
    ioutil.WriteFile("scene.pov", []byte(genscene(cam, elements)), 0644)
    goof.QC([]string{"povray", fmt.Sprintf("+W%v", x), fmt.Sprintf("+H%v", y), "scene.pov"})
    renderImage, _, _ := glim.LoadImage("scene.png")
    diff = CalcDiff(refImage, renderImage, x, y)
    fmt.Printf("Render diff is %v\n", diff)



}
