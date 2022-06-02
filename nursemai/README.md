Nursemai daemon, a crossplatform usermode daemon manager

Nursemai Starts and monitors daemons, but in usermode.  It is not quite an init.d replacement, but does many of the same functions.

Nursemai reads a list of programs from a file, starts them and monitors them.  If they exit it restarts them.

It is useful to put it in your .bashrc file as it can start and restart helpful programs like search tools, popup note tools, and anything else you want to have always running and ready.

And of course it can start traditional daemons as well.

At the moment, it /doesn't/ handle shutdowns, so using it for your database server is not a great idea.

== Install

    make

Running make will compile and install nursemaid to /usr/local/bin and ~/.local/bin.  The example config file will be placed in /etc/nursemaid/services.txt and ~/.local/etc/nursemaid/services.txt

== Starting

    nursemaid -config services1.txt -config services2.txt

Nursemaid has only one option, -config to specify the paths to config files.  You can have multiple config files, they will all be read.  So you can have a global config file, and a user specific one at the same time.

== services.txt

The services format is
    service_name command arg1 arg2 arg3

The first word is the service name, everything else is the command to launch it.  The commands are not interpreted in any way, environment variables, shell builtins etc will not work.