// +build windows

package main

import (
	"os/exec"
	"fmt"
	)

//This file contains the windows versions of data source functions.  These functions need to be duplicated in linux.go, but rewritten for *nix

//Run a command in the basic windows cmd.exe shell, and return the result as a chunk of text
func shellout (command []string) string {
	command = append([]string{"/c"}, command...)
	cmd := exec.Command("cmd", command...)
	stdoutStderr, err := cmd.Output()
	if err != nil {
		statuses["Error"] = fmt.Sprintf("%v", err)
	}
	return string(stdoutStderr)
}

//Run a command in the advanced windows powershell.exe shell, and return the result as a chunk of text
func powershellout (command []string) string {
	cmd := exec.Command("powershell", command...)
	stdoutStderr, err := cmd.Output()
	if err != nil {
		statuses["Error"] = fmt.Sprintf("%v", err)
	}
	return string(stdoutStderr)
}

func powershellLines (command []string) []string {
       ret := CacheLines(fmt.Sprintf("%v", command), func ()[]string{return ToLines(powershellout(command))})
       //log.Println(ret)
       return ret
}

//Lookup the search string using the system's help function (help for windows, man for linux)
func man(search string) []string {
	lines := CacheLines("manpage index", func()[]string{return shellLines([]string{"help", search})})
	res := lines[0]
	return []string{res}
}

//Use the system's application registry to look up the search term
func installedApps(search string) []string {
	ret := powershellLines([]string{`Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, InstallLocation`})
	return stringGrep(search, ret);
}

//Offer completion options from the system's help index
func manPredict(search string) []string {
	lines := shellLines([]string{"help"})
	return stringGrep(search, lines)
}

//Search the shell's command history for search string.  Mostly useless on windows
func history(search string) []string {
	return stringGrep(search, shellLines([]string{"doskey", "/History"}))
}

//List all the files in a directory
func directory(directory, search string) []string {
	return stringGrep(search,shellLines([]string{"dir", "/b", "/w", directory}))
}
