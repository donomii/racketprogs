 # This is pmoo, a MOO written in Golang.

 It is loosely inspired by LambdaMOO, but doesn't share any code with it.  I have tried to follow the general design of LambdaMOO, and I am working while looking at LambdaMOO source code, playing on my own LambdaMOO instance and reading the LambdaMOO docs, but the result is significantly different in every way.  It is LambdaMOO with the benefit of 25 years of programming language progress making it better and worse in parts.  There is a list of major changes below.


 ## The scripting language is golang

 I don't have the time to completely recreate MOOcode.  I can't find many useful objects written in MOOcode, so it isn't really worth the effort anyway.

The scripting language is not currently sandboxed, so it has access to the entire Golang library.  This means it is capable of formatting your hard drive, so allowing strangers access to this MOO is an exceptionally bad idea.

I do plan to add a sandboxed scripting language, but it's roughly the last thing on the list.


 ## The base object numbers are wrong

 Mainly so I can store them in systems that use UINT, like databases.  So now:

 0 is the error object

1 is the core object

and so on from there.

However the command behaviour is still the same, as much as possible.  So $room and $thing now get translated to #1.room and #1.thing

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

As far as possible, everything else works the same, or at least reasonably similar.  The parser, the default names for commands, etc are as similar as I can make them.  So you can log in, look at things, move around, create rooms and script objects.  You can also script objects to do work _outside_ the MOO, which should be interesting.