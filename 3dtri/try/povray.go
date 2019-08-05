package main 

import (
    "fmt"
    "math/rand"
)

func p(n float32) float32 {
    return 2.0 * n - 1.0
}

func genscene(cam []float32, elements [][]float32) string{

    scene :=fmt.Sprintf(`  #include "colors.inc"
  global_settings { ambient_light 5.0 }
   background { color Cyan }
   camera { location <%v, %v, %v> look_at  < %v, %v,  %v> }
   `, cam[0], cam[1], cam[2], cam[3], cam[4], cam[5])

   for _, v := range elements {
   scene = scene + fmt.Sprintf("sphere { <%v, %v, %v>, %v texture { pigment { color rgb <%v, %v, %v> } } } \n", p(v[0]), p(v[1]), p(v[2]), v[3]/2.0, v[4], v[5], v[6])
}
return scene
}

func randomElement() []float32 {
    out := []float32{}
    for i:=0; i<7; i++ {
    out = append(out, rand.Float32())
    }
    return out
}

func defaultGenome() []float32 {

    //gen := []float32{0.0,2.0,-3.0,0.0,0.0,0.0,   0.0,0.0,0.0,0.5,   1.0,1.0,0.0}
    gen := []float32{0.0,2.0,-3.0,0.0,0.0,0.0}
    for i:=0; i<100; i++ {
    gen = append(gen, randomElement()...)
}

    return gen
}

func unpackGenome(genome []float32) ([]float32, [][]float32) {
    cam := genome[0:6]
    elements := [][]float32{}
    for i:=6; i+7<len(genome); i=i+7 {
    elements = append(elements, genome[i:i+7])
}
    return cam, elements
}

