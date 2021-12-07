package main

//import filewalk and glob
import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
)

//read directory and file mask from
func parseFlags() (string, string) {
	var fileMask = flag.String("name", "", "file mask")
	flag.Parse()
	startDir := flag.Arg(0)
	return startDir, *fileMask
}

func main() {
	startDir, fileMask := parseFlags()
	log.Println("Start dir: ", startDir, " file mask: ", fileMask)
	if startDir == "" || fileMask == "" {
		fmt.Println("Usage: go run main.go <start_dir> <file_mask>")
		return
	}
	//recursively visit all files in directory
	filepath.Walk(startDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			fmt.Println(err)
			return nil
		}
		if info.IsDir() {
			return nil
		}

		if matched, _ := filepath.Match(fileMask, info.Name()); matched {
			fmt.Println(path)
		}
		return nil
	})
}
