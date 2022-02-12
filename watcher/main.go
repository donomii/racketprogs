package main

import (
	"flag"
	"fmt"
	"log"
	"regexp"
	"strings"
	"time"

	"github.com/donomii/goof"
	"github.com/radovskyb/watcher"
)

func main() {

	watchDir := flag.String("watch", "./", "Directory to watch")
	watchRegex := flag.String("regex", "go", "Regex to match files to watch")
	buildCmd := flag.String("build", "go build -o tmp.exe .", "Command to build")
	runCmd := flag.String("run", "./tmp.exe", "Command to run")
	flag.Parse()

	var changeDetected chan bool = make(chan bool)
	var buildComplete chan bool = make(chan bool)

	go func() {
		for {
			<-changeDetected
			fmt.Println("Building...%v", *buildCmd)
			goof.Shell(*buildCmd)
			fmt.Printf("Build complete\n")
			buildComplete <- true

		}
	}()

	go func() {
		for {
			<-buildComplete
			fmt.Printf("Killing %v\n", *runCmd)
			goof.QC([]string{"pkill", "-f", *runCmd}) //FIXME windows
			fmt.Printf("Running %v\n", *runCmd)
			go goof.Shell(*runCmd)

		}
	}()

	fmt.Println("Started workers")

	w := watcher.New()

	go func() {
		for {
			select {
			case event := <-w.Event:
				fmt.Printf("Change detected: %s\n", event.Path)
				match, _ := regexp.MatchString(*watchRegex, event.Path)
				if match && !strings.Contains(event.Path, "tmp.exe") {
					changeDetected <- true
				}
			case err := <-w.Error:
				log.Fatalln(err)
			case <-w.Closed:
				return
			}
		}
	}()

	// Watch test_folder recursively for changes.
	if err := w.AddRecursive(*watchDir); err != nil {
		log.Fatalln(err)
	}

	if err := w.Start(time.Millisecond * 100); err != nil {
		log.Fatalln(err)
	}
}
