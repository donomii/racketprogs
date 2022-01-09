# XSH

A cross platform shell and scripting language

## Description

A cross platform scripting language that supports interactive development and full integration with command line utilities.

## Example

    puts [if 1 { "Hello" } { "Goodbye" }] " world"


## Built in commands

### [seq [command] [command] [command] ...]

Runs each command in sequence, returns the value of the last command

### [cd directory]

Change directory, as usual

### [puts "message" "message"]

Print messages, followed by a newline

### [set *name* *value*]

Set *name* to *value*.  Note that all variables are global.

### [loadfile *filename*]

Load *filename* as a string.

### [run command arg1 arg2 ...]

Run [command arg1 arg2 ...] interactively.

### [proc *name* {arg1 arg2 ...} { [command ...][command ...]}

Define a function called *name*.

### [exit *value*]

### if *bool* {[command ...][command ...]} {[command ...][command ...]} 

### [saveInterpreter *filename*]

Save the current execution state to be resumed later

