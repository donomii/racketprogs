# XSH

A cross platform shell and scripting language

## Description

A cross platform shell and scripting language.

A homoiconic functional scripting language that works by tree reduction.
## Examples

    set greet "Hello world"
    echo $greet

 If you want to call another program, use [ ] brackets (instead of $() in bash).
    
    puts "Directory:" [ls]
    puts "USB devices:" [lsusb]

Functions also work like normal shell commands. Use [ ] brackets to call sub-functions, just like calling programs in the shell.  You don't need commas, and you usually don't need quotes either.

    puts 2 + 2 equals [+ 2 2]

## The language

### If statements

    if [gt n 0] {
        countdown [- n 1]
    } else {
        puts "Countdown complete"
    }

    if [eq line "you're happy and you know it"] {
        clap your hands
    }
### Functions

Define functions with *func*.


	func {arg1 arg2 arg ...|
		expression
		expression
		...
		expression
	 }

The last expression is the return value of the function.

    func countdown { n |
        puts n
        if [gt n 0] {
                countdown [- n 1]
        }
    }

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

func {arg1 arg2 arg ... | expression }

If you use the single line declaration, you can only write one expression.  But that expression can be _seq_.

    func countdown { n | seq [puts n] [if [gt n 0] { countdown [- n 1] }]}

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

### seq [command] [command] [command] ...

Runs each command in sequence, returns the value of the last command

### cd *directory*

Change to *directory*, as usual

### +,-,*,/

The usual math functions

### gt, lt

Greater than, and less than.  Because <> is too useful to waste on math functions.

### eq *arg1* *arg2*

Returns true if *arg1 arg2* are equal, false otherwise.

### puts "message" "message"

Print messages, then a newline

### dump *arg*

Create a string version of *arg*

### set *name* *value*

Set environment varible *name* to *value*.

All variables are global.  You can't declare local variables, except using function args, which are immutable.

You can access environment variables with *$name*.

### loadfile *filename*

Load *filename* as a string.

### run command arg1 arg2 ...

Run external program [command arg1 arg2 ...] interactively.  The current stdin, stdout and stderr will be re-used for the command.

### proc *name* {arg1 arg2 ...} { [command ...][command ...]}

Define a function called *name*.


Note that there are no lexical scopes (all variables are global, only function args are local), so lambdas are the closest thing XSH has to variable definitions.

Free variables are substituted _before_ the lambda (or function) is created, which effectively provides immutable lexical scoping.

Function args are substituted directly into the function body when the function is called, meaning that variables are immutable and cannot be re-bound (although they can be shadowed).

### exit *value*

Quit and set the system return *value*.

### if *bool* {[command ...][command ...]} else {[command ...][command ...]} 

### saveInterpreter *filename*

Save the current execution state to be resumed later.

Save files can be resumed with 

    xsh -r *filename*

### cons *arg* *array*

Adds *arg* to the start of *array*.  The old list is not changed, a new list is created.

### empty? *list*

Returns true if *list* is empty.

### length *list*

Returns number of items in *list*

### lindex *index* *array*

Returns item at position *index* in *array*

### lrange *list* *start* *end*

Returns a sublist of *list*, starting at *start*, ending at *end*

### split *string* *delimiter string*

Splits *string* at every *delimiter*, returns the pieces as an array.

### join *list* *inter*

Joins *list* together by placing *inter* between each element of *list*.  Returns a string.

### chr *integer*

Returns a string containing the unicode character *integer*


## Advanced language features


### Lambda functions (anonymous functions)

Lambdas are defined like functions, with the args inside the lambda:

    {arg1 arg2 ...|  command}
    {arg1 arg2 ...|  seq [command ...][command ...]}
    
If the lambda is on a single line, it can only have a single expression.  To put multiple statements on a single line, use *seq*.

    {a| puts [+ a b]} 1 2

    {a b c| seq [puts c] [puts [+ a b]] } 1 2 "Result:"

If the lambda is on more than one line, the parameters go on the first line.

     {a b c |
        puts c
        puts [+ a b]
     } 1 2 "Result:"
