//go:build !sdl
// +build !sdl

package main

import (
	"bytes"
	"fmt"
	"image"
	dumb_annoying_draw_import "image/draw"
	_ "image/png"
	"log"
	"strings"

	"github.com/donomii/glim"
	"github.com/donomii/sceneCamera"
	"github.com/go-gl/gl/v3.2-core/gl"
	"github.com/go-gl/glfw/v3.3/glfw"
	"github.com/go-gl/mathgl/mgl32"
)

type State struct {
	prop           int32
	Program        uint32
	Vao            uint32
	Vbo            uint32
	Texture        uint32
	TextureUniform int32
	VertAttrib     int32
	Angle          float64
	PreviousTime   float64
	ModelUniform   int32
	TexCoordAttrib uint32

	Cao          uint32
	Cbo          uint32
	ColourAttrib int32
}

func newProgram(vertexShaderSource, fragmentShaderSource string) (uint32, error) {
	vertexShader, err := compileShader(vertexShaderSource, gl.VERTEX_SHADER)
	if err != nil {
		return 0, err
	}

	fragmentShader, err := compileShader(fragmentShaderSource, gl.FRAGMENT_SHADER)
	if err != nil {
		return 0, err
	}

	program := gl.CreateProgram()

	gl.AttachShader(program, vertexShader)
	gl.AttachShader(program, fragmentShader)
	gl.LinkProgram(program)

	var status int32
	gl.GetProgramiv(program, gl.LINK_STATUS, &status)
	if status == gl.FALSE {
		var logLength int32
		gl.GetProgramiv(program, gl.INFO_LOG_LENGTH, &logLength)

		log := strings.Repeat("\x00", int(logLength+1))
		gl.GetProgramInfoLog(program, logLength, nil, gl.Str(log))

		return 0, fmt.Errorf("failed to link program: %v", log)
	}

	gl.DeleteShader(vertexShader)
	gl.DeleteShader(fragmentShader)

	return program, nil
}

func compileShader(source string, shaderType uint32) (uint32, error) {
	shader := gl.CreateShader(shaderType)

	csources, free := gl.Strs(source)
	gl.ShaderSource(shader, 1, csources, nil)
	free()
	gl.CompileShader(shader)

	var status int32
	gl.GetShaderiv(shader, gl.COMPILE_STATUS, &status)
	if status == gl.FALSE {
		var logLength int32
		gl.GetShaderiv(shader, gl.INFO_LOG_LENGTH, &logLength)

		log := strings.Repeat("\x00", int(logLength+1))
		gl.GetShaderInfoLog(shader, logLength, nil, gl.Str(log))

		return 0, fmt.Errorf("failed to compile %v: %v", source, log)
	}

	return shader, nil
}

func newTexture(x, y int) (uint32, error) {
	rgba := image.NewRGBA(image.Rect(0, 0, x, y))
	if rgba.Stride != rgba.Rect.Size().X*4 {
		return 0, fmt.Errorf("unsupported stride")
	}

	// dumb_annoying_draw_import.Draw(rgba, rgba.Bounds(), img, image.Point{0, 0}, dumb_annoying_draw_import.Src)

	var texture uint32
	gl.GenTextures(1, &texture)
	gl.ActiveTexture(gl.TEXTURE0)
	gl.BindTexture(gl.TEXTURE_2D, texture)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)
	gl.TexImage2D(
		gl.TEXTURE_2D,
		0,
		gl.RGBA,
		int32(rgba.Rect.Size().X),
		int32(rgba.Rect.Size().Y),
		0,
		gl.RGBA,
		gl.UNSIGNED_BYTE,
		gl.Ptr(rgba.Pix))

	return texture, nil
}

func newTextureFromImage(data []byte) (uint32, error) {
	imgFile := bytes.NewReader(data)
	img, _, err := image.Decode(imgFile)
	if err != nil {
		return 0, err
	}

	rgba := image.NewRGBA(img.Bounds())
	if rgba.Stride != rgba.Rect.Size().X*4 {
		return 0, fmt.Errorf("unsupported stride")
	}

	dumb_annoying_draw_import.Draw(rgba, rgba.Bounds(), img, image.Point{0, 0}, dumb_annoying_draw_import.Src)

	var texture uint32
	gl.GenTextures(1, &texture)
	gl.ActiveTexture(gl.TEXTURE0)
	gl.BindTexture(gl.TEXTURE_2D, texture)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)
	gl.TexImage2D(
		gl.TEXTURE_2D,
		0,
		gl.RGBA,
		int32(rgba.Rect.Size().X),
		int32(rgba.Rect.Size().Y),
		0,
		gl.RGBA,
		gl.UNSIGNED_BYTE,
		gl.Ptr(rgba.Pix))

	return texture, nil
}

func emptyTexture() (uint32, error) {
	var texture uint32
	gl.GenTextures(1, &texture)
	gl.ActiveTexture(gl.TEXTURE0)
	gl.BindTexture(gl.TEXTURE_2D, texture)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)

	return texture, nil
}

