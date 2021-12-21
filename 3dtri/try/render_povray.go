package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"math/rand"
	"os"

	"github.com/donomii/glim"
	"github.com/donomii/goof"
)

func p(n float32) float32 {
	return 2.0*n - 1.0
}

func c(n float32) float32 {
	return n
	v := math.Mod(float64(n), 0.25)
	return float32(v) * 4.0
}

func genscene(cam []float32, elements [][]float32) string {

	scene := fmt.Sprintf(`  #include "colors.inc"
  global_settings { ambient_light 5.0 }
   background { color White }
   camera { location <%v, %v, %v> look_at  < %v, %v,  %v> }
   `,
		//, cam[0], cam[1], cam[2], cam[3], cam[4], cam[5])
		0, 0, 3, 0, 0, 0)

	for _, v := range elements {

		scene = scene + fmt.Sprintf("superellipsoid { <%v, %v>  texture { pigment { color rgb <%v, %v, %v> } finish { phong 1} } scale %v translate <%v,%v,%v>} \n", v[7]*3.0, v[8]*3.0, c(v[4]), c(v[5]), c(v[6]), v[3]/10.0, p(v[0])/2.0, p(v[1])/2.0, p(v[2])/2.0)

		//scene = scene + fmt.Sprintf("sphere { <%v, %v, %v>, %v texture { pigment { color rgb <%v, %v, %v> } } } \n", p(v[0]), p(v[1]), p(v[2]), v[3]/5.0, c(v[4]), c(v[5]), c(v[6]))
		//scene = scene + fmt.Sprintf("box { <%v, %v, %v>, <%v, %v, %v>  texture { pigment { color rgb <%v, %v, %v> } } }\n", p(v[0]), p(v[1]), p(v[2]), p(v[4]), p(v[5]), p(v[6]), c(v[3])
	}
	return scene
}

func render_povray(newGen []float32, x, y int) []byte {
	cam, elements := unpackGenome(newGen)
	//fmt.Println(genscene(cam, elements))
	basename := fmt.Sprintf("render-%v", rand.Int())
	povName := basename + ".pov"
	pngName := basename + ".png"
	ioutil.WriteFile(povName, []byte(genscene(cam, elements)), 0644)
	//goof.QC([]string{"c:/Program Files/POV-Ray/v3.7/bin/pvengine64.exe", fmt.Sprintf("+W%v", x), fmt.Sprintf("+H%v", y), "/RENDER",povName, "/EXIT"})
	goof.QC([]string{"povray", fmt.Sprintf("+W%v", x), fmt.Sprintf("+H%v", y), povName})

	renderImage, _, _ := glim.LoadImage(pngName)
	os.Remove(povName)
	os.Remove(pngName)
	return renderImage

}
