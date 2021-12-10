# Commentary

Commentary is an experimental source code browser that is designed to help me work with modern software projects.  Modern projects often contain 100,000+ lines of source code, and the existing tools are just not capable of coping with the scale.

Commentary assists by providing a two-pane view.  On the left is the code, on the right is a list of suggestions from the program.

## Features

* Forward/back navigation like a web browser
* Integration with ctags, csearch and wiktionary
* (Very) basic editing capabilities

## Installing

To use commentary, you can use a binary release, or install the following:

* Racket Scheme
* gotags/ctags
* csearch

The binaries for gotags and csearch must be placed in the same directory as Commentary.

Start commentary with 

    racket editor.rkt

## Use

Commentary works by automatically searching for the word under the cursor, or the highlighted text.  The results are shown on the right.

Click on the [pointy arrow](graphics/jump-32.png) to jump to a new location.

The back/forwards buttons at the bottom work like a web browser, allowing you to conveniently return to code you have already seen.


