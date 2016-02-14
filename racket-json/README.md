# racket-json
A PEG parser for JSON, written in Racket

## Abstract

Provides a JSON parser for racket

## Example 

	equal? '(1 2 3 4 5) [json "[1, 2, 3 , 4,5]"]
	
Written before Racket had a good JSON parser, this parser creates a native structure from a string containing JSON.

It is different from the built-in parser in a few areas, such as building CONS lists instead of hashes.
