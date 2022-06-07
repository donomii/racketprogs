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
	"sync"
	"syscall"
	"time"

	"github.com/arkady-emelyanov/go-shellparse"
	"github.com/donomii/goof"
	"github.com/nightlyone/lockfile"
)

var logsDir = "logs"

type ConfigsValue []string

var configs = ConfigsValue{}

func (arr *ConfigsValue) String() string {
	return ""
}

func (arr *ConfigsValue) Set(value string) error {
	*arr = append(*arr, strings.TrimSpace(value))
	return nil
}

//Keep a map of all currently running commands
var running sync.Map

//Signal all threads to exit
var wantShutdown bool

func main() {
	services := [][]string{}
	running = sync.Map{}

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
	//flag.StringVar(&configFile, "config", "services.txt", "Path to config file")
	flag.Var(&configs, "config", "Path to config file (can repeat)")
	flag.Parse()

	if configs == nil || len(configs) == 0 {
		configs = []string{"/etc/nursemaid/services.txt", goof.HomePath(".local/etc/nursemaid/services.txt"), "services.txt"}
	}

	for _, configFile := range configs {
		//If config file doesn't exist, fallback to local file
		_, err = os.Stat(configFile)
		if configFile == "" || os.IsNotExist(err) {
			if configFile != "" {
				log.Printf("Config file not found, skipping: %v", configFile)
				continue
			}
			continue
		}

		log.Println("Nursemaid reading config from: ", configFile)

		//Read the config file
		text, err := ioutil.ReadFile(configFile)
		if err != nil {
			log.Printf("Error reading %v: %v", configFile, err)
			continue
		}
		//Split text into lines
		lines := strings.Split(string(text), "\n")
		for i, line := range lines {
			parts := strings.SplitN(line, " ", 2)
			if len(parts) != 2 {
				log.Printf("Invalid service definition at line %v: %v", i, line)
				continue
			}
			services = append(services, parts)
		}
	}
	//Make logs directory
	os.Mkdir(logsDir, 0777)

	//For each service, create a worker to run the service
	for _, parts := range services {

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
		if wantShutdown {
			return
		}
		//Run the service
		//Create command

		bin, args, err := shellparse.Command(command)
		cmd := exec.Command(bin, args...)
		//Close stdin
		cmd.Stdin = nil
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
				if wantShutdown {
					return
				}
				//Read the STDERR
				_, err := stderr.Read(stderrBuf)
				if err != nil {
					//log.Println("Stderr reader for", name, "failed:", err)
					return
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
				if wantShutdown {
					return
				}
				//Read the STDOUT
				_, err := stdout.Read(stdoutBuf)
				if err != nil {
					//log.Println("Stdout reader for", name, "failed:", err)
					return
				}
				//Print the STDOUT
				fmt.Println(string(stdoutBuf))
			}
		}()

		//Start a new process group
		cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}

		fmt.Println("Starting service: ", name, " with command: ", bin, args)
		//Start the command
		cmd.Start()
		running.Store(name, cmd)
		err = cmd.Wait()
		if err != nil {
			fmt.Println("Service: ", name, " stopped with error: ", err)
		}
		fmt.Println("Service: ", name, " completed.")
		running.Delete(name)
		if !wantShutdown {
			log.Println("Restarting", name, "...")
			time.Sleep(time.Second * 5)
		}

	}
}

func handleSignals(sigChan chan os.Signal) {
	for {
		sig := <-sigChan
		switch sig {
		case syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
			fmt.Println("\nExiting...")
			wantShutdown = true
			var wg sync.WaitGroup
			running.Range(func(keyi, vali interface{}) bool {
				name := keyi.(string)
				cmd := vali.(*exec.Cmd)
				log.Printf("Killing %v", name)
				wg.Add(1)
				go func() {
					pid := -cmd.Process.Pid
					log.Printf("Sending signals to %v", pid)
					syscall.Kill(pid, syscall.SIGHUP)
					time.Sleep(1 * time.Second)
					syscall.Kill(pid, syscall.SIGQUIT)
					time.Sleep(1 * time.Second)
					syscall.Kill(pid, syscall.SIGKILL)
					time.Sleep(1 * time.Second)
					syscall.Kill(pid, syscall.SIGTERM)
					time.Sleep(1 * time.Second)
					cmd.Process.Kill()
					var keepWaiting = true
					for keepWaiting {
						_, keepWaiting = running.Load(name)
						time.Sleep(100 * time.Millisecond)
					}
					wg.Done()
				}()
				return true
			})
			wg.Wait()
			os.Exit(0)
		case syscall.SIGHUP:
			fmt.Println("\nReloading config...")
			goof.Restart()
		}
	}
}