var vertexShader = `
#version 330
uniform mat4 projection;
uniform mat4 camera;
uniform mat4 model;
in vec3 vert;
in vec2 vertTexCoord;
out vec2 fragTexCoord;
void main() {
    fragTexCoord = vertTexCoord;
    gl_Position =  model * vec4(vert, 1);
}
` + "\x00"

var fragmentShader = `
#version 330
uniform sampler2D tex;
in vec2 fragTexCoord;
out vec4 outputColor;
void main() {
    outputColor = texture(tex, fragTexCoord);
}
` + "\x00"

var cubeVertices = []float32{
	//  X, Y, Z, U, V

	-1.0, -1.0, -1.0, 0.0, 0.0,
	-1.0, 1.0, -1.0, 0.0, 1.0,
	1.0, -1.0, -1.0, 1.0, 0.0,
	1.0, -1.0, -1.0, 1.0, 0.0,
	-1.0, 1.0, -1.0, 0.0, 1.0,
	1.0, 1.0, -1.0, 1.0, 1.0,
}

// Open a window and initialize OpenGL
// Call this only once or terrible things will happen
// Note that the width and height are not the window size, but the size of the drawing area.  The window will be created with the right options to create the
// desired pixel drawing area.  This is only a problem on retina screens.
func gfxStart(width, height int, title string, transparent bool) (*glfw.Window, *State) {
	log.Println("Starting windowing system")
	if err := glfw.Init(); err != nil {
		panic(err)
	}

	// Basic GL setup options.  Note the version here MUST match the version in the library import
	glfw.WindowHint(glfw.ContextVersionMajor, 4)
	glfw.WindowHint(glfw.ContextVersionMinor, 1)
	glfw.WindowHint(glfw.OpenGLProfile, glfw.OpenGLCoreProfile)
	glfw.WindowHint(glfw.OpenGLForwardCompatible, glfw.True)

	// Window configuration options
	glfw.WindowHint(glfw.Resizable, glfw.True)
	glfw.WindowHint(glfw.Decorated, glfw.True)
	// glfw.WindowHint(glfw.Floating, glfw.True)

	if conf.WantTransparent {
		glfw.WindowHint(glfw.TransparentFramebuffer, 1)
	}

	// glfw.WindowHint(glfw.CocoaGraphicsSwitching, glfw.True)

	w := width
	h := height
	ss := int(1)

	if conf.RetinaMode {
		fmt.Println("Retina mode")
		ss = 2

	} else {
		fmt.Println("No retina mode")
		ss = 1
	}
	fmt.Println("If your pictures are too small and misplaced, try setting the --retina flag")

	win, err := glfw.CreateWindow(width/ss, height/ss, title, nil, nil)
	if err != nil {
		panic(err)
	}

	win.MakeContextCurrent()
	x, y := glfw.GetCurrentContext().GetFramebufferSize()
	fmt.Printf("Window size: %vx%v framebuffer size: %vx%v\n", w, h, x, y)
	if !conf.AutoRetina {
		fmt.Println("Checking for retina")
		x, y := glfw.GetCurrentContext().GetFramebufferSize()
		log.Printf("Window size: %vx%v framebuffer size: %vx%v\n", w, h, x, y)
		if x != w || y != h {
			win.Destroy()
			win, err = glfw.CreateWindow(width/2, height/2, title, nil, nil)
			if err != nil {
				panic(err)
			}
			win.MakeContextCurrent()
		}
	}

	fmt.Println("Window created")

	if err := gl.Init(); err != nil {
		panic(err)
	}

	state := &State{
		prop: 1,
	}

	version := gl.GoStr(gl.GetString(gl.VERSION))
	fmt.Println("OpenGL version", version)

	// Configure the vertex and fragment shaders
	state.Program, err = newProgram(vertexShader, fragmentShader)
	if err != nil {
		panic(err)
	}
	fmt.Println("Compiled program")

	// Activate the program we just created.  We will use the render and fragment shaders we compiled above
	gl.UseProgram(state.Program)
	checkGlError()

	// Set a default projection matrix
	projection := mgl32.Perspective(mgl32.DegToRad(45.0), float32(width)/float32(height), 0.1, 10.0)
	projectionUniform := gl.GetUniformLocation(state.Program, gl.Str("projection\x00"))
	gl.UniformMatrix4fv(projectionUniform, 1, false, &projection[0])
	checkGlError()

	// Setup the camera
	camera := mgl32.LookAtV(mgl32.Vec3{3, 3, 3}, mgl32.Vec3{0, 0, 0}, mgl32.Vec3{0, 1, 0})
	cameraUniform := gl.GetUniformLocation(state.Program, gl.Str("camera\x00"))
	gl.UniformMatrix4fv(cameraUniform, 1, false, &camera[0])
	checkGlError()

	// Setup the square
	model := mgl32.Ident4()
	state.ModelUniform = gl.GetUniformLocation(state.Program, gl.Str("model\x00"))
	gl.UniformMatrix4fv(state.ModelUniform, 1, false, &model[0])
	checkGlError()

	// Find the location of the texture, so we can upload a picture to it
	state.TextureUniform = gl.GetUniformLocation(state.Program, gl.Str("tex\x00"))
	gl.Uniform1i(state.TextureUniform, 0)
	checkGlError()

	// This is the variable in the fragment shader that will hold the colour for each pixel
	gl.BindFragDataLocation(state.Program, 0, gl.Str("outputColor\x00"))
	checkGlError()

	// Load the texture
	state.Texture, err = newTexture(w, h)
	if err != nil {
		log.Fatalln(err)
	}
	checkGlError()

	fmt.Println("Created new texture")

	// Configure the vertex data
	gl.GenVertexArrays(1, &state.Vao)
	gl.BindVertexArray(state.Vao)

	gl.GenBuffers(1, &state.Vbo)
	gl.BindBuffer(gl.ARRAY_BUFFER, state.Vbo)
	gl.BufferData(gl.ARRAY_BUFFER, len(cubeVertices)*4, gl.Ptr(cubeVertices), gl.STATIC_DRAW)
	checkGlError()
	state.VertAttrib = gl.GetAttribLocation(state.Program, gl.Str("vert\x00"))
	gl.EnableVertexAttribArray(uint32(state.VertAttrib))
	gl.VertexAttribPointer(uint32(state.VertAttrib), 3, gl.FLOAT, false, 5*4, gl.PtrOffset(0))
	checkGlError()
	state.TexCoordAttrib = uint32(gl.GetAttribLocation(state.Program, gl.Str("vertTexCoord\x00")))
	gl.EnableVertexAttribArray(state.TexCoordAttrib)
	gl.VertexAttribPointer(state.TexCoordAttrib, 2, gl.FLOAT, false, 5*4, gl.PtrOffset(3*4))
	checkGlError()

	// Configure global settings
	gl.Enable(gl.DEPTH_TEST)
	gl.DepthFunc(gl.LESS)
	gl.UseProgram(state.Program)
	gl.ClearColor(1.0, 1.0, 1.0, 0.0)

	// Activate the square vertex data, which will be drawn
	gl.BindVertexArray(state.Vao)

	// Choose the texture we just created and uploaded
	gl.ActiveTexture(gl.TEXTURE0)
	gl.BindTexture(gl.TEXTURE_2D, state.Texture)
	checkGlError()
	return win, state
}

