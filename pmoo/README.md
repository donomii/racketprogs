# This is pmoo, a MOO written in Golang.

It is loosely inspired by LambdaMOO, but doesn't share any code with it.  I have tried to follow the general design of LambdaMOO, and I am working while looking at LambdaMOO source code, playing on my own LambdaMOO instance and reading the LambdaMOO docs, but the result is significantly different in every way.  It is LambdaMOO with the benefit of 25 years of programming language progress making it better and worse in parts.  

This is not an attempt to recreate the classic online MOOs.  I'm probably never going to bother recreating the complex security system that was needed to allow strangers to interact with each other on a shared server.  Instead, this is an attempt to use the MOO concept in other projects.  I have no idea how it will turn out, but it's the most fun programming project that I have done in a long time.

There is a list of major differences below.

Warning:  There is currently no security system, at all.  Do not allow strangers to access pmoo.  The coordinator node exposes API endpoints with no security checks at all.  Only run cluster mode on a fully secure network!


## Install


### Quickinstall

#### Make

	make install
	make init

init will create an object database in the build directory.  You can then run your MOO with

	cd build && pmoo

If using windows, run Makefile.bat

Note that if there is no objects directory, pmoo will use ~/.pmoo/objects

### Local install

You can install pmoo into your home directory:

	make localinstall
	cat create.txt | p --init 

And then use pmoo in command line integration mode.

	~/.local/bin/p look

Add ~/.local/bin to your path so you can type

	p look


### Cluster install

	To run as a distributed cluster, pmoo requires a networked queue server and networked object database.  The queue program provides this service.

	go build github.com/donomii/racketprogs/queue
	queue &

There should be only one queue server running, it is the coordinator for the cluster.


	cat create.txt | ./pmoo --cluster --queue http://127.0.0.1:8080 --init

Now, to add a computer to the cluster

	rlwrap ./pmoo --cluster --clusterQ --queue http://192.168.178.22:8080


Nodes are part of the cluster so long as the command is running.  Message processing happens in the background.

Cluster mode is currently under development and is extremely unstable.  Doing things like entering multiple commands quickly can lead to errors, as the commands are not sure to run sequentially.



## The scripting language is golang

 I don't have the time to completely recreate MOOcode.  I can't find many useful objects written in MOOcode, so it isn't really worth the effort anyway.

The scripting language is not currently sandboxed, so it has access to the entire Golang library.  This means it is capable of formatting your hard drive, so allowing strangers access to this MOO is an exceptionally bad idea.

Due to issues with the go scripting library, I added a temporary scripting langauge called Xsh, which is a command line scripting language that integrates well with pmoo.

## Clusters and the actor model

Pmoo is clustered.  The original MOOs were single computer, and usually single thread.  They used integer ids for objects, probably as an index into an array of objects.  Pmoo adds the ability to run on a cluster of CPUs, by passing messages through a message bus.  At the moment, objects are still kept in a central object store that is accessed directly by all pmoo nodes in the cluster.

Because messages can now run on different CPUs, any message can be evaluated on any pmoo node.  This is fine when all the nodes are identical, but I want to use pmoo to access cameras or other hardware.  One of my goals is to access external hardware like webcams, and also to allow for special network configurations, e.g. where one node has special network access and the rest are just compute nodes.  To achieve this, some objects are marked with an "affinity" property, and their code will only run on a node marked with the same affinity.

The actor model of computation works in this situation.  Actors are roughly the same as MOO objects, they both communicate by sending each other messages.  The main issue here is that pmoo allows user scripting, so the interpreter requires special support to allow a subroutine to jump to the correct affinity node, or all programs will need to be written in Continuation Passing Style (or async handlers).  This means that each subroutine must end by sending a message, and then processing would continue when that message is received.

# The differences

With pmoo now adding a clustering mode, there seems to be little point to keeping a list of differences, because everything is different in cluster mode.  So in general, I'm still following the old MOOs as a guide, but the actual similarities are mostly limited to command names and basic concepts like "having objects" 

## Objects don't have index numbers at all

Original MOOs used, numeric object ids, but pmoo uses GUIDs for object identifiers.  Pmoo needs to be able to allocate objects without contacting a central service.  This allows some nice features like offline mode, and being able to move objects from one MOO to another. In particular, I can carry a local copy of my MOO on my laptop, update it, then merge it with the MOO on my desktop when I get home.

The drawback is that this makes it horrible to try and type an object name on the command line.

## You can't have a verb and a property called the same thing (in the same object)

Original MOOs allowed players to make an object with "verbs" and "properties", and a verb and a property could have the same name.  Pmoo does not allow verbs and properties to have the same name.

Properties and verbs are now stored in the same data structure with a flag to tell them apart.  This was to make data storage easier, and simplify the code that has to deal with them.  So now you can't have a verb called "name" and a property called "name" at the same time.

## Built in commands

You can enter scripting commands by starting them with "x ".

* x allobjects
* x setprop object_id property_name value
* x findobject "The First Room"
* x getprop object_id property_name
* x clone object_id
* x formatobject object_id
* x msg from_id target_id verb dobj_id preposition iobj_id 
* clone $thing as "A name"
* x move %2 to %3


# The rest

As far as possible, everything else works the same, or at least reasonably similar.  The parser, the default names for commands, etc are as similar as I can make them.  So you can log in, look at things, move around, create rooms and script objects.  You can also script objects to do work _outside_ the MOO, which should be interesting.  System calls are possible, so you can now create pmoo objects to represent parts of the system, and then control your computer via pmoo.
