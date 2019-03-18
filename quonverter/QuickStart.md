# Quick Start

Quonverter is a compiler that compiles programs to other languages - it is a _transpiler_.  It can also compile itself to other languages, so it exists in many forms.  This guide assumes that you are using a compiled binary version, but the same instructions work for perl, python, etc

## Tests

Quonverter has many built-in tests that I use during development.  Run them with 

    quon --test

## Compiling a program

    quon source.qon > source.c

The quonverter will compile your program into as many languages as it can.  The compiled code will be printed out, you will need to redirect it to a file.

You should compile the C code with optimisations switched on.  For GCC, this means using the -O3 flag

    gcc -O3 source.c

Quonverter uses a lot of recursion, and -O3 switches on tail calls to prevent running out of stack space.

## Hello world



    [[includes base.qon]
     [types]

     [functions

      [int start [] [declare]
           [body
            [printf "Hello world\n"]
            [return 0]
            ]] ]]

There are few things to note here:

* All programs must have a "start" routine that returns a success code, which will be used as the status of your program when it finishes.  The start routine is the "main" routine, it is called when your program starts.
* This is a typed language.  You can use any types from the target language, and quonverter provides some portable types:  int, float, string and box.
* Printf calls the native printf.  You can call any functions from your target language without having to declare them first.
* This is not LISP or SCHEME.  It looks like it, due to the syntax, but is actually a simple compiled language much closer to C and Pascal than LISP or any plang.

## Learning more

The examples directory contains simple programs that test the compiler
