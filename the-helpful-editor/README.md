# Commentary

Commentary is an experimental source code browser that is designed to help me work with modern software projects.  Modern projects often contain 100,000+ lines of source code, and the existing tools are just not capable of coping with that scale.

Commentary assists by providing a two-pane view.  On the left is the code, on the right is a list of suggestions from the Commentary.

## Features

* Forward/back navigation like a web browser
* Integration with ctags, csearch and wiktionary
* (Very) basic editing capabilities

## Installing

To use commentary, you can use a binary release, or install the following:

* Racket Scheme (https://download.racket-lang.org/)
* gotags/ctags (https://github.com/jstemmer/gotags)
* csearch (https://github.com/google/codesearch)

The binaries for gotags and csearch must be placed in the same directory as Commentary.

Start commentary with 

    racket editor.rkt

## Use

Commentary works by automatically searching for the word under the cursor, or the highlighted text.  The results are shown on the right.

Click on ![the pointy arrow](graphics/jump-32.png) to jump to a new location.

The back/forwards buttons at the bottom work like a web browser, allowing you to conveniently return to code you have already seen.

## I want more control!

You can change the directories that Commentary indexes in the settings panel.  Add one directory per line, then press refresh to re-index them all.

Commentary works with external programs, so you can run them directly if you want more control over what gets displayed.

### Ctags

ctags (gotags) creates a file called "tags" in the Commentary directory.  You can use any program you like to generate this file, so long as it writes out a ctags format file.

### Csearch

Google Code Search is another text indexing program.  Run cindex to add directories to the index.



