#lang scheme
(require mred
         mzlib/class
         mzlib/math
         sgl
         sgl/gl-vectors
         framework
         mzlib/string)
(require net/uri-codec)
(require xml)
(permissive-xexprs #t) 
	;(require (planet dherman/json:3:0))
[define abstract-edit%
  (class editor-canvas%
    (super-new)
    
    )]
[define (reverse-text some-text) (list->string (reverse (string->list some-text)))]
[define action [lambda args
                 [apply [car args] [cdr args]]]]
[define where [lambda args
          [map [lambda [l] [let [[scope [car args]]
                [verb [cadr args]]
                [condition [caddr args]]]
            
                [if  [regexp-match [regexp condition] l]
                    [apply action [append [cons [cadddr args] [cons l [cddddr args]]]]]
                    l]
                ]] lines]]]
(define-syntax lines
    (syntax-id-rules (set!)
      [(set! lines e) (put-clock! e)]
      [(lines a ...) [map [lambda [l] [a  ... l ]] (get-lines)]]
      [lines (get-lines)]))
(define-syntax text
    (syntax-id-rules (set!)
      [(set! lines e) (put-clock! e)]
      [(text a ...) [a ... text]]
      [text (whole-text)]))
[define [replace  l pre with post] [regexp-replace [regexp pre] l post]]
[define-syntax-rule [replace-all pre with post] [map [lambda [l] [replace l pre 'with post]] lines]]
[define-syntax-rule [enclose pre post] [map [lambda [l] [string-append pre l post]] lines]]
[define-syntax-rule [denclose pre post] [map [lambda [l] [when [and [regexp-match [string-append "^" pre] l]
                                                                  [regexp-match [string-append post "$"] l]]
                                                             [regexp-replace [string-append "^" pre] [regexp-replace [string-append post "$"] l ""] ""]
                                                             ]]lines]]
                                                             
[define debug (lambda args (write args) args)]                                                             
(define-syntax-rule [join x with y] [string-join x y])
(define-syntax-rule [split x on y] [regexp-split [regexp y] x])
(define-syntax-rule [decode-xml var] [format "~a" (xml->xexpr (document-element
                 (read-xml (open-input-string
                            var))))])
(define-syntax-rule [encode-xml var] (xexpr->string 
                 (debug (read (open-input-string
                            var)))))
[define whole-text [lambda [] (send display-box get-text 0 'eof)]]
[define set-data [lambda [a-lines] (send display-box do-edit-operation 'select-all)
  (send display-box do-edit-operation 'clear)
  ;  [send mid-box clear]
  [send display-box insert a-lines 0]]]
[define set-lines [lambda [a-lines] [set-data [string-append a-lines]]]]
[define get-lines [lambda [] [regexp-split #px"\n" [whole-text]]]]
;[define lines [lambda [] [get-lines]]]
[define slurp [lambda [] [let [[l [read-line]]]
                           [if [eof-object? l]
                               ""
                               [string-append l [slurp]]]]]]
[define o (lambda () (let ([f-name (get-file)])
                       ;[send display-box insert (with-input-from-file f-name (lambda () [slurp]))] ))]
                       [send display-box insert-file f-name]))]
[define with "with"]

[define command-pane%
  (class abstract-edit%
    (super-new)
    ;    [define/override [on-focus ev]
    ;      [when ev
    ;        [scroll-down]
    ;        [super on-focus ev]]]
    [define/override [on-char ev]
      [let((key  (send ev get-key-code)))
        (if (equal? key #\return)
            (begin
              (write "Caught return!")
              (let ([command (string-append "(" (send command-box get-text 0 'eof) ")")])
                [display [format "~nEvalling ~s~n" command]]
                [let [[results 
                       (eval (read-from-string command))]]
                  [if [list? results]
                      [set-data [string-join results "\n"]]
                      [set-data results]]]))
            
            
            [super on-char ev])]]
    )]

(define topwin (new (class frame%
                      (augment* [on-close (lambda () (exit))])
                      (super-new))
                    [label "editwin"]
                    [style '(metal)]))
(define mb (new menu-bar% [parent topwin]))
  (define m-edit (new menu% [label "Edit"] [parent mb]))
  (define m-font (new menu% [label "Font"] [parent mb]))
  (append-editor-operation-menu-items m-edit #f)
  (append-editor-font-menu-items m-font)

  

[define myedit%
  (class abstract-edit%
    (super-new)
    ;[define/override [on-focus ev]
    ;  [write "caught click in mid-edit"]
    ;  [super on-focus ev]] 
    ;[define/override [on-char ev]
    ;  (define b (box ""))
    ;  [send display-box get-position b]
    ;  [write [format "caught char in mid-edit at ~a(~a)~n" b [send display-box get-text [max 0[- [unbox b] 5]] [+ [unbox b] 5]]]]
     ; [write ev]
     ; [newline]
      
      
      
      ;[super on-char ev]]
    )]

[define [make-command-pane a-parent ]  
  ;(let[[ c (new editor-canvas% [parent a-parent])]
  (let[[ c (new command-pane% [parent a-parent][min-width 400][min-height 200])]
       ( t (new text%))]
    (send c set-editor t)
    [list c t])]
[define [make-display-pane a-parent ]  
  ;(let[[ c (new editor-canvas% [parent a-parent])]
  (let[[ c (new myedit% [parent a-parent][min-width 400][min-height 200])]
       ( t (new text%))]
    (send c set-editor t)
    [list c t])]
[define display-box [second [make-display-pane topwin]]]
[define command-box [second [make-command-pane topwin]]]
[set-data "
Text Mangler

Text Manger - It mangles text with the press of a button

Paste some text in, and you can strip commas, replace quotes, fix CAPS, encode, decode and change small amounts of text in helpful ways.  TextMangler was made to help you fix text that has been messed up by email programs, copied from web pages or is simply in need of formatting.

Use:  Paste some text into the top window, then type a command into the bottom window.

Examples:
lines reverse-text - reverse every line
text reverse-text  - reverse the entire page
lines uri-decode   - undo the %20 stuff in URLs
lines uri-encode   - opposite of uri-decode

lines replace \"Tim\" with \"Phil\" - search and replace Tim->Phil
lines enclose 
"]

[define [js-number-char? a-char] [regexp-match #rx"[0-9]" [list->string [list a-char]]]]
[define [js-symbol-char? a-char] [regexp-match #rx"[a-zA-Z]" [list->string [list a-char]]]]
[define [one-or-more-rec i-want?] [let [[next-char [peek-char]]]
                        [if [and [not [eof-object? next-char]] [i-want? next-char]]
                            [begin [read-char]
                            [cons next-char [one-or-more-rec i-want?]]]
                            '[]]]]
[define [one-or-more test] [let [[res [one-or-more-rec test]]]
                             [if [> [length res] 0] res #f]]]
[define [js-symbol] [one-or-more js-symbol-char?]]
[define [is-next? test?]  [let [[next-char [peek-char]]] test? next-char]]
[define [get-next]  [read-char]]
[define [get-next-valid test] [if [is-next? test] [get-next] #f]] 
[define [js-number] [one-or-more js-number-char?]]
[define [js-atom] [or  [js-symbol] [js-number]]]
[define [js-char a-char] [get-next-valid [lambda [t] [equal? t a-char]]] ]
[define [js-list] [list [js-char #\[] [js-char #\:] [js-char #\]]]]
[define [json-parse]
  [or [js-atom] [js-list]]]
[with-input-from-string "[,]" json-parse]
[send topwin show #t]