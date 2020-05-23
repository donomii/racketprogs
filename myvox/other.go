// other
package main

import (
	"github.com/go-gl/mathgl/mgl32"
)

type Block struct {
	Active bool
	Color  mgl32.Vec4
}

type RenderVars struct {
	//Col        mgl32.Vec4
	//ColUni     int32
	Vao        uint32
	Vbo        uint32
	VertAttrib uint32
	Program    uint32
}

func MakeBlocks(size int) [][][]Block {
	// initialize blocks
	blocks := make([][][]Block, size)
	for i := 0; i < size; i++ {
		blocks[i] = make([][]Block, size)
		for j := 0; j < size; j++ {
			blocks[i][j] = make([]Block, size)
			for k := 0; k < size; k++ {
				blocks[i][j][k] = Block{
					Active: false,
					Color: mgl32.Vec4{
						0.0,
						0.0,
						0.0,
						0.0,
					},
				}
			}
		}
	}
	return blocks
}
