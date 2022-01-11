# XSH

A cross platform shell and scripting language

## Description

A cross platform scripting language that supports interactive development and full integration with command line utilities.

## Examples

    puts [if 1 { "Hello" } { "Goodbye" }] " world"

Lambdas are supported

    {{a} puts [+ a b]} "Hello"

    {{a b c} [puts [+ a b]] [ puts b]} 1 2 "Hello"

    proc countdown { n } { if [> n 0] {[puts n] [countdown [- n 1]]} {}

    » countdown 10
    10
    9
    8
    7
    6
    5
    4
    3
    2
    1
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

### [proc *name* {arg1 arg2 ...} { [command ...][command ...]}]

Define a function called *name*.

Lambdas are defined slightly differently, with the args inside the lambda:

    {{arg1 arg2 ...}  command ...}
    {{arg1 arg2 ...}  [command ...][command ...]}

Note that while there are no lexical scopes (all vars are global, only function args are local), 

### [exit *value*]

### if *bool* {[command ...][command ...]} {[command ...][command ...]} 

### [saveInterpreter *filename*]

Save the current execution state to be resumed later