// Draws the window i.e. does a frame
func gfxMain(win *glfw.Window, state *State, logo []byte, texWidth, texHeight int) {
	width, height := glfw.GetCurrentContext().GetFramebufferSize()
	gl.Viewport(0, 0, int32(width), int32(height))

	gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

	var texture uint32
	gl.GenTextures(1, &texture) // FIXME reuse texture
	gl.ActiveTexture(gl.TEXTURE0)
	gl.BindTexture(gl.TEXTURE_2D, texture)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)
	if logo != nil {
		logo = glim.FlipUp(texWidth, texHeight, logo)
	}
	gl.TexImage2D(
		gl.TEXTURE_2D, 0,
		gl.RGBA,
		int32(texWidth), int32(texHeight), 0,
		gl.RGBA,
		gl.UNSIGNED_BYTE, gl.Ptr(logo),
	)

	angle := state.Angle

	model := mgl32.HomogRotate3D(float32(angle), mgl32.Vec3{0, 1, 0})
	gl.UniformMatrix4fv(state.ModelUniform, 1, false, &model[0])

	gl.DrawArrays(gl.TRIANGLES, 0, 6*2*3)

	win.SwapBuffers()
	gl.Disable(gl.TEXTURE_2D)

	gl.Flush()

	gl.DeleteTextures(1, &texture)
}

func checkGlError() {
	err := gl.GetError()
	if err > 0 {
		errStr := fmt.Sprintf("GLerror: %v\n", err)
		fmt.Printf(errStr)
		panic(errStr)
	}
}

func blit(pix []uint8, w, h int) {
	gl.ClearColor(0.0, 0.0, 0.0, 0.0)
	gl.Clear(gl.COLOR_BUFFER_BIT)

	if conf.AutoRetina {
		x, y := glfw.GetCurrentContext().GetFramebufferSize()
		log.Printf("Window size: %vx%v framebuffer size: %vx%v\n", w, h, x, y)
		if x != w || y != h {
			conf.RetinaMode = true
		} else {
			conf.RetinaMode = false
		}
	}

	fmt.Println("If your pictures are too small and misplaced, try setting the --retina flag")

	var texture uint32
	gl.GenTextures(1, &texture) // FIXME reuse texture
	gl.ActiveTexture(gl.TEXTURE0)
	gl.BindTexture(gl.TEXTURE_2D, texture)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)

	gl.TexImage2D(
		gl.TEXTURE_2D, 0,
		gl.RGBA,
		int32(w), int32(h), 0,
		gl.RGBA,
		gl.UNSIGNED_BYTE, gl.Ptr(pix),
	)

	gl.Disable(gl.TEXTURE_2D)

	gl.Flush()

	gl.DeleteTextures(1, &texture)
}

func resetCam(camera *sceneCamera.SceneCamera) {
	camera.Reset()
	camera.SetPosition(0, 0, 1)
	camera.Translate(0.0, 0.0, 0.0)
	camera.LookAt(0.0, 0.0, 0.0)
}
