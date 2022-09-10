package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
)



func main() {
	// Get cli args
	args := os.Args[1:]
	// Make a quoted list of args
	// fmt.Println()
	fmt.Println(askQuestion(strings.Join(args, " ")))
}
