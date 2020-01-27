package main

import (
	"flag"
	"fmt"
	"image"
	_ "image/png"
	"log"
	"math"
	"math/rand"
	"os"
	"path"
	"runtime"
	"sync"
	"time"
)

var (
	cpuprofile = flag.String("cpuprofile", "", "write cpu profile to file")
	mp         = flag.Float64("mp", 1.0, "megapixels of the rendered image")
	times      = flag.Int("t", 1, "times to repeat the benchmark")
	procs      = flag.Int("p", runtime.NumCPU(), "number of render goroutines")
	outputfile = flag.String("o", "render.ppm", "output file to write the rendered image to")
	resultfile = flag.String("r", "result.json", "result file to write the benchmark data to")
	artfile    = flag.String("a", "ART", "the art file to use for rendering")
	home       = flag.String("home", os.Getenv("RAYS_HOME"), "RAYS folder")
)

func calcDifference(m image.Image, img *memimage) float64 {
	var difference float64
	difference = 0
	for j := 0; j < 100; j = j + 1 {
		for i := 0; i < 100; i = i + 1 {
			k := j*100*DetailLength + i*DetailLength
			R, G, B, _ := m.At(i, j).RGBA()
			r := int(R >> 8)
			g := int(G >> 8)
			b := int(B >> 8)
			//log.Printf("PixelRR(%v): %v\n", k, img.floatdata[k+0])
			rr := int(img.floatdata[k+0])
			gg := int(img.floatdata[k+1])
			bb := int(img.floatdata[k+2])

			delta := math.Pow(float64(r-rr), 2) + math.Pow(float64(g-gg), 2) + math.Pow(float64(b-bb), 2)
			difference = difference + delta
			//log.Printf("PixelR: %d\n", r)
			//log.Printf("PixelRR: %f/%d\n", img.floatdata[k+0], rr)

			//log.Printf("PixelG: %d\n", g)
			//log.Printf("PixelGG: %d\n", gg)
			//fmt.Printf("Pixeldiff(%d,%d): %f\n", i, j, delta)
			//if rr < 64 || rr > 200 {
			//	fmt.Printf("Foundexception!\n")
			//	os.Exit(1)
			//}
		}
	}
	return difference
}

func doRender(size int) *memimage {
	img := newImage(size)
	// The camera position.
	cam := newCamera(vector{X: 5.0, Y: -16, Z: -8}, vector{X: -5, Y: 16, Z: 8}, size)

	var wg sync.WaitGroup
	// Initialize the wait group with *procs tasks, so that wg.Wait() blocks unless
	// wg.Done() is called as many times.
	wg.Add(*procs)
	// Initiate the rendering process across *procs parallel streams.
	for i := 0; i < *procs; i++ {
		w := &worker{id: i, size: size, cam: cam, wg: &wg, img: img}
		go w.render()
	}
	// The following statement blocks until all the goroutines signal back with a wg.Done()
	wg.Wait()

	// Calculate amount of time taken for the render.
	return img
}

var objectDetailsArray = [100002]float64{}
var objectDetails []float64
var DetailLength = 6

func getR(index int, list []float64) float64 {
	return list[index*DetailLength+0]
}

func getG(index int, list []float64) float64 {
	return list[index*DetailLength+1]
}
func getB(index int, list []float64) float64 {
	return list[index*DetailLength+2]
}
func getRad(index int, list []float64) float64 {
	return list[index*DetailLength+3]
}
func getX(index int, list []float64) float64 {
	return list[index*DetailLength+4]
}
func getY(index int, list []float64) float64 {
	return list[index*DetailLength+5]
}
func getZ(index int, list []float64) float64 {
	return list[index*DetailLength+6]
}
func copyDetails(a []float64) []float64 {
	c := make([]float64, len(a))
	for i, _ := range a {
		c[i] = 0.0 + a[i]
	}
	return c
}

func perturb(b []float64, maxDelta float64) []float64 {
	a := copyDetails(b)
	for i, _ := range a {
		a[i] = a[i] + rand.Float64()*maxDelta - 0.5*maxDelta
	}
	return a
}
func perturb1(i int, a []float64) []float64 {
	b := copyDetails(a)
	b[i] = a[i] + rand.Float64()/5.0 - 0.1
	//log.Printf("Newval: %f, oldval: %f\n", b[i], a[i])
	return b

}
func main() {
	objectDetails = objectDetailsArray[0:100000]
	for i := 0; i < 100000; i = i + 1 {
		objectDetails[i] = rand.Float64()
	}
	reader, err := os.Open("mona.png")
	if err != nil {
		log.Fatal(err)
	}
	defer reader.Close()
	//reader := base64.NewDecoder(base64.StdEncoding, reader)
	m, _, err := image.Decode(reader)
	if err != nil {
		log.Fatal(err)
	}

	// Set the total number of threads to *procs.
	runtime.GOMAXPROCS(*procs + 1)
	// Parse the command line arguments.
	flag.Parse()

	// Calculate the dimensions of the image based on the mp flag. Image is always a square.
	size := int(math.Sqrt(*mp * 1000000))
	log.Printf("Will render %v time(s)", *times)
	if *procs < 1 {
		log.Fatalf("procs (%v) needs to be >= 1", *procs)
	}

	// Read the art file.
	if *artfile == "ART" {
		*artfile = path.Join(*home, *artfile)
	}
	f, err := os.Open(*artfile)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	// Create objects out of the art file.
	ar := readArt(f)
	objects = ar.objects()
	var results results
	// Allocate the image.
	oldDifference := 9999999999999999999.0
	maxPerturb := 1.0
	passes := 0.0
	improves := 0.0
	for i := 0; i < 100000; i = i + 1 {
		maxPerturb = maxPerturb - 0.00001
		log.Printf("Modifying %d details\n", len(objectDetails))
		for n := 0; n < len(objects)*DetailLength; n = n + 1 {
			passes += 1.0
			var img *memimage
			// Mark the start time.
			startTime := time.Now()
			//newDetails := copyDetails(objectDetails)

			//log.Printf("(%d): oldval: %f\n", n, objectDetails[n])
			oldDetails := objectDetails
			newDetails := perturb(objectDetails, maxPerturb)
			//newDetails := copyDetails(objectDetails)

			//log.Printf("Newval(%d): %v, oldval: %v\n", n, newDetails[n], objectDetails[n])
			objectDetails = newDetails
			img = doRender(size)

			difference := calcDifference(m, img)

			duration := time.Since(startTime).Seconds()
			results = append(results, duration)

			//log.Printf("Render complete")
			//log.Printf("Time taken for render %v", duration)
			//log.Printf("Average time %v", results.Average())

			// Save the results, the image and done.

			//log.Printf("Difference: %f\n", difference)
			if difference < oldDifference {
				improves += 1.0
				oldDifference = difference
				results.Save()
				img.Save()
				fmt.Printf("Image saved\n")
				fmt.Printf("Keeping new permutation: %f\n", difference)
				fmt.Printf("Efficiency: %f\n", improves/passes)

			} else {
				objectDetails = oldDetails
			}
		}

	}
}
