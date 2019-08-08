package main

import (
	"fmt"
	"math/rand"
	"os"

	"time"

	"github.com/donomii/glim"
	"github.com/donomii/goof"
	"github.com/thoj/go-galib"
)

// Abs64 returns the absolute value of x.
func Abs64(x int64) int64 {
	if x < 0 {
		return -x
	}
	return x
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

func defaultGenome(count int) []float32 {

	//gen := []float32{0.0,2.0,-3.0,0.0,0.0,0.0,   0.0,0.0,0.0,0.5,   1.0,1.0,0.0}
	gen := []float32{0.0, 2.0, -3.0, 0.0, 0.0, 0.0}
	for i := 0; i < count; i++ {
		gen = append(gen, randomElement()...)
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

func anneal(renderFunc func([]float32, int, int) []byte, rounds int, oldGen []float32, refImage []byte, x, y int) []float32 {
	renderImage := renderFunc(oldGen, x, y)
	oldDiff, _ := glim.CalcDiff(refImage, renderImage, x, y)
	//oldRender := renderImage

	count := 1
	saveCount := 0

	for j := 1; j < rounds; j++ {
		scale := float32(1.0)
		for k := 1; scale > 0.005; k++ {

			count = count + 1
			//scale = float32(1) / float32(count)
			//scale = 0.1
			scale = scale - 0.01

			fmt.Printf("Scale: %v\n", scale)
			repeats := 3
			for i := 1; i < repeats; i++ {
				newGen := mutate(oldGen, scale)
				renderImage := renderFunc(newGen, x, y)
				diff, diffbuff := glim.CalcDiff(refImage, renderImage, x, y)

				if diff < oldDiff {
					repeats = repeats + 100
					fmt.Printf("Old diff is %v\n", oldDiff)
					fmt.Printf("Render diff is %v\n", diff)

					saveCount = saveCount + 1

					go glim.SaveBuff(x, y, diffbuff, fmt.Sprintf("pix/refdiff%05d.png", saveCount))
					go goof.QC([]string{"cp", "scene.png", fmt.Sprintf("pix/render_%05d.png", saveCount)})

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

var saveCount = 0

func ga_render(g *ga.GAFloatGenome) float64 {
	gen32 := make([]float32, len(g.Gene))
	for i, v := range g.Gene {
		gen32[i] = float32(v)
	}

	refImage, x, y := glim.LoadImage("../testpics/cow.png")
	renderImage := render_povray(gen32, x, y)

	go glim.SaveBuff(x, y, renderImage, fmt.Sprintf("pix/render_%05d.png", saveCount))
	saveCount = saveCount + 1
	diff, _ := glim.CalcDiff(refImage, renderImage, x, y)
	return float64(diff)

}

func gasolve(renderFunc func([]float32, int, int) []byte, rounds int, oldGen []float32, refImage []byte, x, y int) []float32 {
	genome := ga.NewFloatGenome(make([]float64, len(oldGen)), ga_render, 1, -1)

	for i, v := range oldGen {
		genome.Gene[i] = float64(v)
	}

	rand.Seed(time.Now().UTC().UnixNano())

	param := ga.GAParameter{
		Initializer: new(ga.GARandomInitializer),
		Selector:    ga.NewGATournamentSelector(0.2, 5),
		Breeder:     new(ga.GA2PointBreeder),
		Mutator:     ga.NewGAGaussianMutator(0.4, 0),
		PMutate:     0.5,
		PBreed:      0.2}

	gao := ga.NewGAParallel(param, 4)
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

func main() {

	os.Mkdir("pix", 0755)
	oldGen := defaultGenome(200)
	refImage, x, y := glim.LoadImage("../testpics/cow.png")
	diff, _ := glim.CalcDiff(refImage, refImage, x, y)
	fmt.Printf("Self diff is %v\n", diff)

	//genome := anneal(render_povray, 500, oldGen, refImage, x, y)
	genome := gasolve(render_povray, 500, oldGen, refImage, x, y)
	fmt.Println(genome)
}
