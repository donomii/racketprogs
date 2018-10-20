# esmf

The extremely simple message format

# Install

	go get -u github.com/donomii/esmf
	
# Try it

	go build github.com/donomii/esmf/example
	./example


# The extremely simple message format

Recently I have been working on a project that involves exchanging a lot of messages between many different programming languages.  I chose JSON as the message format.  I'm still happy that I chose JSON, but a lot of the languages I want to connect with, don't have JSON libraries.  And I don't want to spend my life writing JSON libraries for little languages.  I need a simpler way to get messages from A to B.  And by simpler, I mean simple to implement, and thus reasonably simple in format too.  Here's my idea.

##Example

Json:
    { "Greeting" : "Hello" , "Message" : "World" }

ESMF:
    ^^ 01 {{ 47 72 65 65 74 69 6e 67 :: 48 65 6c 6c 6f ,, 4d 65 73 73 61 67 65 :: 57 6f 72 6c 64 }} $$

Taking it apart:

^^ starts a message, $$ finishes it

The second value is the message protocol version, in this case, version 01.


A "dictionary", or "hash table" is created with {{ }}.  The full format is below:

    {{ key1 :: value1 ,, key2 :: value2 }}

The keys and values are "ordinary" strings, where each byte is converted to its ASCII hex value.  So 47 is G, 72 is r, and so on.

An array is created by [[ ]].  e.g.

    ^^ 01 [[ 48 65 6c 6c 6f ,, 57 6f 72 6c 64 ]] $$

Note that there is no format for numbers, because all numbers are transmitted as strings.
	
# Why?!?

Why would I make a new format, especially one this bad?

Because you can parse it with regular expressions.

More seriously, because it was the best thing I can think of that fit my requirements.  Let's take a look at those, to see if esmf is for you.

## Requirements

### Extremely simple to implement

I needed to implement this for a lot of languages very quickly, without becoming an expert in all of them to implement things like escaping values and getting types correct.  Just translating native structures into esmf is hard enough, without going the other way as well.
	
### Must be able to pass through ASCII-only programs and protocols.

Messages must be able to be sent through old channels that hate non-ascii characters, such as email and IRC.  While I could do this with Base64 encoding, there are a few issues with Base64.  Base64 is not super easy to implement, and it doesn't have a message structure, so you can't easily see where each message starts and ends.
	
Putting spaces between the hex values should prevent email programs from messing up the lines by attempting to "break" the lines using normal English formatting rules.
	
### Must be able to represent common data structures, like hashes and arrays.

ESMF is a lowest common denominator format.  It attempts to only use features common to all languages, and for those languages to easily access the messages.  So, the byte-encoding approach makes it easier for low-level languages to read the messages, without making it impossible for high-level languages to access them.  Similarly, the "strings only" rule makes it easier for high level languages, as they often lack the ability to manipulate basic "unboxed" data types.

### Must be, at least a little bit, human readable.

It isn't easy to read ASCII hex values as text, but it is, just barely, possible.  It is nice that the control characters are in a different "space", so that the structure of the message is clearly visible.

# Additional specifications

There are just a few extra conditions on the messages:

### Only one space!

Each hex value must be separated by one, and only one space.  This allows low-level languages to easily locate every hex value by counting up by three, and high level languages can do a simple split() on a single space value, then assume that everything returned is a valid value.

### It must be a space!

It is a space, ASCII value 32.  Not a tab, newline, carriage return or unicode equivalent.  Spaces only.

### Unknown control codes must be ignored, for forwards compatibility

Any control character that is not a ^^ $$ {{ }} [[ ]] ,, or :: must be ignored completely.  i.e. Skip over it

### Control codes must not use > < - 

These are common characters that might be inserted by annoying transfer programs.  To make it easy to undo corruption, don't add control codes using these characters.

	
