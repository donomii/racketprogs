quon.exe compiler.qon   > quon.c
gcc -O3 -Wl,--stack=99999999 quon.c -o quon_new
quon_new.exe --test
quon_new compiler.qon --java  > test.java
javac test.java
