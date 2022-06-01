Nursemai daemon, a crossplatform usermode daemon manager

Nursemai Starts and monitors daemons, but in usermode.  It is not quite an init.d replacement, but does many of the same functions.

Nursemai reads a list of programs from a file, starts them and monitors them.  If they exit it restarts them.

It is useful to put it in your .bashrc file as it can start and restart helpful programs like search tools, popup note tools, and anything else you want to have always running and ready.

And of course it can start traditional daemons as well.

At the moment, it /doesn't/ handle shutdowns, so using it for your database server is not a great idea.

== Install

    make

Running make will compile and install nursemaid to /usr/local/bin and ~/.local/bin.  The example config file will be placed in /etc/nursemaid/services.txt and ~/.local/etc/nursemaid/services.txt