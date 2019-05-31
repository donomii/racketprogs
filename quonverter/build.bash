#!/bin/bash
./quon compiler.qon   > quon.c
gcc -O3   quon.c -o quon_new
./quon_new --test
#./quon_new compiler.qon
./quon_new compiler.qon --java > test.java
mkdir quonverter
javac -d ./ test.java
java -cp . quonverter/MyProgram
jar -cvfm MyProgram.jar MANIFEST.MF quonverter/*.class
java -jar MyProgram.jar
