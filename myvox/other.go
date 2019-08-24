// other
package myvox

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
