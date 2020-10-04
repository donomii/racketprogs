package main

import (
	"fmt"
	"strconv"
	"strings"
)

func int2perms(bperms int64) string {
	bitstring := strconv.FormatInt(bperms, 2)
	bits := strings.Split(bitstring,"")
	pattern := "rwxSrwxSrwxS----"
	var out string
	for i, v := range bits {
		flag := string(pattern[i])
		if v == "1" {
			out =  string(flag) + out
		} else {
				out = out + "-"
			
		}		
	}
	return out
}

func main() {
	fmt.Println(int2perms(0x1771))
}
