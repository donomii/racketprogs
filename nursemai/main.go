package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"

	"github.com/arkady-emelyanov/go-shellparse"
	"github.com/donomii/goof"
	"github.com/nightlyone/lockfile"
)

var configFile = "services.txt"
var logsDir = "logs"

func main() {

	lock, err := lockfile.New(filepath.Join(os.TempDir(), "nursemaid.lck"))
	if err != nil {
		fmt.Printf("Cannot init lock. reason: %v", err)
		panic(err) // handle properly please!
	}

	// Error handling is essential, as we only try to get the lock.
	if err = lock.TryLock(); err != nil {
		fmt.Printf("Nursemai is already running.\n")
		fmt.Printf("Cannot lock %q, reason: %v\n", lock, err)
		os.Exit(1)
	}

	defer func() {
		if err := lock.Unlock(); err != nil {
			fmt.Printf("Cannot unlock %q, reason: %v", lock, err)
			panic(err) // handle properly please!
		}
	}()

	//Set configFile to the path to a config file
	flag.StringVar(&configFile, "config", "services.txt", "Path to config file")
	flag.Parse()

	//If config file doesn't exist, fallback to local file
	_, err = os.Stat(configFile)
	if configFile == "" || os.IsNotExist(err) {
		if configFile != "" {
			fmt.Println("Config file not found: ", configFile)
			fmt.Println("Falling back to local file in ~/.local/etc/nursemaid/services.txt")
		}
		configFile = "~/.local/etc/nursemaid/services.txt"
	}

	log.Println("Nursemaid reading config from: ", configFile)

	//Read the config file
	text, err := ioutil.ReadFile(configFile)
	if err != nil {
		panic(err)
	}
	//Split text into lines
	lines := strings.Split(string(text), "\n")

	//Make logs directory
	os.Mkdir(logsDir, 0777)

	//For each line, create a worker to run the service
	for _, line := range lines {
		//Split the line into the service name and the command
		parts := strings.SplitN(line, " ", 2)
		if len(parts) != 2 {
			continue
		}
		//Create a worker to run the service
		go runService(parts[0], parts[1])
	}

	//Intercept signals
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT, syscall.SIGHUP)
	handleSignals(sigChan)
	//Sleep
	for {
		fmt.Println(".")
		time.Sleep(time.Second * 1)
	}

}

func runService(name, command string) {
	logPath := logsDir + "/" + name + ".log"
	//Open the log file
	logFile, err := os.OpenFile(logPath, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		panic(err)
	}
	for {
		//Run the service
		//Create command

		bin, args, err := shellparse.Command(command)
		cmd := exec.Command(bin, args...)
		//Capture the command STDERR
		stderr, err := cmd.StderrPipe()
		if err != nil {
			panic(err)
		}
		//Capture the command STDOUT
		stdout, err := cmd.StdoutPipe()

		if err != nil {
			panic(err)
		}
		//Create stderr buffer
		stderrBuf := make([]byte, 1024)
		//Create a worker to monitor the STDERR pipe
		go func() {
			for {
				//Read the STDERR
				_, err := stderr.Read(stderrBuf)
				if err != nil {
					log.Println("Stderr reader for", name, "failed:", err)
				}
				//Print the STDERR
				fmt.Println(string(stderrBuf))
				//Write the STDERR to the log file
				_, err = logFile.Write(stderrBuf)
			}
		}()

		stdoutBuf := make([]byte, 1024)

		//Create a worker to monitor the STDOUT pipe
		go func() {
			for {
				//Read the STDOUT
				_, err := stdout.Read(stdoutBuf)
				if err != nil {
					log.Println("Stdout reader for", name, "failed:", err)
				}
				//Print the STDOUT
				fmt.Println(string(stdoutBuf))
			}
		}()

		fmt.Println("Starting service: ", name, " with command: ", bin, args)
		//Start the command
		cmd.Start()
		err = cmd.Wait()
		if err != nil {
			fmt.Println("Service: ", name, " stopped with error: ", err)
		}
		fmt.Println("Service: ", name, " stopped")
		time.Sleep(time.Second * 5)

	}
}

func handleSignals(sigChan chan os.Signal) {
	for {
		sig := <-sigChan
		switch sig {
		case syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
			fmt.Println("\nExiting...")
			os.Exit(0)
		case syscall.SIGHUP:
			fmt.Println("\nReloading config...")
			goof.Restart()
		}
	}
}
