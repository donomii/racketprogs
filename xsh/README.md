# XSH

A cross platform shell and scripting language

## Description

A cross platform scripting language that supports interactive development and full integration with command line utilities.

## Examples

    puts [if 1 { "Hello" } { "Goodbye" }] " world"

Lambdas are supported

    {{a} puts [+ a b]} "Hello"

    {{a b c} [puts [+ a b]] [puts b]} 1 2 "Hello"

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

Run [command arg1 arg2 ...] interactively.  The current stdin, stdout and stderr will be re-used for the command.

### [proc *name* {arg1 arg2 ...} { [command ...][command ...]}]

Define a function called *name*.

Lambdas are defined slightly differently, with the args inside the lambda:

    {{arg1 arg2 ...}  command ...}
    {{arg1 arg2 ...}  [command ...][command ...]}

Note that there are no lexical scopes (all variables are global, only function args are local), so lambdas are the closest thing XSH has to variable definitions.

Free variables are substituted _before_ the lambda (or function) is created, which effectively provides immutable lexical scoping.

Function args are substituted directly into the function body when the function is called, meaning that variables are immutable and cannot be re-bound (although they can be shadowed).

### [exit *value*]

Quit and set the system return *value*.

### if *bool* {[command ...][command ...]} {[command ...][command ...]} 

### [saveInterpreter *filename*]

Save the current execution state to be resumed later.

Save files can be resumed with 

    xsh -r *filename*

