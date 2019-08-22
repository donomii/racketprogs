quon.exe compiler.qon   > quon.c
gcc -O3 -Wl,--stack=99999999 quon.c -o quon_new
quon_new.exe --test
quon_new compiler.qon --perl  > test.pl
perl test.pl --test
quon_new compiler.qon --node  > test.js
node --stack-size=6000 test.js --test
mkdir quonverter
quon_new compiler.qon --java  > quonverter\test.java
cd quonverter
javac test.java
cd ..
jar cvfm quonverter.jar MANIFEST.MF quonverter\*.class
java -Xmx1024M -Xss64M -jar quonverter.jar --test

