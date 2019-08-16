package main

import (
	_ "io/ioutil"

	//"log"
	_ "math"

	"os"

	"github.com/go-gl/mathgl/mgl32"

	//"github.com/donomii/glim"
	"github.com/donomii/govox"

	//	"github.com/go-gl/glfw/v3.2/glfw"

	"github.com/go-gl/gl/v3.3-core/gl"
)

func Genome2Blocks(size int, genomeAndViews []float32, inblocks [][][]govox.Block) [][][]govox.Block {
	// initialize blocks
	//log.Println("Converting")
	blocks := inblocks
	genome := genomeAndViews
	if inblocks == nil {
		blocks = make([][][]govox.Block, size)
	}
	for i := 0; i < size; i++ {
		if inblocks == nil {
			blocks[i] = make([][]govox.Block, size)
		}
		for j := 0; j < size; j++ {
			if inblocks == nil {
				blocks[i][j] = make([]govox.Block, size)
			}
			for k := 0; k < size; k++ {
				elem := genome[4*(i*size*size+j*size+k) : 4*(i*size*size+j*size+k)+4]
				//log.Printf("%v: %v\n", elem[0], (elem[0] > 0.999))
				if elem[0] > 0.5 {
					blocks[i][j][k] = govox.Block{
						Active: true,
						Color:  mgl32.Vec4{elem[1], elem[2], elem[3], 1.0},
					}
				} else {
					blocks[i][j][k] = govox.Block{
						Active: false,
						Color:  mgl32.Vec4{0.0, 0.0, 0.0, 0.0},
					}
				}

			}
		}
	}
	return blocks
}

func render_voxel(newGen []float32, x, y int) []byte {
	//	size := int32(10)
	os.Mkdir("renderfiles", 0755)
	//_, elements := unpackGenome(newGen)

	gl.Viewport(0, 0, int32(x), int32(y))
	//	drawBlocks := Genome2Blocks(int(size), newGen, nil)
	//govox.Renderblocks(rv, window, drawBlocks, newGen[0], newGen[1], int(size))

	renderImage := govox.ScreenshotBuff(x, y)
	/*

		log.Println("Saving screenshot to", pngName)
		renderImage, xx, yy := glim.LoadImage(pngName)
		if x != xx || y != yy {
			panic("Rendered image does not have correct dimensions!")
		}
		os.Remove(pngName)
	*/
	return renderImage

}
