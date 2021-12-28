package main

import (
	"bytes"
	"io/ioutil"
	"io"
	"log"
	"os"
	"os/exec"
	"github.com/chzyer/readline"
	"time"

	"github.com/nsf/termbox-go"
)


var SubProcHandle *exec.Cmd
var InterActiveSub bool
var StopCopy chan bool

type subprocpipes struct {
	Stdin io.WriteCloser
	Stdout io.ReadCloser
	Stderr io.ReadCloser
}
//Copy from reader to writer
func CopyFilter(reader io.Reader, writer io.Writer) {
	log.Printf("Started copyfilter")
	buf := make([]byte, 1024, 1024)
	for {
		n, err := reader.Read(buf)
		if err != nil {
			break
		}
		if bytes.Contains(buf[:n], []byte{3} ) || 
		bytes.Contains(buf[:n], []byte{4} ) || 
		bytes.Contains(buf[:n], []byte("z") ) {
			log.Println("Ctrl-C detected, exiting")
			SubProcHandle.Process.Kill()
			termbox.Clear(termbox.ColorDefault, termbox.ColorDefault)
			termbox.Close()
			os.Exit(1)
		}
		writer.Write(buf[:n])
	}
}

func QuickCommandInteractivePrep(strs []string) (*subprocpipes, *exec.Cmd) {
	cmd := exec.Command(strs[0], strs[1:]...)
	stdinreader, stdinwriter := io.Pipe()
	outreader, outwriter := io.Pipe()
	errreader, errwriter := io.Pipe()
	//go io.Copy(stdinwriter, os.Stdin)
	go CopyFilter(os.Stdin, stdinwriter)
	go io.Copy(os.Stdout, outreader)
	go io.Copy(os.Stderr, errreader)
	cmd.Stdin = stdinreader
	cmd.Stdout = outwriter
	cmd.Stderr = errwriter
	sub := subprocpipes{stdinwriter, outreader, errreader}
	return &sub, cmd
}

func main () {
	log.SetOutput(ioutil.Discard)
	//termbox.Init()
	command := os.Args[1:]
	_,cmd := QuickCommandInteractivePrep(command)
	SubProcHandle = cmd
	
	log.Printf("Guardian: starting %+v\n", command)
	l, _ := readline.New("")
	l.Terminal.EnterRawMode()
	cmd.Start()
	/*
	for cmd.ProcessState==nil {
		time.Sleep(time.Second)
	}
	for ! cmd.ProcessState.Exited() {
		time.Sleep(time.Second)
	}
	*/
	
	cmd.Process.Wait()

	log.Println("Subprocess exited, exiting guardian now")
	time.Sleep(time.Millisecond)
	//termbox.Clear(termbox.ColorDefault, termbox.ColorDefault)
	//termbox.Close()
	//l.Terminal.Close()

	l.Terminal.ExitRawMode()
	os.Exit(0)
	
}