#!/bin/bash
./quon compiler.qon   > quon.c
gcc -O3 quon.c -o quon_new
./quon_new --test
