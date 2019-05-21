#!/bin/bash
./quon compiler.qon   > quon.c
gcc -O3   quon.c -o quon_new
./quon_new --test
#./quon_new compiler.qon
./quon_new compiler.qon --perl > test.pl
perl test.pl --test
