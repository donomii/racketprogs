
[module parse racket
  [provide parse-go]
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

[define [close-brace b]
  [case b
    [["("] ")"]
    [["{"] "}"]
    [["["] "]"]
    ]
  ]
     
[define quote-chars '["\"" "'" "`"]]
[define brace-chars '["(" "{" "["]]
[define close-brace-chars '[")" "}" "]"]]
[define delimiter-chars [string-split ",({[:=]}) \t\n\"" ""]]
[define [is-quote x] [member x quote-chars]]
[define [is-brace x] [member x brace-chars]]
[define [is-delim x] [and [not [list? x]] [or [is-whitespace x][member x brace-chars][member x delimiter-chars]]]]
[define [is-not-delim x] [and [not [list? x]][not [is-delim x]]]]
[define [is-close-brace x] [member x close-brace-chars]]
[define [is-whitespace x]  (regexp-match #px"^\\s+$" x) ]
[define [pdp-strings pred? a-list out-list mode mode-char]
  ;[printf "~n~n***~s" a-list]
  [if [or [not a-list] [empty? a-list]]
      out-list
      [cond
        [[is-quote [car a-list]] ;quote char, start or finish
         ; [printf "~n*Quote~n"]
         [if [equal? mode 'quote]
             [pdp-strings pred? [cdr a-list] [cons [string-append  [car out-list][car a-list]] [cdr out-list]]#f #f]
             [pdp-strings pred? [cdr a-list]  [cons [car a-list] out-list] 'quote [car a-list]]]]
        [[equal? mode 'quote]  ;Gather quoted text
         ; [printf "~n*Gather quote~n"]
         [pdp-strings pred? [cdr a-list] [cons [string-append [car out-list][car a-list] ] [cdr out-list]]mode mode-char]]
        ;[[and [> [length out-list] 0][pred? [car a-list]] [pred? [car out-list]]]  ;Merge same token type
        ; [pdp-strings pred? [cdr a-list] [cons [string-append  [car out-list][car a-list]] [cdr out-list]]mode mode-char]]
        ;do nothing
        [else
         ;[printf "~n*Copy~n"]
         [pdp-strings pred? [cdr a-list]  [cons [car a-list] out-list] mode mode-char]]
        ]]]

[define [pdp-delims pred? a-list out-list mode mode-char]
  ;[printf "~n~n***~s" a-list]
  [if [or [not a-list] [empty? a-list]]
      out-list
      [cond
        
        [[and [>
               [length out-list] 0]
              [pred? [car a-list]]
              [pred? [car out-list]]]  ;Merge same token type
         [begin
          [printf "Merging ~s because it is not a delim~n" [car a-list]]
          [pdp-delims pred? [cdr a-list] [cons [string-append  [car out-list][car a-list]] [cdr out-list]]mode mode-char]]]
        [[list? [car a-list]]
         [pdp-delims pred? [cdr a-list]
                     [cons [pdp-delims pred? [car a-list] '[] mode mode-char] out-list]
                     mode mode-char]
         ]
        ;do nothing
        [else
         ;[printf "~n*Copy~n"]
         [pdp-delims pred? [cdr a-list]  [cons [car a-list] out-list] mode mode-char]]
        ]]]



;[set! quote-merged [flatten [map [lambda [x] [if [is-whitespace x] '[ ")" "("] x]] quote-merged]]]




(define  [sexprTree l]
  (if (empty? l)
      '[]
      (let [(b [car l])]
        (if (is-brace b)
            (cons (sexprTree (cdr l)) (sexprTree (skipList (cdr l))))
            (begin
              (if (is-close-brace b)
                  '[]
                  (cons b (sexprTree (cdr l)))))))))

(define (skipList l)
  (if (empty? l)
      '[]
      (let ((b (car l)))
        (if (is-brace b)
            (skipList (skipList (cdr l)))
            (if (is-close-brace b)
                (cdr l)
                (skipList (cdr l)))))))


(define  [delimTree l]
  (if (empty? l)
      '[]
      (let [(token [car l])]
        (if (is-whitespace token)
            (cons (delimTree (cdr l)) (delimTree (delimSkip (cdr l))))
            (if (is-whitespace token)
                '[]
                (cons token (delimTree (cdr l))))))))

(define (delimSkip l)
  (if (empty? l)
      '[]
      (let ((b (car l)))
        (if (is-whitespace b)
            (delimSkip (delimSkip (cdr l)))
            (if (is-whitespace b)
                (cdr l)
                (delimSkip (cdr l)))))))


  

[define [copy-and-brace a-list]
  [printf "copy-and-brace ~s~n" a-list]
  [cond
    [[empty? a-list] '[]]
    [[equal? "(" [car a-list]] [cons [collect-to-brace [cdr a-list] '[]] [copy-and-brace [discard-to-brace [cdr a-list] '[]]]]]
    [else [cons [car a-list] [copy-and-brace [cdr a-list]]]]]]
    
  
[define [collect-to-brace a-list accum]
  [printf "Collect-to-brace ~s ~s~n" a-list accum]
  [cond
    [[empty? a-list] '[]]
    [[equal? "(" [car a-list]] [cons [collect-to-brace [cdr a-list] '[]] [collect-to-brace [discard-to-brace [cdr a-list] '[]] '[]]]]
    [[equal? ")" [car a-list]]  [reverse accum]]
    [else [collect-to-brace [cdr a-list] [cons [car a-list] accum]]]
    ]]

[define [discard-to-brace a-list accum]
  
  [printf "discard-to-brace ~s ~s~n" a-list accum]
  ; [exit 1]
  [cond
    [[empty? a-list] '[]]
    [[equal? "(" [car a-list]] [cons [collect-to-brace [cdr a-list] '[]]  [collect-to-brace [discard-to-brace [cdr a-list] '[]] '[]]]]
    [[equal? ")" [car a-list]] [cdr a-list]]
    [else [discard-to-brace [cdr a-list] [cons [car a-list] accum]]]
    ]]


[define [token-rightpar? x] [equal? x ")"]]
[define [token-leftpar? x] [equal? x "("]]
[define input null]

[define [read-token]
  [if [empty? input] #f
      [let [[next [car input]]]
        [set! input [cdr input]]
        next]]]

(define (micro-read)
  (let ((next-token (read-token)))
    [displayln next-token]
    (cond
      ([not next-token] #f)
      (
             
       (token-leftpar? next-token)
       [cons (read-list '()) [micro-read]])
            
      (else
       [cons next-token [micro-read]]))))
  
(define (read-list list-so-far)
  [printf "List so far: ~s~n" list-so-far]
  (let ((token (read-token)))        
    (cond
      ([not token] #f)
      ((token-rightpar? token)
       (reverse list-so-far))
      ((token-leftpar? token)
       (read-list (cons (read-list '()) list-so-far)))
      (else
       (read-list (cons token list-so-far))))))


  

  [define [parse-go]
    [let[[ toks [map [lambda [x] x] [string-split [format "(~a)" [file->string "astdump.go"]] ""]]]]
[writeln toks]
[displayln "quoted *****"]
[set! toks [reverse-deep [pdp-strings is-whitespace toks '[] #f #f]]]

[writeln toks]
[displayln "quote-merged*****"]
[set! toks [reverse-deep [pdp-delims is-not-delim toks '[] #f #f]]]
[set! toks [tree-list-map [lambda [x]
                                    [printf "*~a~n" [car x]]
                                    [if [is-quote [car x]]
                                        [list [string-join  x ""]]
                                        x]]
                                  toks]]
    [writeln toks]
[displayln "braced*****"]
[set! toks [sexprTree toks ]]
[writeln toks]
[displayln "*****"]
[tree-list-map [lambda [x] [filter [lambda [x] [or [list? x][not [is-whitespace x]]]]x]]
               toks]
]
]



]







