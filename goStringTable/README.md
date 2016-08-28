# goSym
A symbol table for Go

## Description

A symbol table turns strings into numbers.  It works like a hash, but it is lock-free to read.  The fast path is very fast.

## Use

symTab := goSym.New()
mySym := symTab.GetOrAdd("Hello World")
fmt.Println(symTab.GetString(mySym))

