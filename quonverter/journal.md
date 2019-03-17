## Sun 3 Mar, 2019

I just spent a frustrating 4 hour debugging session tracking down the fact that I didn't really understand how '() works in Scheme.  It is slightly frightening to realise that I have been programming Scheme on and off for 20 years without actually knowing how it works under the hood.

But I suppose that always has to be true.  Even if I understand the programming language completely, I don't really understand how the CPU works, or the physics that drive it, or etc...  I just do the best I can and hope it works most of the time.

In this case, I didn't understand that '() was actually a null pointer, as in C, because that is what goes in the cdr field to indicate that the list has finished.  I also didn't realise that the null pointer has a type of "list" in Scheme.  Having to write that for C made it clear.  I also could not have figured it out without the advanced debugging tools that we have today.  The people who designed this without any support were significantly better programmers than me.

In general I have been trying to copy the functionality of Scheme without actually writing a Scheme interpreter.  The reason being that I really want to be able to call native functions without ANY kind of FFI at all.  My previous project, Throff, floundered when I realised that no matter how good I made it, I would have to spend vast amounts of time writing and debugging boilerplate declarations to connect native functions to the interpreter.  Even connecting a simple graphics library requires connecting 20 or more functions, and larger, more complicated libraries could take 100s.

So I have a strict requirement that I can call native functions directly from my code, and that native functions can call my code directly.  Absolutely no barriers.  That means I have to use native types, native calling conventions, and no lambdas, closures, coroutines, continuations or any of the other stuff that would actually make my job quick and easy.  I'm really beginning to appreciate the simple and effective design of Scheme, but it really doesn't work well without lambdas, and I don't have an easy or quick way to implement those just now.

Most of my time so far has been implementing the most basic of Scheme functions.  Car, cdr, list?, empty? etc.  Today I have just finished adding basic assoc lists, because I really need some kind of key-value data structure, and most languages (that I care about right now) don't provide one out of the box.  Assoc lists are nice, and even better, they stress my implementations of srfi1 functions, catching a lot of bugs.

So I have now reached the point where I am ready to build my AST, and from there outputting code is quite quick and easy.

### Notes on the motivation for this project, and the downfall of Perl

Perl is diminishing, causing many people to rejoice.  This is an odd reason for merriment, because something existing shouldn't bother anyone, something vanishing shouldn't please anyone, and yet here we are.

But why is it fading?  The people who worked on the Perl6 project seemed to believe the most common criticism of Perl - that the syntax was horrible, and the features were confusing.  That might be true, but it didn't bother fans for 20 years, and I don't think that people suddenly changed their minds on the issue.

My suspicion is that Perl is less popular, because it hasn't adapted to modern computing, and so people literally cannot use it.  I think that if Perl worked better on windows, and ran in the browser and on Android etc, that it would be much more popular today.  But there are projects to run python and scheme and many more in the browser, and they are not popular, so clearly there are other factors here too.

Regardless, I have found it hard to actually install and use Perl in recent years.  Perl is currenlty broken on my MacOS development machine, for reasons I have not yet bothered to investigate.  None the less, it is frustrating to be cut off from all my useful scripts and tools, and I find myself wishing that Perl was easier to fix.  And I think this is a large problem.  Perl is a large, complicated, sprawling install with many complicated rules to accomodate many different
environments, some of which do not exist anymore.  But their ghost lingers on in the code.

Patching Perl is nearly impossible for me.  It would take weeks or months for me to figure out the most basic of changes, and then I would have to convince the maintainer team that my new idea was worthwhile, and so on.  The interpreter base that made Perl such a success in earlier years is now a massive drag.  It can't be ported into the browser, or into Java for Android, or other environments where I actually want it.  

There are projects like Perlito to help run your Perl code in new environments, but they don't move Perl itself, so your programs are heavily restricted in functionality and basically have to be written anew.  I certainly hope that perl-the-language can separate itself from perl-the-interpreter, but I don't care enough to actually join the project.

This is the motivation for my current project.  I want a programming language that can change itself to move from platform to platform as I need it, picking its way across the the programming language swamp like a flamingo or whichever bird with long legs lives in swamps and walks around lots.  Help me out here, I'm not an ornathologist.

I really have no idea if this project will result in anything useful to myself or other people, but I am annoyed enough at the current state of affairs that I am putting the work in to try and make something better.  Here's hoping for the best.

## Sun 17th March, 2019

Sunday seems to be a good day for reflection.  Funny how that works.

In the last two weeks I manage to get the project self hosting.  It's a major milestone, and I thought I would be much happier about achieving it.  But instead I ended up frustrated when I discovered that I still couldn't write full programs.  It was self hosting, but that didn't mean it could compile anything else except itself.  It needed library loading abilities, and it took a surprisingly long time to add them.  I think some of the decisions I made while implementing library loading will cause problems in the future.  Still, it's better to have it than not have it, since now I can actually compile a complete program.

The compiled programs work well.  The self-compiled compiler runs so fast that it finishes before I can lift my finger off the key, and the little demo programs I am writing finish equally quickly.  I don't feel the need to do speed tests, because the code runs at native speed, and the lisp code runs much slower, so if you care about speed you write using native functions and avoid the lisp part as much as possible.

I didn't realise that I would miss map() and fold() as much as I do.  Because I don't have them, I have to write a new recursive function for every place where I would normally use map().  This turns out to be a lot of places, and really shows up that I have too much boilerplate in my function definitions.  On the up side, it is easy for me to take lisp and scheme functions and quickly adapt them to work here.  I should be able to reproduce a large part of srfi/1 in a short amount of time.

And naturally, none of this would be a problem if I had closures, but that is not possible in general, and solutions like lambda lifting make the output code look awful, so I'm trapped for the moment.  I'm still thinking about the best way to get them in, but I have no ideas for now.  I want to add "tagging" to variables, so I might be able to hide a context in there.

PS And of course I declared victory too soon, library loading is still not quite working.  It's a curiously difficult problem, mainly because I didn't design it from the start, so now I have to work around the current design.
