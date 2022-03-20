package main

import (
	"flag"
	"fmt"
	"log"
	"os/exec"
	"regexp"
	"runtime"
	"strings"
	"time"

	"github.com/donomii/goof"
	"github.com/radovskyb/watcher"
)

var ignoreEvents bool

func ShellBackground(shellcmd string) *exec.Cmd {
	var cmd *exec.Cmd = nil
	switch runtime.GOOS {
	case "linux":
		cmd = exec.Command("/bin/sh", "-c", shellcmd)
	case "windows":
		cmd = exec.Command("c:\\Windows\\System32\\cmd.exe", "/c", shellcmd)
	case "darwin":
		cmd = exec.Command("/bin/sh", "-c", shellcmd)
	default:
		log.Println("unsupported platform when trying to run application")
	}
	cmd.Start()
	return cmd
}

func main() {

	watch := flag.String("watch", "./", "Directory to watch")
	watchRegex := flag.String("regex", ".*", "Regex to match files to watch")
	buildCmd := flag.String("build", "go build -o tmp.exe .", "Command to build")
	runCmd := flag.String("run", "./tmp.exe", "Command to run")
	flag.Parse()

	var changeDetected chan bool = make(chan bool)
	var buildComplete chan bool = make(chan bool)

	fmt.Printf("Watching for changes in %s\n", *watch)
	fmt.Printf("Regex: %s\n", *watchRegex)

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
		var cmd *exec.Cmd = nil
		for {
			<-buildComplete
			if cmd != nil {
				fmt.Printf("Killing %v\n", *runCmd)
				cmd.Process.Kill()
				cmd.Process.Release()
			}
			fmt.Printf("Running %v\n", *runCmd)
			cmd = ShellBackground(*runCmd)
			ignoreEvents = false

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
					if !ignoreEvents {
						ignoreEvents = true
						changeDetected <- true
					} else {
						fmt.Printf("Ignoring event: %s\n", event.Path)
					}
				}
			case err := <-w.Error:
				log.Fatalln(err)
			case <-w.Closed:
				return
			}
		}
	}()

	// Watch test_folder recursively for changes.
	if err := w.AddRecursive(*watch); err != nil {
		log.Fatalln(err)
	}

	if err := w.Start(time.Millisecond * 100); err != nil {
		log.Fatalln(err)
	}
}
