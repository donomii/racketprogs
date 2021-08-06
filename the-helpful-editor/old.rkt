#lang racket

(provide statements->mexpr strip-brackets get-multi-defs)
(require mzlib/defmacro srfi/13 srfi/1)

;m-expressions?


[define ensure-list [lambda [e] [if [list? e] e [list e]]]]
[define indent-level 0]
[define [indent] [set! indent-level [+ 4 indent-level]]]
[define [dedent] [set! indent-level [- indent-level 4]]]
[defmacro indent-dedent args `[begin [indent] [let [[temp ,[car args]]] [dedent] temp]]]
[define [spaces] [make-string indent-level #\ ]]
[define statements->mexpr [lambda [statements]
                            [string-join [map [lambda [s] [string-append [spaces] [sexpr->mexpr s ";"  "\n"]]] [ensure-list statements]]]]]
[define sexpr->mexpr [lambda [sexpr terminator linebreak]
                       [if [list? sexpr]
                           [if [> [length sexpr] 0]
                               
                               [cond
                                 
                                 [[eq? [car sexpr] 'set!]
                                  [format "~a~a = ~a;\n" [spaces][cadr sexpr][string-join [map [lambda [s] [sexpr->mexpr s "" ""]] [cddr sexpr]] ", "] ]]
                                 [[eq? [car sexpr] 'when]
                                  [format "when (~a) {~n~a~n}~n" [cadr sexpr][begin [indent-dedent [string-join [map statements->mexpr [cddr sexpr]] ", "] ]]]]
                                 [[eq? [car sexpr] 'if]
                                  [format "if (~a) {~n~a~n}~nelse {~n~a~n}~n" [sexpr->mexpr [cadr sexpr] "" ""]
                                          [sexpr->mexpr [caddr sexpr] "" ""]
                                          [sexpr->mexpr [cadddr sexpr] "" ""]]]
                                 [[eq? [car sexpr] 'begin]
                                  [statements->mexpr [cdr sexpr]]]
                                 [[or [eq? [car sexpr] 'let] [eq? [car sexpr] 'letrec]]
                                  
                                  [string-append 
                                   [string-join [map [lambda [x]
                                                       [format "~a~a := ~a;\n" [spaces][car x][string-join [map [lambda [s] [sexpr->mexpr s "" ""]] [cdr x]] ", "] ]
                                                       ][cadr sexpr]] ""]
                                   [indent-dedent
                                    [statements->mexpr [cddr sexpr]]
                                    ]
                                   
                                   ""]]
                                 [[eq? [car sexpr] 'send]
                                  [format "~a->~a(~a)~a~a" [sexpr->mexpr [cadr sexpr] "" ""] [sexpr->mexpr [caddr sexpr] "" ""] [string-join [map [lambda [s] [sexpr->mexpr s "" ""]] [cdddr sexpr]]  ", "] terminator linebreak]]
                                 [else
                                  [format "~a(~a)~a~a" [car sexpr][string-join [map [lambda [s] [sexpr->mexpr s "" ""]] [cdr sexpr]] ", "] terminator linebreak]]]
                               ""]
                           [format "~s" sexpr]]
                       
                       ]]

[define strip-brackets [lambda [a-list pad-length]
                         [string-join 
                          [map
                           [lambda [f]
                             [format "~a = ~a ~n"  [string-pad-right [format "~a" [car f]] pad-length] [sexpr->mexpr [cadr f] "" ""]]]
                           a-list]
                          ""]
                         ]]

;; Load scheme files?


[define get-defs [lambda [a-syntax file-source]
                   [if [list? [syntax-e a-syntax]]
                       [if [> [length [syntax-e a-syntax]] 1]
                           [letrec [[e a-syntax]
                                    [1st [syntax-e [car [syntax-e e]]]]
                                    ]
                             
                             [if [equal? 'define 1st] 
                                 [if [symbol? [syntax-e [cadr [syntax-e e]]]]
                                     ;[define name [lambda....
                                     [list [cons [symbol->string [syntax-e [cadr [syntax-e e]]]] [substring file-source [syntax-position e] [+ [syntax-position e] [syntax-span e]]]]]
                                     ;[define [name args ...
                                     [list [cons [symbol->string [syntax-e [car [syntax-e [cadr [syntax-e e]]]]]] [substring file-source [syntax-position e] [sub1 [+ [syntax-position e] [syntax-span e]]]]]]]
                                 
                                 [concatenate [map [lambda [e] [get-defs e file-source] ] [syntax-e a-syntax]]]
                                 ]]
                           '[]]
                       '[]]]]
[define [get-multi-defs input-files] [apply append [map [lambda [a-path] 
                                                          [write input-files]
                                                          [let  [[file-source [call-with-input-file a-path [lambda [in] [read-string 999999 in]] #:mode 'text]]]
                                                            ;[send t insert file-source]  ;;FIXME re-add?
                             
                                                            [get-defs   [call-with-input-file a-path [lambda [in] [read-syntax #f in]] #:mode 'text] file-source]
                                                            ]]
                                                        input-files] ]]

