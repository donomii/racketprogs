#lang scheme/gui
; Make a frame by instantiating the frame% class

;Notes:
;get-editor in snip-admin% needs to be renamed get-parent-editor
;chain-to-keymap description is back to front
(require framework/test)
(require mred
         mzlib/class
         mzlib/math
         sgl
         sgl/gl-vectors
         framework
         mzlib/string
         framework
         racket/system
         srfi/1
         srfi/13
         mzlib/defmacro
         json
         )
[require [prefix-in http- net/http-easy]]
(require "old.rkt" "spath.rkt")
;(require (planet "htmlprag.ss" ("neil" "htmlprag.plt" 1 3)))
[define vars [make-hash [get-preference 'vars [lambda [] [list]]]]]

;[define vars [make-hash]]

[defmacro dox args [cadr args]]
[defmacro myset args `[set! ,[car args] ,[cdr args]]]
(application:current-app-name "Helpful Editor")

[define [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
  [close-input-port stderr-pipe]
  [close-output-port stdin-pipe]
  ;[control-proc 'wait]
  [read-string 9999999 stdout-pipe]
  ;[close-input-port stdout-pipe]
  ]

[define [shell-out a-string a-handler] [apply a-handler [process a-string]]]


[define keymaps
  `[
    ["c:r" "close-varedit" "Close variable viewport"]
    ["c:b" "pop-varedit" "Open variable viewport"]
    ["c:n" "pop-listvars" "Open viewport and list variables"]
    ["c:l" "open-let" "dunno"]
    ["c:e" "eval-selection" "Run selection in scheme evaluator"]
    ["c:up" "pop-viewport" "Open empty viewport"]
    ["c:m" "open-mexpr" "Open m-expression"]
    ["c:h" "open-html" "Open html"]
    ["c:s" "system-command"  "Shell out"]
    ["c:down" "shutdown-dispatcher" "Close the viewport and run the default action on the text"]
    ["c:k" "pop-keybindings" "Open viewport and show keybindings"]
    ["c:d" "pop-defs" "Open viewport and show definitions"]
    ["c:t" "pop-ctag" "Open viewport and show ctag"]
    ["c:o" "open-file" "Open file"]
    ["c:t" "pop-csearch" "Open viewport and show csearch"]
    ]
  ]


[define defs '[["word" . 
                       "The Helpful Editor will open a text portal when you press Control + Up.  Exactly 
what appears in the portal depends on context.  Here it is just text, but it can 
also be a code definition or the results of a function.  Portals can also nest:

> Nesting <

(Control + Up on 'Nesting')"]
               ["Nesting" . "Portals can nest as deeply as you like.  To close a portal, press Control + Down"]
               ; FIXME add actions like ["keybindings" . ,[lambda [x] [pop-keybindings]]]
               ]]
[define welcome-text 
  "Welcome to the Helpful Editor, the revolutionary editor that blah blah blah.  
Put the cursor inside the word below and press Control + Up

word

Or highlight any text and press:

Control + S to run it on the command line (Shell-out)
 - Control + Down will paste the text in the box into parent document

Control + E to eval as scheme code
 - Control + Down will paste the result of the eval into the parent document

Control + M to convert an sexpr to a mexpr
 - Control + Down will paste the result of the eval into the parent document

Control + K to edit the keybindings (currently not saved)



or

Control + B to edit the highlighted variable name

There are some important built-in variables that you will probably want to change.  
Remember you can highlight them here or on any other page, and press Control + B to edit.  Try it now:

scheme-project-files  - Force these files to be loaded
perl-project-files    - Force these files to be loaded as well as any auto-detected libraries

"]
[define get-tvar  [lambda [tvar-name] [hash-ref vars tvar-name [lambda [] #f]]]]
[define set-tvar! [lambda [tvar-name a-value] [hash-set! vars tvar-name a-value]]]
[unless [get-tvar "welcome-text"] [set-tvar! "welcome-text" welcome-text]]
[unless [get-tvar "current-filename"] [set-tvar! "current-filename" "no file"]]

[define command-output [lambda [a-command] [letrec [[pipes [process a-command]]
                                                    [stdout [car pipes]]]
                                             [read-string 99999 stdout]]]]
[define [highlight-active? a-text]
  [letrec [
           [highlight-start [send a-text get-start-position]]
           [hightlight-end [send a-text get-end-position]]]
    [not [eq? highlight-start hightlight-end]]]]

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

[define zap-word [lambda [a-text]  [letrec [[startbox [box [send a-text get-start-position]]] 
                                            [endbox [box [send a-text get-start-position]]] 
                                            [start (send a-text find-wordbreak startbox #f 'selection)]
                                            [end (send a-text find-wordbreak #f endbox  'selection)]]
                                     [send a-text kill 0 [unbox startbox] [unbox endbox]]]]]
[define viewport-data '[]]
;  [define add-viewport [the-viewport name ]]
[define viewports '[]]
[define viewports-start-len '[]]
[define viewports-name '[]]
[define shutdown-funcs '[]]
[define num 0]
[define seqnum [lambda [] [set! num [add1 num]][format "~a" num]]]
[define my-frame% [class frame% 
                    [super-new]
                   
                    [define/augment on-close [lambda args [letrec 
                                                              [[text [send t get-text 0 9999999]]]
                                                            ;[set-tvar! "welcome-text" text]
                                                            [put-preferences '[vars] [list [hash->list vars]] ][exit]]]]]]

[define my-frame2% [class frame% 
                     [super-new]
                     [define/augment on-close [lambda args [letrec 
                                                               [[text [send t get-text 0 9999999]]]
                                                             ;[set-tvar! "welcome-text" text]
                                                             [put-preferences '[vars] [list [hash->list vars]] ][exit]]]]]]


(define editor-window [dox "Make new frame" (new my-frame% [label (application:current-app-name)]
                                                 [width 800]
                                                 [height 600])])
;(define commentary-window [dox "Make new frame" (new my-frame2% [label "Commentary"]
;                                                     [width 800]
;                                                     [height 600])])
[send editor-window create-status-line]
(define hpane (new horizontal-pane% [parent editor-window]))

(define c (new editor-canvas% [parent hpane]))
(define commentary-window-canvas (new editor-canvas% [parent hpane]))
[define mydelta (make-object style-delta% )]
[send mydelta  set-family 'modern]
[send mydelta  set-face #f]

(define my-editor-text% [class scheme:text%
                          [super-new]
                          [define/override on-default-event [lambda [event]
                                                              [super on-default-event event]
                                                              [when [send event button-up? 'any]
                                                                
                                                                [send commentary-text erase]
                                                                [let [[comment [comment-callback this commentary-text 'mouse event [get-word this]]]]
                                                                  [when [not [equal? comment ""]]
                                                                    
                                                                    [send commentary-text insert [format "~a" comment]]
                                                                    ]]]]]
                          
                          [define/override on-default-char [lambda [event]
                      
                                                             [super on-default-char event]
                                                             [send commentary-text erase]
                                                             [let [[comment [comment-callback this commentary-text 'char event [get-word this]]]]
                                                               [when [not [equal? comment ""]]
                                                                 
                                                                 [send commentary-text insert [format "~a" comment]]
                                                                 ]]
                                                             ]]
                          ;[define/augment after-insert [lambda [start end] [write "aaaa"][send this change-style mydelta start end]]]
                          ;[define/augment after-insert [lambda [start end] ]]
                   
                          ])

(define my-commentary-text% [class scheme:text%
                              [super-new]
                  
                              ;[define/augment after-insert [lambda [start end] [write "aaaa"][send this change-style mydelta start end]]]
                              ;[define/augment after-insert [lambda [start end] ]]
                   
                              ])



(define image-callback-snip% [class image-snip%
                               [super-new]
                               [field [data #f]]
                               [field [callback #f]]
                               [define set-callback [lambda [a-callback] [set! callback a-callback]]]
                          
                               [define/override on-event [lambda [dc x y ex ey event]
                                                           [super on-event  dc x y ex ey event]
                                                           [when [send event get-left-down]
                                                             [callback dc x y ex ey event]
                                                             ]
                                                           ]]
                               [define/override on-char [lambda [dc x y ex ey event]
                                                     
                                                    
                                                          [super on-char  dc x y ex ey event]
                                                     
                                                          [callback dc x y ex ey event]
                                                          ]]
                               ;[define/augment after-insert [lambda [start end] [write "aaaa"][send this change-style mydelta start end]]]
                               ;[define/augment after-insert [lambda [start end] ]]
                   
                               ])

(define image-jump-snip% [class image-snip%
                           [super-new]
                           [field [data #f]]
                          
                           [define/override on-event [lambda [dc x y ex ey event]
                                                       [super on-event  dc x y ex ey event]
                                                       [when [send event get-left-down]
                                                         [displayln [format "Scrolling to ~s of ~s ~n" [second data] (send t num-scroll-lines)]]
                                                         [send t erase]
                                                         [send t insert [file->string [first data]]]
                                                         [set-tvar! "current-filename"  [first data]]
                                                         [send t scroll-to-position [second data]]
                                                         [send editor-window set-label [get-tvar "current-filename"]]
                                                         ]
                                                       ]]
                           [define/override on-char [lambda [dc x y ex ey event]
                                                     
                                                    
                                                      [super on-char  dc x y ex ey event]
                                                     
                                                      [displayln [format "Scrolling to ~s~n" [second data]]]
                                                      [send t erase]
                                                      [send t insert [file->string [first data]]]
                                                      [set-tvar! "current-filename"  [first data]]
                                                      [send t scroll-to-position [second data]]
                                                      [send editor-window set-label [get-tvar "current-filename"]]
                                                      ]]
                           ;[define/augment after-insert [lambda [start end] [write "aaaa"][send this change-style mydelta start end]]]
                           ;[define/augment after-insert [lambda [start end] ]]
                   
                           ])

(define t (new my-editor-text%))
(define commentary-text (new text%))
[send t auto-wrap #t]
[send commentary-text auto-wrap #t]
(send c set-editor t)
[send commentary-window-canvas set-editor commentary-text]
(send commentary-window-canvas set-editor commentary-text)
[send t set-max-undo-history 50]
[send t insert welcome-text]
;text% is relentless in its desire to apply ANY style other than the one I want
[define force-fucking-style [lambda [a-text]
                              [send [send t get-wordbreak-map] set-map #\- [list 'selection]]
                              [send [send t get-wordbreak-map] set-map #\_ [list 'selection]]
                              [define slist [send t get-style-list]]
                              [send t set-paste-text-only #f]
                              [send slist new-named-style "J" [send slist find-or-create-style [send slist basic-style] mydelta]]
                              
                              [send t change-style  mydelta 0 1]
                              [send t set-styles-sticky #t]
                              ]]
[force-fucking-style t]
[define a-keymap [send t get-keymap]]
[define longest-length [lambda [a-list] 
                         [let [[longest 0]]
                           [map [lambda [s] [when [> [string-length s] longest]
                                              [set! longest [string-length s]]]] 
                                a-list]
                           longest]]]
[define rebuild-let [lambda [defs-list code]
                      [let [[str-port [open-output-string]]]
                        [display [format "(let ("] str-port]
                        [map [lambda [a-def] [when [> [length a-def] 1] [display [format "(~a ~a)\n" [car a-def] [cadr a-def]] str-port]]] defs-list]
                        [display [format ")\n~a)" code] str-port]
                        [get-output-string str-port]
                        ]]]


[define [add-shutdown-func an-editor l] [set! shutdown-funcs [cons [cons an-editor
                                                                         [make-shutdown-func l]]  shutdown-funcs]]]
;[send t set-clickback 0 3 [lambda [atext x y] [display "CLicky!"][newline]]]


[define search-text-for-snip-recur [lambda [atext asnip pos] [let [[testsnip [send atext get-text pos [add1 pos]]]]
                                                               ;[display "Comparing "]
                                                               ;[write asnip]
                                                               ;[write testsnip]
                                                               ;[newline]
                                                               [if [eq? testsnip asnip]
                                                                   pos
                                                                   [search-text-for-snip-recur atext asnip [add1 pos]]]]]]
[define search-text-for-snip [lambda [atext asnip] [search-text-for-snip-recur atext asnip 0] ]]


[define [make-shutdown-func f]
  [lambda [b e]  
    [letrec [[snip [send  [send b get-admin] get-snip]]
             [t [send [send snip get-admin] get-editor]]
             [ed-snip [send snip get-editor]]
             [text [f t snip [send ed-snip get-text 0 9999999]]]
             [name [cdr [assq snip viewports-name]]]
             [start [send t get-snip-position snip]]
             [end [add1 start]]]
      [send t kill 0 start end]
      [newline]
      [send t set-position start 'same]
      [send t insert text]]]
  ]

; The first function prepares to open the box.  The return value is placed in the box
; The second function closes the box
[define [make-pop-func f close-f] [lambda [t e]
                                    [letrec [[untrimmed-word [get-word t]]
                                             [word [regexp-replace* "\\[|\\]|\\(|\\)" untrimmed-word ""]]
                                             ]
                                      ;[display [format "Found word: ~a~n" word]]
                                      
                                      [begin 
                                        [let [[new-box [new editor-snip% [left-margin 20][max-width 40] [max-height 40]]]
                                              [new-text [new my-editor-text%]]]
                                          
                                          [let [[replacement-text [f new-box word]]]
                                            [when replacement-text
                                              [zap-word t]
                                              
                                              
                                              ;[let [[new-box [send t on-new-box 'text]]]
                                              [send new-box set-editor new-text]
                                              [send t insert new-box]
                                              [set! viewports-name [cons [cons new-box word]  viewports-name]]
                                              
                                              
                                              [send [send new-box get-editor] insert  [regexp-replace* "\r" replacement-text ""]]
                                              [send [send new-box get-editor] set-caret-owner #f 'global]
                                              [insert-keybindings [send new-box get-editor]]
                                              
                                              
                                              [add-shutdown-func new-box close-f]]  shutdown-funcs]]]]]]
;Three functions.  The first loads the text for the snip, the second is called after loading, and the third is called on shutdown
[define [make-extra-pop-func f middle-f close-f] [lambda [t e]
                                                   [letrec [[untrimmed-word [get-word t]]
                                                            [word [regexp-replace* "\\[|\\]|\\(|\\)" untrimmed-word ""]]
                                                            ]
                                                     ;[display [format "Found word: ~a~n" word]]
                                      
                                                     [begin 
                                                       [let [[new-box [new editor-snip% [max-width 600] [max-height 300]]]
                                                             [new-text [new my-editor-text%]]]
                                          
                                                         [let [[replacement-text [f new-box word]]]
                                                           [when replacement-text
                                                             [zap-word t]
                                              
                                              
                                                             ;[let [[new-box [send t on-new-box 'text]]]
                                                             [send new-box set-editor new-text]
                                                             [send t insert new-box]
                                                             [set! viewports-name [cons [cons new-box word]  viewports-name]]
                                              
                                              
                                                             [send [send new-box get-editor] insert  [regexp-replace* "\r" replacement-text ""]]
                                                             [send [send new-box get-editor] set-caret-owner #f 'global]
                                                             [insert-keybindings [send new-box get-editor]]
                                                             [middle-f new-box word]
                                              
                                              
                                                             [add-shutdown-func new-box close-f]]  shutdown-funcs]]]]]]




[define pop-viewport [make-pop-func [lambda [new-box word]  [letrec [[linked [assoc word defs]]]
                                                              [set! viewports-name [cons [cons new-box word]  viewports-name]]
                                                              [if linked [cdr linked] #f]]]
                                    [lambda [parent child text] [cdr [assq child viewports-name]]]]]

[define pop-command-viewport  [make-pop-func [lambda [new-box word]
                                               [write "Creating command box"]
                                               [set! viewports-name [cons [cons new-box word]  viewports-name]]
                                               ""
                                               ]
                                             [lambda [parent child text]  [write "closing command box"](with-input-from-string text
                                                                                                         (lambda () (eval (read))))]]]

[define pop-varedit  [make-pop-func [lambda [a-box word] [write "popping varedit"]
                                      ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                      [pretty-format [hash-ref vars word [lambda [] "unknown"]]]]
                                    
                                    [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
                                                                                 [the-set! [format "(set! ~a [quote ~a])" var-name the-text]]]
                                                                          ;[display [format "Evalling ~a~n" the-set!]]
                                                                          ;[eval-string the-set!]
                                                                          
                                                                          [hash-set! vars var-name [read [open-input-string the-text]]]
                                                                          ""]]]]
[define pop-listvars  [make-pop-func [lambda [a-box word] [write "popping listvars"]
                                       ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                       [pretty-format [hash-keys vars ]]
                                       ]
                                    
                                     [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
                                                                                  [the-set! [format "(set! ~a [quote ~a])" var-name the-text]]]
                                                                           ;[display [format "Evalling ~a~n" the-set!]]
                                                                           ;[eval-string the-set!]
                                                                          
                                                                           [hash-set! vars var-name [read [open-input-string the-text]]]
                                                                           ""]]]]

[define pop-keybindings  [make-pop-func [lambda [a-box word] [write "popping keybindings"]
                                          ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                          [format "`~a" [pretty-format keymaps]]
                                          ]
                                    
                                        [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
                                                                                     ]
                                                                              ;[display [format "closing ~a~n" var-name]]
                                                                              ;[eval-string the-set!]
                                                                          

                                                                              [set! keymaps [eval-string the-text]]
                                                                              [map [lambda [definition]
                                                                                     ;[display [format "Binding ~a to ~a~n" [first definition] [second definition]]]
                                                                                     [send a-keymap map-function [first definition] [second definition]]]
                                                                                   keymaps]
                                                                              [insert-keybindings t]
                                                                              ""]]]]


[define pop-defs  [make-pop-func [lambda [a-box word] [write "popping defs"]
                                   ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                   [format "`~a" [pretty-format defs]]
                                   ]
                                    
                                 [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
                                                                              ]
                                                                       ;[display [format "closing ~a~n" var-name]]
                                                                       ;[eval-string the-set!]
                                                                          

                                                                       [set! defs [eval-string the-text]]
                                                                          
                                                                       ""]]]]
[define [do-csearch word] [command-output [string-concatenate `["csearch " ,word " | head -100"]]]]
[define pop-csearch  [make-extra-pop-func [lambda [a-box word] [write "popping csearch"]
                                            ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                            [do-csearch word]
                                         
                                            ]

                                          [lambda [a-snip word]
                                            [letrec [[editor [send a-snip get-editor]]
                                                     [text [send editor get-text]]
                                                     ;[position [send editor find-string word 'forward 'start 'eof #t #f]]
                                                     [position [string-contains text word ]]
                                                     ]
                                              ;[display text]
                                              [thread [lambda []
                                                        [sleep 5]
                                                        [printf "Found word '~s' at ~a\n" word position]
                                                        [send editor set-position [+ 200 position]]
                                                        [send editor set-position position]
                                                        ;[send editor refresh]
                                           
                                                     
                                                        [send editor scroll-to-position position #f [+ 100 position]]
                                                        [printf "Canvas: ~a\n" [send editor get-canvases]]
                                                        ]]
                                              ]
      
                                            ]
                                    
                                          [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]]
                                                                                [display [format "closing ~a~n" var-name]]
                                                                                ;[eval-string the-set!]
                                                                          

                                                                                var-name]]]]


[define pop-ctag  [make-extra-pop-func [lambda [a-box word] [write "popping ctags"]
                                         ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                         [let [[tag-data [find-ctag word [load-ctags-file "tags"]]]]
                                           [if [empty? tag-data]
                                               #f
                                               [begin
                                          
                                                 [file->string [second [first tag-data ]]]]]
                                           ]]

                                       [lambda [a-snip word]
                                         [letrec [[editor [send a-snip get-editor]]
                                                  [text [send editor get-text]]
                                                  ;[position [send editor find-string word 'forward 'start 'eof #t #f]]
                                                  [position [string-contains text word ]]
                                                  ]
                                           ;[display text]
                                           [thread [lambda []
                                                     [sleep 5]
                                                     [printf "Found word '~s' at ~a\n" word position]
                                                     [send editor set-position [+ 200 position]]
                                                     [send editor set-position position]
                                                     ;[send editor refresh]
                                           
                                                     
                                                     [send editor scroll-to-position position #f [+ 100 position]]
                                                     [printf "Canvas: ~a\n" [send editor get-canvases]]
                                                     ]]
                                           ]
      
                                         ]
                                    
                                       [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]]
                                                                             ;[display [format "closing ~a~n" var-name]]
                                                                             ;[eval-string the-set!]
                                                                          

                                                                             var-name]]]]

[define [shutdown-dispatcher b e] [ letrec [[snip [send  [send b get-admin] get-snip]]
                                            [t [send [send snip get-admin] get-editor]]
                                            [ed-snip [send snip get-editor]]
                                            [shutdown-func   [cdr [assq snip shutdown-funcs]]]]
                                     [shutdown-func b e]]]




[define def-names [lambda [a-list]
                    [map car a-list]]]

[define [make-open-selection f close-f] [lambda [t e] 
                                          [letrec [[some-text [send t get-text [send t get-start-position] [send t get-end-position]]]
                                                   
                                                   [new-box [send t on-new-box 'text]]
                                                   ]
                                            
                                            
                                            [send new-box set-editor [new my-editor-text%]]
                                            [force-fucking-style [send new-box get-editor]]
                                            [send t insert new-box]
                                            [set! viewports-name [cons [cons new-box some-text]  viewports-name]]
                                            
                                            
                                            [send [send new-box get-editor] insert   [regexp-replace* "\r" [format "~a" [f t new-box some-text]] ""]]
                                            [send [send new-box get-editor] set-caret-owner #f 'global]
                                            ;[send [send new-box get-editor] tabify-all]
                                            [insert-keybindings [send new-box get-editor]]
                                            
                                            [add-shutdown-func new-box close-f]]]]

[define open-mexpr [make-open-selection [lambda [parent child text] [statements->mexpr  [read [open-input-string text]]]] 
                                        [lambda [parent child text] text]]]
[define close-viewport [make-shutdown-func [lambda [parent child text] text]]]
[define abort-viewport [make-shutdown-func [lambda [parent child text] ""]]]
[define close-let [make-shutdown-func [lambda [parent child text]
                                        [write "Closing let"] [newline]
                                        [letrec [
                                                 [bits [regexp-split #rx"\n---\n\n" text]]
                                                 [defs [car bits]]
                                                 [code [cadr bits]]
                                                 [def-lines [regexp-split #rx"\n" defs]]
                                                 [def-pairs [map [lambda [l] [regexp-split #rx":" l]] def-lines]]
                                                 
                                                 ]
                                          [write def-pairs]
                                          
                                          [rebuild-let def-pairs code]
                                          
                                          ]]]]
[define open-let1 [make-open-selection [lambda [parent child some-text]
                                         
                                         [letrec [[a-list [read [open-input-string some-text]]]
                                                  [defs [cadr a-list]]
                                                  [code [cddr a-list]]
                                                  [temp-str ""]
                                                  
                                                  [defs-maxlength [longest-length [map symbol->string [def-names defs]]]]]
                                           ;[display defs-maxlength]
                                           
                                           [string-append  
                                            [strip-brackets  defs defs-maxlength]
                                            "\n---\n\n"
                                            [statements->mexpr code]
                                            ]]] close-let] ]



[define insert-keybindings [lambda [a-text] [let [[ a-keymap [new keymap:aug-keymap%]]]
                                              
                                              [set-keybindings a-keymap]
                                              
                                              [send [send a-text get-keymap] chain-to-keymap a-keymap    #t]
                                              ;[write  [send a-keymap get-map-function-table]]
                                              
                                              ;[write [send [send a-text get-keymap] get-map-function-table]]
                                              ;[send t set-keymap a-keymap]
                                              
                                              
                                              ;[write [send [car (send a-keymap get-chained-keymaps)] ]]
                                              ]]]
;[new button% [label "Open viewport"] [parent f] [callback ]]


;[define open-html [make-open-selection [lambda [parent child text] [pretty-format [html->shtml   text]]]
;                                         [lambda [parent child text] [display "converting to html..."] [shtml->html text][shtml->html [read [open-input-string text]]]]]]
[define system-command [make-open-selection [lambda [parent child some-text] [command-output some-text]]
                                            [lambda [parent child text] text]]]

[define eval-selection [make-open-selection [lambda [parent child some-text] [eval-string some-text]]
                                            [lambda [parent child text] text]]]


(define button-pane (new horizontal-panel% [parent editor-window]))
(send button-pane stretchable-height #f)
[new button% [label "Close viewport"] [parent button-pane] [callback close-let]]

[new button% [label "Cindex"] [parent button-pane] [callback [lambda [a b] [cindex-directory [get-directory]]]]]

[define [cindex-directory a-dir]
[let [[cmd [format "/Users/jeremyprice/go/bin/cindex \"~a\"" a-dir]]]
  [displayln cmd]
  [shell-out cmd [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 

                                                                              [send commentary-text erase]
                                                               
                                                                    
                                                                    [send commentary-text insert [format "~a" 

                                                                    [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]]]
                                    ]]]]

[define open-file [make-open-selection
                   [lambda [parent child some-text] 
                     [letrec [[a-text  [file->string some-text]]]
                       a-text]] close-let] ]

; Ideally, we would be able to display these to the user, let them edit, then read them back
[define [set-keybindings a-keymap]
  [send a-keymap add-function "close-varedit" shutdown-dispatcher]
  
  [send a-keymap add-function "pop-varedit" pop-varedit]
  
  [send a-keymap add-function "pop-listvars" pop-listvars]
  [send a-keymap add-function "pop-keybindings" pop-keybindings]
  [send a-keymap add-function "pop-defs" pop-defs]
  [send a-keymap add-function "pop-ctag" pop-ctag]
  
  [send a-keymap add-function "pop-csearch" pop-csearch]
  
  [send a-keymap add-function "close-viewport" close-viewport]
  [send a-keymap add-function "abort-viewport" abort-viewport]
  
  [send a-keymap add-function "pop-viewport" pop-viewport]
  [send a-keymap add-function "open-let" open-let1]

  [send a-keymap add-function "eval-selection" eval-selection]
  [send a-keymap add-function "open-mexpr" open-mexpr]
  
  ;[send a-keymap add-function "open-html" open-html]
  
  [send a-keymap add-function "system-command" system-command]
  
  [send a-keymap add-function "shutdown-dispatcher" shutdown-dispatcher]
  [send a-keymap add-function "pop-command-viewport" pop-command-viewport]
  [send a-keymap map-function "c:down" "shutdown-dispatcher"]
  [send a-keymap add-function "open-file" open-file]
  ;[send a-keymap map-function "c:," "close-let"]
  
  [map [lambda [definition]
         ;[display [format "Binding ~a to ~a~n" [first definition] [second definition]]]
         [send a-keymap map-function [first definition] [second definition]]]
       keymaps]
  ]

[insert-keybindings t]
[insert-keybindings commentary-text]
(send editor-window show #t)
;(send commentary-window show #t)


(define last-file-name #f)
(define mb (new menu-bar% [parent editor-window]))
(define m-file (new menu% [label "File"] [parent mb]))
[new menu-item% [label "Open..."] [parent m-file] [callback [lambda args [load-file [get-file]]]] [shortcut #\o]]
[new menu-item% [label "Open Scheme"] [parent m-file] [callback [lambda args [load-scheme-file [get-file]]]] [shortcut #\o]]
[new menu-item% [label "Open Perl"] [parent m-file] [callback [lambda args [load-perl-file [get-file]]]] [shortcut #\o]]
[new menu-item% [label "Save..."] [parent m-file] [callback [lambda args [save-file last-file-name]]] [shortcut #\a]]
[new menu-item% [label "Save As..."] [parent m-file] [callback [lambda args [save-file [put-file]]]] [shortcut #\a]]
[new menu-item% [label "Exit"] [parent m-file] [callback [lambda args [put-preferences '[vars] [list [hash->list vars]] ][exit]]] [shortcut #\q]]
(define m-edit (new menu% [label "Edit"] [parent mb]))
(define m-font (new menu% [label "Font"] [parent mb]))
;(append-editor-file-menu-items m-file #f)
(append-editor-operation-menu-items m-edit #f)
(append-editor-font-menu-items m-font)
;[write [send t insert-box 'text]]
;[send [send [car viewports] get-editor] insert "hello"]
;[write viewports]
; Show the frame by calling its show method

[define load-file [lambda  [a-path]
                    [send t erase]
                           
                    [let  [[file-source [call-with-input-file a-path [lambda [in] [read-string 999999 in]] #:mode 'text]]]
                      (set! last-file-name a-path)
                      [send t insert file-source]]
                    [set-tvar! "current-filename" a-path]
                    ]]
[define load-scheme-file [lambda  [a-path]
                           [send t erase]
                           [read-accept-reader #t]
                           [set! defs [get-multi-defs [cons a-path [hash-ref vars "project-files" [lambda [] '[]]]]]]
                           [let  [[file-source [call-with-input-file a-path [lambda [in] [read-string 999999 in]] #:mode 'text]]]
                             (set! last-file-name a-path)
                             [send t insert file-source]]
                           [pretty-write defs]]]
[define [get-perl-multi-defs input-files]
  [apply append [map [lambda [a-path]
                       [read-from-string [shell-out "perl extract_subs.pl" [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
                                                                             [send editor-window set-status-text [format "Loading ~a" a-path]]
                                                                             [display a-path stdin-pipe]
                                                                             [newline stdin-pipe]
                                                                             [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]
                                                                             ]]]]
                     input-files]]]
[define csearch [lambda [a-string]
                  [if  [< [string-length a-string] 4] ""
                       [shell-out [format "/Users/jeremyprice/go/bin/csearch -f \\.go\\$ -n ~a | head -100"  a-string]
                                  [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
                                    [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]
                                    ]]
                       ]]]

[define tagsearch [lambda [a-string]
                    [if [< [string-length a-string] 4] ""
                        [shell-out [format "grep \"~a\" tags | head -100" a-string]
                                   [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
                                     [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]
                                     ]]
                        ]]]
[define [status some-text] [send editor-window set-status-text some-text]]
[define load-perl-file [lambda  [a-path]
                         [send t erase]
                         [read-accept-reader #t]
                         [let  [[file-source [call-with-input-file a-path [lambda [in] [read-string 999999 in]] #:mode 'text]]]
                           [send t insert file-source]
                           [set! defs [get-perl-multi-defs [cons a-path [hash-ref vars "perl-project-files" [lambda [] '[]]]]]]
                           
                           [write defs]]
                         [status [format "Loaded ~a" a-path]]]]
[define save-file [lambda [a-path]
                    [when a-path
                      [call-with-atomic-output-file
                       a-path
                       [lambda [a-port another-path]
                         [display [send t get-text 0 9999999] a-port]]]]]]

[define [find-ctag name ctags] [filter [lambda [x] [equal? name [car x]]] ctags]]
[define [load-ctags-file a-path] [map [lambda [x] [string-split  x #px"\t+|\\s+" ]] [file->lines a-path] ]]

[define [grep-ctags-file a-term]
  [if [eq? a-term ""] '()
      [map [lambda [x] [string-split  x #px"\t+|\\s+" ]] [string-split
                                                          [let [[output [tagsearch a-term]]]
                                                            [if [eq? output eof ]
                                                                ""
                                                                output]]
                                                          "\n"] ]]]

[define [format-ctags-results results]
  [map [lambda [tag-data]
         [letrec [
                  [tag [first tag-data]]
                  [filename [second  tag-data ]]
                  [line-number [sub1 [false-to-zero [string->number [break-line-field [third  tag-data ]]]]]]
                  ]
           [list tag filename line-number]
           ]]
       results]
        
        
  ]

;/Users/jeremyprice/racketProgs/the-helpful-editor/editor.scm:439:[define pop-keybindings  [make-pop-func [lambda [a-box word] [write "popping keybindings"]
[define [format-csearch-results tag results]
  ;[displayln [format "Formatting csearch results ~a~n" results]]
  [if [eq? eof results] '[]
      [map [lambda [line]
             [letrec [
                      [tag-data [string-split line ":"]]
                                      
                      [filename [first  tag-data ]]
                      [line-number [sub1 [string->number[second tag-data]]]]
                      [example [third tag-data]]
                      ]
               [list tag filename line-number]
               ]]
           [string-split results "\n"]]
        
        
      ]]


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

[define [line->position text target-line linecount current-pos]
  [if [> linecount target-line]
      current-pos
      [let [[letter [string-ref text current-pos]]]
        [if [equal? #\newline letter]
            [line->position text target-line [add1 linecount] [add1 current-pos]]
            [line->position text target-line linecount [add1 current-pos]]]
        ]
      ]
  ]

[define [render-filename word commentary editor]
  [send commentary insert [get-tvar "current-filename"]]
  

  ]
  
[define [render-search word commentary editor direction]
  [let [[snp [make-object image-callback-snip% "Skip to" ]]]
    ;[set-field! data snp [list [second  tag-data ]   char-position]]
    [set-field! callback snp [lambda [dc x y ex ey event]
                               [let [[next [send editor find-string word direction [if [eq? direction 'forward]
                                                                                       [add1 [send editor get-start-position]]
                                                                                       [sub1 [send editor get-start-position]]]]]]
                                 [displayln [format "Skipping to ~a" next]]
                                 [send editor scroll-to-position next]
                                 [send editor set-position next]]]]
    [send snp set-flags '[ handles-events ]]
    [send commentary insert snp]
    [send commentary insert [format "Skip ~a to next ~a" direction word ]]
                     
    ]]


[define [render-wiktionary word commentary editor ]
  [letrec [[search-results [http-get [format "https://en.wiktionary.org/w/api.php?action=parse&page=~a&prop=wikitext&formatversion=2&format=json" word]]]
           [json-results [bytes->jsexpr [http-response-body search-results] ]]
           ;[urls [fourth json-results]]
           [wikitext  [sf 'parse/wikitext json-results ""]]
           [sections [string-split wikitext [format "\n=="]]]
           [wanted [filter [lambda [str] [regexp-match "Noun|Verb|Adjective|Adverb" str]] sections]]
           [text [string-join wanted [format "\n"]]]
           ]
    ; [display [dict? json-results]]
    ;[display [dict-ref json-results 'parse]]
    ; [display [spath '[ parse] json-results]]
    [send commentary insert text]
  
    ;[map [lambda [url] [send commentary insert [bytes->string/utf-8 [http-response-body  [http-get url ] ] ]]]
    ;urls]
    ]]
  


[define [render-jump-to-file word commentary editor]
  [letrec [[tag-list [if [highlight-active? editor]
                         [format-csearch-results word [csearch word]]
                         [format-ctags-results [find-ctag word [grep-ctags-file word]]]]]]
    [if [empty? tag-list]
        [format "No results found for ~a" word]
        [begin
          [map [lambda [tag-data]
                 [letrec [
                          [text [file->string [second  tag-data ]]]
                          [line-number [third  tag-data ]]
                          [ out [format "~a" [extract-line text line-number]]]
                          [char-position [line->position text [- line-number 5] 0 0]]
                          ]
                   ;[displayln [format "line-number: ~a" line-number]]
                   [send commentary insert out]
                                                                       
                   ;[send editor insert     [make-object string-snip% "Load"  ]]
                   [send commentary insert "\n"]
                   [let [[snp [make-object image-jump-snip% [format "Load file: ~a" [list [second  tag-data ] line-number ] ] ]]]
                     [set-field! data snp [list [second  tag-data ]   char-position]] 
                     [send snp set-flags '[ handles-events ]]
                     [send commentary insert snp]
                     [send commentary insert [format "Load: ~a" [list [second  tag-data ] line-number ] ]]
                     [send commentary insert "\n\n"]
                     out
                     ]]
                 ] tag-list]
          ""
          ]
        ]
    ]
  ]

[define [comment-callback editor commentary type event word]

  ;[display [format "->~a<-" csearch-list]]
  ;[display commentary]
  [render-filename word commentary editor]
  [send commentary insert "\n\n"]
  [render-search word commentary editor 'forward]
  [render-search word commentary editor 'backward]
  [send commentary insert "\n\n"]
  [render-wiktionary word commentary editor]
  [render-jump-to-file word commentary editor]
           
  ""
  ]




