# grep UI
Text UI for grep and csearch

## Description

grui is a simple, convenient front end to grep and csearch.  When I am looking through a codebase, I often find myself typing 

	csearch "func" . | grep init | grep -v css

or something similar.  grui puts a responsive front end on this, so that I don't have to keep typing '| grep ' over and over again.  It provides a graphical selection, and can launch your favourite editor on the correct file.

grui currently requires csearch to be installed.

## Screenshot

```
                                                                                                                                                                        
Search for:func search                                                                                                                                                  
     /Users/user/Documents/GitHub/grui/main.go (line 81)                                                                                                         
*       (line 81) func search(searchTerm string, numResults int) []ResultRecordTransmittable {                                                                          
        (line 198) func searchLeft(aStr string, pos int) int {                                                                                                          
        (line 210) func searchRight(aStr string, pos int) int {                                                                                                         
                                                                                                                                                                        
                                                                                                                                                                        
                                                                                                                                   
                                                                                                                                                                        
                                                                                                                                                                        
                                                                                                                                                                        
                                                                                                                                                                        
                                                                                                                                                                        
 3 results          map[]                                                                                                                                               
 Type your search terms, add a - to the end of word to remove that word (word-)                                                                                         
 Up/Down Arrows to select a result, Right Arrow to edit that file, Escape Quits  
```

## Installation

	go install github.com/donomii/grui
	export PATH=$PATH:~/go/bin

## Known bugs

grui is not currently threaded, so if the grep search takes a long time, grui will freeze until it finishes.

