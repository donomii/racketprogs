
(module spath racket 
  ;This module provides spath, the simple scheme data accessor.  Spath provides a single, unified interface to all data types
  ; (c) Jeremy Price
  
  (provide spath spath-fail   s s= sl s=lambda sf s=f) 
  (require (lib "class.ss"))
  [require mzlib/defmacro]
 
  [require srfi/1 srfi/13]
  
  
  ;=item [spath '[path list] data]
  ; spath walks through the nested data structure, choosing the correct accessor function for each data type encountered.
  
  
  [define spath [lambda [path-list a-struct] [hh path-list a-struct]]]
  [define spath-fail  [lambda [path-list a-struct a-thunk] [with-handlers [[[lambda args #t] [lambda args [a-thunk]]]] [hh path-list a-struct]]]]
  
  [define hh [lambda [path-list a-struct]
               [if [> [length path-list] 0]
                   [letrec [[a-key [car path-list]]
                            [a-value 
                             [if [vector? a-struct]
                                 [vector-ref a-struct [string->number a-key]]
                                 [if [dict? a-struct]
                                     
                                     [dict-ref a-struct a-key]
                                     [if [struct? a-struct]
                                         [if [string->number a-key]
                                             [vector-ref [struct->vector a-struct] [add1 a-key]]
                                             [let-values [[[type dont-give-a-fuck]  [struct-info a-struct]]]
                                               [eval-syntax  [datum->syntax [quote-syntax here] [list [string->symbol [format "~a-~a" [object-name type] a-key]] a-struct]] ]
                                               ;[call-with-values [lambda [] [struct-type-info type]] [lambda args [[cadddr args] a-struct a-key]]]
                                               ]]
                                         [list-ref a-struct a-key]]
                                     ]
                                 ]]]
                     [hh [cdr path-list] a-value]
                     ]
                   a-struct]]]
  
  [define spath-recurse-permissive [lambda [path-list a-struct]
                                     [if [> [length path-list] 0]
                                         [letrec [[a-key [car path-list]]
                                                  [a-value 
                                                   [if [vector? a-struct]
                                                       [vector-ref a-struct [string->number a-key]]
                                                       [if [dict? a-struct]
                                                           [with-handlers [[[lambda args #t] [lambda [e] [dict-ref a-struct [string->symbol a-key]]]]]
                                                           [with-handlers [[[lambda args #t] [lambda [e] [dict-ref a-struct [symbol->string a-key]]]]]
                                                             [dict-ref a-struct a-key]]]
                                                           
                                                           [if [struct? a-struct]
                                                               [if [string->number a-key]
                                                                   [vector-ref [struct->vector a-struct] [add1 [string->number a-key]]]
                                                                   [let-values [[[type dont-give-a-fuck]  [struct-info a-struct]]]
                                                                     [eval-syntax  [datum->syntax [quote-syntax here] [list [string->symbol [format "~a-~a" [object-name type] a-key]] a-struct]] ]
                                                                     ;[call-with-values [lambda [] [struct-type-info type]] [lambda args [[cadddr args] a-struct a-key]]]
                                                                     ]]
                                                               [if [bytes? a-struct]
                                                                   [bytes-ref a-struct [car path-list] ]
                                                               [list-ref a-struct [string->number a-key]]]]
                                                           ]]]]
                                           [spath-recurse-permissive [cdr path-list] a-value]
                                           ]
                                         a-struct]]]
  [define h [lambda [a-path a-struct]
              [if [list? a-path] [hh a-path a-struct]
                  [letrec [[string-path [if [symbol? a-path] [symbol->string a-path] a-path]]
                           [path-list  [regexp-split "/" string-path]]]
                    [spath-recurse-permissive  path-list a-struct]
                    ]
                  ]]]
  
  [define s [lambda [a-path a-struct] [h [symbol->string a-path] a-struct] ]]
  [define sl [lambda [a-path a-struct a-thunk] [with-handlers [[[lambda args #t] [lambda args [a-thunk]]]] [s a-path a-struct]]]]
  [define sf [lambda [a-path a-struct a-val] [with-handlers [[[lambda args #t] [lambda args a-val]]] [s a-path a-struct]]]]
  
  [define-macro [s= aaa bbb] `[s [quote ,aaa] ,bbb]]
  [define-macro [s=lambda aaa bbb ccc] `[sl [quote ,aaa] ,bbb ,ccc]]
  [define-macro [s=f aaa bbb ccc] `[sf [quote ,aaa] ,bbb ,ccc]]
  
(struct posn (x y [z #:auto])
    #:auto-value 0
    #:transparent)
  (define test (lambda () 
  [writeln [equal? "no" [spath '[2 "bananas"] '[ "b" "c" [[apples . "yes"] ["bananas" . "no"]] ]]]]
     
  
  [writeln [equal? 'b [h 'y/1 [posn 1 '[a b c]]]]]
  
  [writeln[equal? 'c [s= y/2 [posn 1 '[a b c]]]]]
                 [writeln [s= y/2 [posn 1 '[a b c]]]]
  ))
  )
    