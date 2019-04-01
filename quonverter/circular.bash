#!/bin/bash
./quon compiler.qon   > quon.c
gcc -O3 quon.c -o quon_new -Wno-unknown-escape-sequence
./quon_new --test
#./quon_new compiler.qon
./quon_new compiler.qon > quon_new.c
gcc -O3 quon_new.c -o quon -Wno-unknown-escape-sequence
bash circular.bash
