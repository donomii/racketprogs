#lang racket
[require srfi/1]
(define (reverse-deep l)
  (map (lambda (x) (if (list? x) (reverse-deep x) x)) (reverse l)))

[define [tree-map func tree]
  [if [list? tree]
      [map [lambda [x] [tree-map func x]] tree]
      [func tree]]
  ]

[define [tree-list-map func tree]
  [if [list? tree]
  [let [[res [func tree]]]
  [if [list? res]
      [map [lambda [x] [tree-list-map func x]] res]
       res]
  ]
  tree]]
     
[define quote-chars '["\"" "'" "`"]]
[define brace-chars '["(" "{" "["]]
[define [is-quote x] [member x quote-chars]]
[define [is-whitespace x]  (regexp-match #px"^\\s$"[ car x]) ]
[define [pdp-strings pred? a-list out-list mode mode-char]
  ;[printf "~n~n***~s" a-list]
  [if [or [not a-list] [empty? a-list]]
      out-list
      [cond
        [[is-quote [caar a-list]] ;quote char, start or finish
        ; [printf "~n*Quote~n"]
         [if [equal? mode 'quote]
             [pdp-strings pred? [cdr a-list] [cons [append [car a-list] [car out-list]] [cdr out-list]]#f #f]
         [pdp-strings pred? [cdr a-list]  [cons [car a-list] out-list] 'quote [caar a-list]]]]
        [[equal? mode 'quote]  ;Gather quoted text
        ; [printf "~n*Gather quote~n"]
         [pdp-strings pred? [cdr a-list] [cons [append [car a-list] [car out-list]] [cdr out-list]]mode mode-char]]
        [[and [> [length out-list] 0][pred? [car a-list]] [pred? [car out-list]]]  ;Merge same token type
         [pdp-strings pred? [cdr a-list] [cons [append [car a-list] [car out-list]] [cdr out-list]]mode mode-char]]
      ;do nothing
        [else
;[printf "~n*Copy~n"]
         [pdp-strings pred? [cdr a-list]  [cons [car a-list] out-list] mode mode-char]]
        ]]]

[define [pdp-braces pred? a-list out-list mode mode-char]
  ;[printf "~n~n***~s" a-list]
  [if [or [not a-list] [empty? a-list]]
      out-list
      [cond
        [[equal? "(" [caar a-list]]
         ;[printf "~n*Open brace~n"]
         [letrec [[end [find-tail [lambda [x] [equal? [car x] ")"]] a-list]]
                  [braced  [reverse [cdr [take-while [lambda [x] [not [equal? [car x] ")"]]] a-list]]]]]
           [pdp-braces pred? end  [cons   braced out-list] mode mode-char]]]
       
      ;do nothing
        [else
;[printf "~n*Copy~n"]
         [pdp-braces pred? [cdr a-list]  [cons [car a-list] out-list] mode mode-char]]
        ]]]

[define toks [map [lambda [x] [list x]] [string-split [file->string "astdump.go"] ""]]]
[displayln toks]
[displayln "quoted *****"]
[define quoted [reverse-deep [pdp-strings is-whitespace toks '[] #f #f]]]
[displayln quoted]
[displayln "quote-merged*****"]
[define quote-merged [tree-list-map [lambda [x]
[printf "*~a~n" [car x]]
                                      [if [is-quote [car x]]
                                [list [string-join  x ""]]
                                x]]
               quoted]]
[writeln quote-merged]
[displayln "braced*****"]
[define braced [reverse-deep [pdp-braces is-whitespace quote-merged '[] #f #f]]]
[displayln braced]
[displayln "*****"]
