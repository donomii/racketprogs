[module support racket
;[provide command-output get-word zap-word count-chars slurp-file]
[provide [all-defined-out]]
[define command-output [lambda [a-command] [letrec [[pipes [process a-command]]
                                                    [stdout [car pipes]]]
                                             [[fifth pipes] 'wait]
                                             [read-string 99999 stdout]]]]
  [define debug [lambda args args]]

  [define [eval-string str] (eval (call-with-input-string str read))]

  ;Given a gui text widget, extract the word currently under the cursor, or the highlighted text
[define get-word [lambda [a-text]  [letrec [
                                            [highlight-start [send a-text get-start-position]]
                                            [hightlight-end [send a-text get-end-position]]]
                                     [if [not [eq? highlight-start hightlight-end]]
                                         [send a-text get-text highlight-start hightlight-end]
                                         [letrec [[startbox [box highlight-start]] 
                                                  [endbox [box hightlight-end]]  
                                                  [start (send a-text find-wordbreak startbox #f 'selection)]
                                                  [end (send a-text find-wordbreak #f endbox  'selection)]]
                                           [send a-text get-text [unbox startbox] [unbox endbox]]]]]]]


;Delete currently selected word/hightlighted text
[define zap-word [lambda [a-text]  [letrec [[startbox [box [send a-text get-start-position]]] 
                                            [endbox [box [send a-text get-start-position]]] 
                                            [start (send a-text find-wordbreak startbox #f 'selection)]
                                            [end (send a-text find-wordbreak #f endbox  'selection)]]
                                     [send a-text kill 0 [unbox startbox] [unbox endbox]]]]]

  [define [count-chars str char pos count]
  [if [equal? [string-length str] pos]
      count
      [count-chars str char [add1 pos] [if [char=? char [string-ref str pos]]
                                           [add1 count]
                                           count]]]]

  [define [slurp-file a-path]
  (port->string (open-input-file a-path) #:close? #t)
  ]

[define [extract-line some-text line-number]
  [list-ref [string-split some-text "\n"]


            line-number ]
  ]

[define [break-line-field a-string]
  ;[display [format "~nBreaking: ~a~n" a-string]]
  ;[display [substring  a-string 0 [sub1 [string-length a-string]]]]
  [substring  a-string 0 [- [string-length a-string] 2]]
  ]

[define [false-to-zero x]
  [if [not x]
      1
      x]]

  ;Convert line number to editor window position
[define [line->position text target-line linecount current-pos]
  [if [> linecount target-line]
      current-pos
      [if [equal? text ""]
          0
          [let [[letter [string-ref text current-pos]]]
            [if [equal? #\newline letter]
                [line->position text target-line [add1 linecount] [add1 current-pos]]
                [line->position text target-line linecount [add1 current-pos]]] ]]]]
  
  



[define [process-lines f a-path]
                    
  (for ([l (in-lines (open-input-file a-path))])
    (f l)
    [displayln "---"]
    (newline))]

[define ctg [list->vector [file->lines "tags"]]]

;Binary search on a sorted vector

[define [find-start a-vec cmp a-pos]
  [debug "find-start: ~a ~a ~a\n" a-pos [vector-ref a-vec [sub1 a-pos ]] [vector-ref a-vec a-pos]]
  [if [and [> a-pos 0] [cmp [vector-ref a-vec a-pos]  ]]
      [find-start a-vec cmp [sub1 a-pos]]
      [add1 a-pos]
      ]
  ]

[define [find-end a-vec cmp a-pos] ;FIXME missing the last one, crashes if cursor at end
  [debug "find-end: ~a ~a, ~a\n"
         a-pos
         [vector-ref a-vec  a-pos]
         [vector-ref a-vec [min [sub1 [vector-length a-vec]] [add1 a-pos]]]]
  [if [and 
       [< a-pos [- [vector-length a-vec] 2]] 
       [cmp [vector-ref a-vec a-pos]]]
      [begin
        [debug "Keep\n"]
        [find-end a-vec cmp [add1 a-pos]]]
      [begin
        [debug "Don't keep\n" ]
        [sub1 a-pos]]
      ]
  ]

[define [binary-search a-vec search-term]

  (define loop [lambda (low high mid last-mid)
  
                 (let  [[mid-val  (vector-ref a-vec mid)]]
                   [debug "In bin search: ~a ~a ~a ~a\n" low high mid mid-val]
                   [debug "Comparing ~a to ~a\n" search-term mid-val]
                   (cond 
                     [(equal? mid last-mid) mid]
                     [(string<? mid-val search-term)  (loop mid high  [ceiling (/ (+ mid high) 2)] mid)]
                     [(string>? mid-val search-term)  (loop low mid   [ceiling (/ (+ low mid)  2)] mid)]
                     [else mid]))])
  [loop 0 (vector-length a-vec) [floor (/ (vector-length a-vec) 2) ] -1 ]
  ]
[define [make-cmp search-term ]
  [lambda [a-str-line]
    [let [
          [a [car [string-split  a-str-line #px"\t+|\\s+" ]]]]
      [debug "is cmp  ~a a prefix of  ~a?\n" search-term a]
      [string-prefix? a search-term ]]]]

[define [binary-search-all-matches a-vec search-term]
  [letrec [
           [pos [binary-search a-vec search-term]]
           [start [find-start a-vec [make-cmp search-term] pos]]
           [end [find-end a-vec [make-cmp search-term] pos]]]
    [if [> start end]
        [vector] ; Empty vector
        (vector-copy a-vec start end)]
    
    ]
  ]



;[debug "Bin search: ~a\n" [binary-search-all-matches ctg "API"]]



[define [open-visual-code filename linenumber]
  [system* "/Applications/Visual Studio Code.app/Contents/MacOS/Electron" [format "~a:~a" filename [add1 linenumber]]  "--goto"]]

  [define [binsearch-ctags-file a-term]
  [debug "Binsearching for ~a\n" a-term]
  [if [eq? a-term ""] '()
      [map [lambda [x] [string-split  x #px"\t+|\\s+" ]] [vector->list [binary-search-all-matches ctg a-term] ]]]]

[define [take-at-most a-list a-number]
  [if [<= a-number 0]
      '()
      [if [null? a-list]
          '()
          [cons (car a-list) [take-at-most (cdr a-list) (sub1 a-number)]]
          ]]]


  ;Delete?
  [define tagsearch [lambda [a-string]
                    [if [< [string-length a-string] 4] ""
                        [shell-out [format "grep \"~a\" tags | head -100" a-string]
                                   [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
                                     [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]
                                     ]]
                        ]]]
[define [grep-ctags-file a-term]
  [if [eq? a-term ""] '()
      [map [lambda [x] [string-split  x #px"\t+|\\s+" ]] [string-split
                                                          [let [[output [tagsearch a-term]]]
                                                            [if [eq? output eof ]
                                                                ""
                                                                output]]
                                                          "\n"] ]]]

  ;Run an external program
[define [shell-out a-string a-handler] [apply a-handler [process a-string]]]

;Run an external program, capture all output
[define [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
  [close-input-port stderr-pipe]
  [close-output-port stdin-pipe]
  ;[control-proc 'wait]
  [read-string 9999999 stdout-pipe]
  ;[close-input-port stdout-pipe]
  ]


  ]