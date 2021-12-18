(module json-parser racket 
  (provide json )
  (require (planet kazzmir/peg:2:0/peg))
  (define parser [lambda []
                   (peg
                    (start s)
                    (grammar
                     [s    [[thing ] $ ]]
                     [thing [[[* whitespace] [bind t [or atom list hash]]] t]]
                     [atom  [[[* whitespace] [or string number null false true ]] $]]
                     
                     [null [[[* whitespace] "null"] #\null]]
                     [false [[[* whitespace] "false"] #f]]
                     [true [[[* whitespace] "true"] #t]]
                     [whitespace [[[or " " "\t" "\n"]] $]]
                     [list [[ "[" [bind l [* [? comma] thing  ]]    [* whitespace] "]" ] l]]
                     [hash [[ "{" [bind l [* [? comma] hashpair ]] [* whitespace] "}" ] l]]
                     [hashpair [[[bind a atom] [* whitespace] ":" [bind b thing]] [cons a b]]]
                     [comma [[[* whitespace] ","] ","]]
                     [number [[ [bind a [? "-"]] [bind b digits] [bind c [? "." digits]] [bind d [? exponent]]]  
                              [read [open-input-string
                                     [string-append* 
                                      [if [equal? "-" a] a ""] 
                                      b 
                                      [if [equal? c '[]] "" [format ".~a" c]]
                                      [if [null? d] "" d] 
                                      '[]]]]]]
                     [exponent [[ [or "e" "E"] [bind a[or "+" "-"]] [bind b digits]] [format "e~a~a" a b]]]
                     [digits [[[bind n [+ digit]]] [string-append* n]]]
                     [digit [[[or "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"]] $]]
                     
                     (string ([quote [bind l letters-with-escape] quote   ] [list->string l]))
                     [quote [["\""] $]]
                     [letters-with-escape [[[* [or newline return backspace tab formfeed solidus unicode escape  letter ]]] $]]
                     [newline [["\\n"] #\newline]]
                     [return [["\\r"] #\return]]
                     [backspace [["\\b"] #\backspace]]
                     [tab [["\\t"] #\tab]]
                     [formfeed [["\\f"] [car [string->list "\f"]]]]
                     [solidus [["\\/"] #\/]]
                     [unicode [["\\u" [bind a _] [bind b _] [bind c _] [bind d _]] [read [open-input-string [format "#\\u~a~a~a~a" a b c d]]]]]
                     [escape [["\\"  _] $]]
                     [letter [[  [not "\""]  _] $]]
                     ))])

  
  [define test [lambda [name expected-result result]            
     [display [format "~a\t: ~a~n" name
                                  [if [equal? result expected-result] "passed." "failed!"]]]]]
  [define [json a-string] [parse [parser] a-string]]
  
  [define [run-json-tests]
    [parse [parser] "[0,{\"1\":{\"2\":{\"3\":{\"4\":[5,{\"6\":7}]}}}}]"]
    [parse [parser] "[[null, 123.45, \"a\\tb c\"]], true"]
    [test "empty list" '() [json "[]"]]
    [test "list" '(1 2 3 4 5) [json "[1, 2, 3 , 4,5]"]]
    [test "empty hash" '[] [json "{}"]]
    [test "hash" '[[1 . 2] ["a" . "b"]] [json "{1 : 2, \"a\":\"b\" }"]]; ooh, problem here
    [test 'true #t [json "true"]]
    [test 'false #f [json "false"]]
    [test 'null #\null [json "null"]]
    [test 'integer 3 [json "3"]]
    [test 'float 3.14159 [json "3.14159"]]
    [test "float with exponent" 3.14159e+23 [json "3.14159e+23"]]
    [test "negative integer" -3 [json "-3"]]
    [test "negative float" -3.14159 [json "-3.14159"]]
    [test "negative float with exponent" -3.14159e+23 [json "-3.14159e+23"]]
    [test "negative float with negative exponent" -3.14159e-23 [json "-3.14159e-23"]]
    [parse [parser] "6.28e+23"]
    [parse [parser]"{\"first\": 123, \"second\": [4, 5, 6], \"third\": 789}"]]
  )