// +build !windows

package main

import (
	"strings"
	"log"
	"os"
	"os/exec"
	"fmt"
	)

//This file contains the windows versions of data source functions.  These functions need to be duplicated in windows.go, but rewritten for windows

//Run a command in the basic linux shell, and return the result as a chunk of text
func shellout (command []string) string {
	args := []string{"-c", command[0] + " $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"}
	args = append(args, command[1:]...)
	cmd := exec.Command(os.Getenv("SHELL"), args...)
	stdoutStderr, err := cmd.Output()
	if err != nil {
		statuses["Error"] = fmt.Sprintf("%v", err)
	}
	return string(stdoutStderr)
}

//Lookup the search string using the system's help function (help for windows, man for linux)
func man(search string) []string {
	lines := CacheLines("manpage index", func()[]string{return shellLines([]string{"man", search})})
	return lines
}

//Use the system's application registry to look up the search term
func installedApps(search string) []string {
	return[]string{}
	ret := CacheLines("installed apps", func()[]string{return shellLines([]string{"apt", "list"})})
	return stringGrep(search, ret);
}

//Offer completion options from the system's help index
func manPredict(search string) []string {
	lines := CacheLines("man page predictions", func()[]string{return shellLines([]string{"whatis", "--regex", search})})
	return stringGrep(search, lines)
}

//Search the shell's command history for search string.  Mostly useless on windows
func history(search string) []string {
	return stringGrep(search, shellLines([]string{"history"}))
}

//List all the files in a directory
func directory(directory, search string) []string {
	return stringGrep(search,CacheLines("directory listing for " + directory, func()[]string{return shellLines([]string{"ls", "-l", directory})}))
}



func csearch(search string) []Entry {
	if len(search)>2 {
	args := []string{"csearch", "-n", search}
	log.Println("csearch args: ", args)
	//log.Println("csearch: ", shellLines(args))
	raw := CacheLines("csearch for " + search, 
		func()[]string{return stringGrep(search, shellLines(args))})
		out  := []Entry{}
		for _, l := range raw {
			log.Println("Working on ", l)
			bits := strings.SplitN(l, ":", 3)
			log.Println("csearch bits", bits)
			if len(bits)>1 {
				e := Entry{}
				e.Name = bits[0]
				e.Value = bits[0]
				e.Line = bits[1]
				e.Description = bits[2]
				e.Launch = []string{"vim", "XXXXXX"}
				out = append(out, e)
			}
		}
		return out
	} else {
		return []Entry{}
	}
}


func default_directories(searchTerm string) []string {
	res := []string{}
	h := os.Getenv("HOME")
	for _, d := range []string{h+`/`+ "Downloads", h+`/`+ "bin", `/usr/bin`, `/bin`} {
		res = append(res, directory(d, searchTerm)...)
	}
	return res
}

