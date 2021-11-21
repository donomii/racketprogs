# This is pmoo, a MOO written in Golang.

It is loosely inspired by LambdaMOO, but doesn't share any code with it.  I have tried to follow the general design of LambdaMOO, and I am working while looking at LambdaMOO source code, playing on my own LambdaMOO instance and reading the LambdaMOO docs, but the result is significantly different in every way.  It is LambdaMOO with the benefit of 25 years of programming language progress making it better and worse in parts.  

This is not an attempt to recreate the classic online MOOs.  I'm probably never going to bother recreating the complex security system that was needed to allow strangers to interact with each other on a shared server.  Instead, this is an attempt to use the MOO concept in other projects.  I have no idea how it will turn out, but it's the most fun programming project that I have done in a long time.

There is a list of major differences below.

Warning:  There is currently no security system, at all.  Do not allow strangers to access pmoo.  The coordinator node exposes API endpoints with no security checks at all.  Only run cluster mode on a fully secure network!


## Install


### Quickstart

Build and run in the current directory

	go build .
	mkdir objects
	cat create.txt | ./pmoo --init
	./pmoo

This creates pmoo, and sets up some basic verbs (stored in create.txt).  

Note that if there is no objects directory, pmoo will use ~/.pmoo/objects

### Local install

You can install pmoo into your home directory:

	make install
	cat create.txt | p --init 

And then use pmoo in command line integration mode.

	~/.local/bin/p look

Add ~/.local/bin to your path so you can type

	p look


### Cluster install

	go build github.com/donomii/racketprogs/queue
	queue &

There should be only one queue server running, it is the coordinator for the cluster.


	cat create.txt | ./pmoo --cluster --queue http://127.0.0.1:8080 --init

Now, to add a computer to the cluster

	rlwrap ./pmoo --cluster --clusterQ --queue http://192.168.178.22:8080


Nodes are part of the cluster so long as the command is running.  Message processing happens in the background.

Cluster mode is currently under development and is extremely unstable.  Doing things like entering multiple commands quickly can lead to errors.



## The scripting language is golang

 I don't have the time to completely recreate MOOcode.  I can't find many useful objects written in MOOcode, so it isn't really worth the effort anyway.

The scripting language is not currently sandboxed, so it has access to the entire Golang library.  This means it is capable of formatting your hard drive, so allowing strangers access to this MOO is an exceptionally bad idea.

Due to issues with the go scripting library, I added a temporary scripting langauge called Throff, which is an old project that I always intended to dust off and finish.

## Clusters and the actor model

Pmoo is clustered.  The original MOOs were single computer, and usually single thread.  They used integer ids for objects, probably as an index into an array of objects.  Pmoo adds the ability to run on a cluster of CPUs, by passing messages through a message bus.  At the moment, objects are still kept in a central object store that is accessed directly by all pmoo nodes in the cluster.

Because messages can now run on different CPUs, any message can be evaluated on any pmoo node.  This is fine when all the nodes are identical, but I want to use pmoo to access cameras or other hardware.  One of my goals is to access external hardware like webcams, and also to allow for special network configurations, e.g. where one node has special network access and the rest are just compute nodes.  To achieve this, some objects are marked with an "affinity" property, and their code will only run on a node marked with the same affinity.

The actor model of computation works in this situation.  Actors are roughly the same as MOO objects, they both communicate by sending each other messages.  The main issue here is that pmoo allows user scripting, so the interpreter requires special support to allow a subroutine to jump to the correct affinity node, or all programs will need to be written in Continuation Passing Style (or async handlers).  This means that each subroutine must end by sending a message, and then processing would continue when that message is handled.

# The differences

With pmoo now adding a clustering mode, there seems to be little point to keeping a list of differences, because everything is different in cluster mode.  So in general, I'm still following the old MOOs as a guide, but the actual similarities are mostly limited to command names and basic concepts like "having objects" 

## Objects don't have index numbers at all

Pmoo uses GUIDs for object identifiers.  Pmoo needs to be able to allocate objects without contacting a central service.  This allows some nice features like offline mode, and being able to move objects from one MOO to another. 

The drawback is that this makes it horrible to try and type an object name on the command line.

## You can't have a verb and a property called the same thing (in the same object)

Properties and verbs are now stored in the same data structure with a flag to tell them apart.  This was to make data storage easier, and simplify the code that has to deal with them.  So now you can't have a verb called "name" and a property called "name" at the same time.

## No more built in commands

The special commands are now just normal verbs, so @dig, @create etc are just verbs on the core object, which is ultimately every object's parent.

So the commands now look like:

* clone $thing as "A name"
* move #2 to #3
* dig north to mountains

To set properties and verbs

* property #5.name is "A name"
* verb #5.introduce is "Println(`Hello, my name is `, GetProperty(dobj, `name`))"
* findverb dig on me 

# The rest

As far as possible, everything else works the same, or at least reasonably similar.  The parser, the default names for commands, etc are as similar as I can make them.  So you can log in, look at things, move around, create rooms and script objects.  You can also script objects to do work _outside_ the MOO, which should be interesting.  System calls are possible, so you can now create pmoo objects to represent parts of the system, and then control your computer via pmoo.
