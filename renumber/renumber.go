// renumber
package main

import (
	"fmt"
	"os"
)

func main() {
	last_target := 0
	for i := 0; i < 99999999; i++ {
		source := fmt.Sprintf("progress-%v.png", i)
		//fmt.Println("Checking ", source)
		if _, err := os.Stat(source); err == nil {
			target := fmt.Sprintf("prog-%v.png", last_target)
			fmt.Printf("moving %v to %v\n", source, target)
			os.Rename(source, target)
			last_target = last_target + 1
		}
	}
}
