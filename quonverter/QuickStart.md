# Quick Start

Quonverter is a compiler that compiles programs to other languages - it is a _transpiler_.  It can also compile itself to other languages, so it exists in many forms.  This guide assumes that you are using a compiled binary version, but the same instructions work for perl, python, etc

## Tests

Quonverter has manu built-in tests that we use during development.  Run them with 

    quon --test

## Compiling a program

    quon source.quon

The quonverter will compile your program into as many languages as it can.  Each file will be called "out.xxx", where xxx is the appropriate extension for that langauge.
