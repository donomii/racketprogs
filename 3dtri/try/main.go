package main 

import (
    "io/ioutil"
    "fmt"
    "github.com/donomii/goof"
)

func main() {
    cam, elements := unpackGenome(defaultGenome())
    fmt.Println(genscene(cam, elements))
    ioutil.WriteFile("scene.pov", []byte(genscene(cam, elements)), 0644)
    goof.QC([]string{"povray", "+W200", "+H200", "scene.pov"})

}
