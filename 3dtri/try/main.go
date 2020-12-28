package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"os"
	"runtime"
	"time"

	"github.com/donomii/glim"
	"github.com/donomii/govox"

	"github.com/go-gl/glfw/v3.2/glfw"
	"github.com/thoj/go-galib"
)

var progressDir string = "progress"
var refImagePath string = "../input/front.png"
var inputDir string = "../input-sphere/"
var CameraViews []View
var window *glfw.Window
var rv govox.RenderVars
var currDiff int64

// Abs64 returns the absolute value of x.
func Abs64(x int64) int64 {
	if x < 0 {
		return -x
	}
	return x
}

func InitViews(inputDir string) []View {
	log.Printf("Initialising views")

	cameraAngle := []euler{
		euler{0.0, 0.0, 0.0},
		euler{0.0, 3.14159 / 2.0, 0.0},
		euler{0.0, -3.14159 / 2.0, 0.0},
		euler{3.14159 / 2.0, 0.0, 0.0},
		euler{-3.14159 / 2.0, 0.0, 0.0},
		euler{0.0, 3.14159, 0.0},
	}

	translation := [][]float32{
		[]float32{0.0, 0.0, -3.0},
		[]float32{0.0, 0.0, 3.0},
		[]float32{0.0, -3.0, 0.0},
		[]float32{0.0, 3.0, 0.0},
		[]float32{-3.0, 0.0, 0.0},
		[]float32{3.0, 0.0, 0.0},
	}

	files := []string{
		inputDir + "/front.png",
		inputDir + "/rside.png",
		inputDir + "/lside.png",
		inputDir + "/top.png",
		inputDir + "/bottom.png",
		inputDir + "/back.png",
	}

	var Views []View
	for i, fname := range files {
		log.Println("Loading ", fname)
		refImage, x, y := glim.LoadImage(fname)
		Views = append(Views, View{refImage, x, y, cameraAngle[i], translation[i]})
	}
	return Views
}

func mutate(genome []float32, scale float32) []float32 {
	ng := make([]float32, len(genome))
	for i, v := range genome {
		if i < 7 { //camera
			ng[i] = v
		} else {
			tmp := v + scale*(rand.Float32()*float32(2.0)-1.0)
			if tmp < 0.0 {
				tmp = 0.0
			}
			if tmp > 1.0 {
				tmp = 1.0
			}
			ng[i] = tmp
		}
	}
	return ng
}

func randomElement() []float32 {
	out := []float32{}
	for i := 0; i < 9; i++ {
		out = append(out, rand.Float32())
	}
	return out
}

func zeroElement() []float32 {
	out := []float32{}
	for i := 0; i < 4; i++ {
		out = append(out, 0.49)
	}
	return out
}

func defaultGenome(count int) []float32 {

	//gen := []float32{0.0,2.0,-3.0,0.0,0.0,0.0,   0.0,0.0,0.0,0.5,   1.0,1.0,0.0}
	gen := []float32{0.0, 2.0, -3.0, 0.0, 0.0, 0.0}
	for i := 0; i < count; i++ {
		gen = append(gen, zeroElement()...)
	}

	return gen
}

func unpackGenome(genome []float32) ([]float32, [][]float32) {
	cam := genome[0:6]
	elements := [][]float32{}
	for i := 6; i+9 < len(genome); i = i + 9 {
		elements = append(elements, genome[i:i+9])
	}
	return cam, elements
}

var saveCount int = 0

func renderAndDiff(renderFunc func([]float32, int, int) []byte, views []View, newGen []float32) (int64, []byte, int, int) {
	totalDiff := int64(0)
	var outImage []byte
	for _, v := range views {
		//v := views[0]
		for j := 0; j < 3; j++ {
			newGen[j] = v.Angle[j]

		}
		renderImage := renderFunc(newGen, v.Width, v.Height)
		if outImage == nil {
			outImage = renderImage
		}
		diff, diffImage := glim.CalcDiffSq(v.Pix, renderImage, v.Width, v.Height)
		for i := 3; i < len(diffImage); i = i + 4 {
			diffImage[i] = 255
		}
		//glim.SaveBuff(v.Width, v.Height, diffImage, fmt.Sprintf("pix/render%05d_diff_%v.png", saveCount, diff))
		//glim.SaveBuff(v.Width, v.Height, v.Pix, fmt.Sprintf("pix/render%05d_orig.png", saveCount))
		totalDiff = totalDiff + diff
	}
	return totalDiff, outImage, views[0].Width, views[0].Height

}

