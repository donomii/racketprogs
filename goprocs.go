package main;
import (
    "github.com/mitchellh/go-ps"
 "fmt"
 "strings"
 "runtime"
 "os/exec"
 )

func getProcs() map[int]ps.Process {
    procs, _ := ps.Processes()
    procHash := map[int]ps.Process{}
    for _, v := range procs {
        procHash[v.Pid()] = v
    }
    return procHash
}

func chomp(s string) string {
    return strings.TrimSuffix(s, "\n")
}
func extendedPS(pid int) string {
    if runtime.GOOS == "windows" {
        cmd := exec.Command("tasklist.exe", "/fo", "csv", "/nh")
        //Only compiles on windows?
        //cmd.SysProcAttr = &syscall.SysProcAttr{HideWindow: true}
        out, err := cmd.Output()
        if err != nil {
            return ""
        }
        return string(out)
    } else {
    //if runtime.GOOS == "darwin" {
    //if runtime.GOOS == "linux" {
        out := doCommand("ps", []string{ "-o", "command", "-p", fmt.Sprintf("%v",pid)})
        return out
    }
    return ""
}

func escapeStr(s string) string {
    return strings.Replace(s, `"`, `\"`, -1)
}

func printHash(b map[int]ps.Process) {
    outarr := []string{}
    for _, v := range b {
        start := fmt.Sprintf(`{ "pid" : "%v", "name" : "%v", `, v.Pid(), escapeStr(v.Executable()))
            out := chomp(chomp(extendedPS(v.Pid())))
            out = strings.Replace(out, "  PID TTY           TIME CMD\n", "", -1)
            out = strings.Replace(out, "COMMAND\n", "", -1)
            out = fmt.Sprintf(`"command" : "%v"}`, escapeStr(out))
            outarr = append(outarr, start + out)
        }
        fmt.Println(strings.Join(outarr, ",\n"))
    }


func doCommand(cmd string, args []string) string {
    out, err := exec.Command(cmd, args...).CombinedOutput()
    if err != nil {
        //fmt.Fprintf(os.Stderr, "Output: %v", string(out))
        //fmt.Fprintf(os.Stderr, "Error: %v", err)
        //os.Exit(1)
    }
    if string(out) != "" {
        //fmt.Fprintf(os.Stderr, "Output: %v\n\n", string(out))
    }
    return string(out)
}


func main () {
    fmt.Println("[")
    procs := getProcs()
    printHash(procs)
    //fmt.Printf("%+v\n", procs)
    fmt.Println("]")
}
