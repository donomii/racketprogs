package main

import (
    "strings"
    "io/ioutil"
    "net"
    "os"
    "os/exec"
    "bytes"
    "github.com/donomii/svarmrgo"
    "fmt"
    "encoding/base64"
)

var history [3]string
var hpointer int
var lastNote string


func quickCommand (cmd *exec.Cmd) string{
    fmt.Println()
    fmt.Println("Started command")
    in := strings.NewReader("")
	cmd.Stdin = in
	var out bytes.Buffer
	cmd.Stdout = &out
	var err bytes.Buffer
	cmd.Stderr = &err
	res := cmd.Run()
    fmt.Printf("Command result: %v\n", res)
	ret := fmt.Sprintf("%s\n%s", out, err)
    fmt.Println(ret)
    return ret
}

func handleMessage (conn net.Conn, m svarmrgo.Message) {
    switch m.Selector {
         case "reveal-yourself" :
            svarmrgo.RespondWith(conn, svarmrgo.Message{Selector: "announce", Arg: "noteProcessor"})
         case "shutdown" :
            os.Exit(0)
         case "take-picture" :
    }
}

func main() {
    conn := svarmrgo.CliConnect()
    filename := os.Args[3]
    pic, _ := ioutil.ReadFile(filename)
    enc_pic := base64.StdEncoding.EncodeToString(pic)
    svarmrgo.RespondWith(conn, svarmrgo.Message{Selector: "image", Arg: enc_pic})
}
