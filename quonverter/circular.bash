#!/bin/bash
./quon1 compiler.qon   > quon2.c
rm quon2
gcc -O3 quon2.c -o quon2 -Wno-unknown-escape-sequence
./quon2 --test
#./quon_new compiler.qon
./quon2 compiler.qon > quon1.c
diff quon1.c quon2.c
rm quon1
gcc -O3 quon1.c -o quon1 -Wno-unknown-escape-sequence
bash circular.bash