func anneal(renderFunc func([]float32, int, int) []byte, rounds int, oldGen []float32, refImage []byte) []float32 {
	//renderImage := renderFunc(oldGen, x, y)
	//oldDiff, _ := renderAndDiff(renderFunc, CameraViews, oldGen)
	//oldRender := renderImage
	oldDiff := int64(9919818628429132)

	count := 1

	for j := 1; j < rounds; j++ {
		scale := float32(0.5)
		for k := 1; scale > 0.005; k++ {

			count = count + 1
			//scale = float32(1) / float32(count)
			//scale = 0.1
			scale = scale - 0.001

			//fmt.Printf("Scale: %v\n", scale)
			repeats := 3
			for i := 1; i < repeats; i++ {
				newGen := mutate(oldGen, scale)
				diff, front, x, y := renderAndDiff(renderFunc, CameraViews, newGen)
				//log.Printf("Old: %v, New: %v\n", oldDiff, diff)
				saveCount = saveCount + 1

				if diff < oldDiff && saveCount > 5 {
					log.Println("Keeping ", diff)
					repeats = repeats + 20
					fmt.Printf("Old diff is %v\n", oldDiff)
					fmt.Printf("Render diff is %v\n", diff)

					//go glim.SaveBuff(x, y, diffbuff, fmt.Sprintf("pix/refdiff%05d.png", saveCount))

					//go goof.QC([]string{"cp", "scene.png", fmt.Sprintf("pix/render_%05d.png", saveCount)})
					go glim.SaveBuff(x, y, front, fmt.Sprintf(progressDir+"/render%05d.png", saveCount))
					oldDiff = diff
					oldGen = newGen
					//_, xbuff := glim.CalcDiff(oldRender, renderImage, x, y)
					//go glim.SaveBuff(x, y, xbuff, fmt.Sprintf("pix/diff%05d.png", saveCount))
					//oldRender = renderImage
				}
			}
		}

	}
	return oldGen
}

func ga_render(g *ga.GAFloatGenome) float64 {
	gen32 := make([]float32, len(g.Gene))
	for i, v := range g.Gene {
		gen32[i] = float32(v)
	}

	diff, front, x, y := renderAndDiff(render_voxel, CameraViews, gen32)
	//log.Printf("New: %v\n", diff)
	if diff < currDiff {
		currDiff = diff
		saveCount = saveCount + 1
		go glim.SaveBuff(x, y, front, fmt.Sprintf(progressDir+"/render%05d.png", saveCount))
	}
	/*
		refImage, x, y := glim.LoadImage(refImagePath)
		renderImage := render_povray(gen32, x, y)

		saveCount = saveCount + 1
		localCount := saveCount
		glim.SaveBuff(x, y, glim.FlipUp(x, y, renderImage), fmt.Sprintf(progressDir+"/render_%05d.png", localCount))

		diff, diffBuff := glim.CalcDiff(refImage, renderImage, x, y)

		SaveState("./", renderImage, diffBuff, diff, gen32, []View{})
	*/

	return float64(diff)

}

func gasolve(renderFunc func([]float32, int, int) []byte, rounds int, oldGen []float32, refImage []byte) []float32 {
	genome := ga.NewFloatGenome(make([]float64, len(oldGen)), ga_render, 1, 0)

	/*
		for i, v := range oldGen {
			genome.Gene[i] = float64(v)
		}
	*/

	rand.Seed(time.Now().UTC().UnixNano())

	param := ga.GAParameter{
		Initializer: new(ga.GARandomInitializer),
		Selector:    ga.NewGATournamentSelector(0.2, 5),
		Breeder:     new(ga.GA2PointBreeder),
		Mutator:     ga.NewGAGaussianMutator(0.4, 0),
		PMutate:     0.5,
		PBreed:      0.2}

	//gao := ga.NewGAParallel(param, 4)
	gao := ga.NewGA(param)
	genome.Max = 1.0
	genome.Min = 0.0

	gao.Init(1000, genome) //Total population

	gao.OptimizeUntil(func(best ga.GAGenome) bool {
		return best.Score() < 1e-3
	})

	best := gao.Best().(*ga.GAFloatGenome)
	fmt.Printf("%s = %f\n", best, best.Score())
	//fmt.Printf("Calls to score = %d\n", scores)

	for i, v := range oldGen {
		oldGen[i] = float32(v)
	}

	return oldGen
}
func init() {
	runtime.LockOSThread()
}
func main() {
	resumeFile := flag.String("resume", "", "File containing resume data")
	inputDir := flag.String("inputs", "input", "Directory containing input pictures")
	progressDir = *flag.String("progress", "progress", "Output in-progress pictures here")
	renderEngine := *flag.String("engine", "voxels", "The render engine: voxels, voxanneal, triangles, povray")
	flag.Parse()
	currDiff = 9999999999
	size := int(10)

	CameraViews = InitViews(*inputDir)
	os.Mkdir(progressDir, 0755)
	oldGen := defaultGenome(size*size*size + 7)
	refImage, _, _ := glim.LoadImage(refImagePath)
	//diff, _ := glim.CalcDiff(refImage, refImage, x, y)
	//diff, _ = renderAndDiff(render_povray, CameraViews, oldGen)

	if *resumeFile != "" {
		log.Println("Loading triangle data from file: ", *resumeFile)
		oldGen, _ = LoadState(*resumeFile)
	}
	if renderEngine == "voxanneal" {
		window, rv = govox.InitGraphics(size, 500, 500)
		go func() {

			genome := anneal(render_voxel, 1000000, oldGen, refImage)
			fmt.Println(genome)
		}()

		for !window.ShouldClose() {
			govox.GlRenderer(size, &rv, window)
		}
	}
	if renderEngine == "voxels" {
		window, rv = govox.InitGraphics(size, 500, 500)
		go func() {

			genome := gasolve(render_voxel, 10000, oldGen, refImage)
			fmt.Println(genome)
		}()

		for !window.ShouldClose() {
			govox.GlRenderer(size, &rv, window)
		}
	}
	log.Println("Finished!")
}
