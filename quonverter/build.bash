#!/bin/bash
./quon compiler.qon   > quon.c
gcc -O2 -flto   quon.c -Wl,-stack_size,4000000 -o quon_new
./quon_new --test
./quon_new compiler.qon



./quon_new compiler.qon --java > test.java
mkdir quonverter
javac -d ./ test.java
java -Xss100M -cp . quonverter/MyProgram --test
jar -cvfm MyProgram.jar MANIFEST.MF quonverter/*.class
java -Xss100M -jar MyProgram.jar --test


#./quon_new examples/mandelbrot.qon --java > test.java
#rm -r quonverter
#mkdir quonverter
#javac -d ./ test.java
#java -Xss100M -cp . quonverter/MyProgram --test
#jar -cvfm mandelbrot.jar MANIFEST.MF quonverter/*.class
#java -Xss100M -jar mandelbrot.jar --test

./quon_new compiler.qon --lua > test.lua
lua test.lua  compiler.qon --ast
