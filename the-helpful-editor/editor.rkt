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
[require anaphoric]
[require suffixtree]
(require pfds/trie)
[require [prefix-in http- net/http-easy]]
(require "old.rkt" "spath.rkt")
(require "editboxsupport.rkt")
(require "support.rkt")
;(require (planet "htmlprag.ss" ("neil" "htmlprag.plt" 1 3)))
[define vars [make-hash [get-preference 'vars [lambda [] [list]]]]]
[printf "Loaded prefs: ~a\n" vars]
[define undo-stack '()]
[define undo-pos-stack '()]
[define undo-filename-stack '()]

[define undo-forward-stack '()]
[define undo-forward-pos-stack '()]
[define undo-forward-filename-stack '()]


;[define vars [make-hash]]

[defmacro dox args [cadr args]]
[defmacro myset args `[set! ,[car args] ,[cdr args]]]
(application:current-app-name "Commentary")

[define debug [lambda args [displayln [apply format args]]]]
;[define debug [lambda args #f]]

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
  "Welcome to Commentary.

Commentary is a pluggable framework to combine the output of multiple search tools
and plugins in a convenient way.

You can type text on the left here, and the plugins will add their commentary on the right.

You will see different options depending on whether you put the cursor on a word or if you select some text.


"]
[define get-tvar  [lambda [tvar-name] [hash-ref vars tvar-name [lambda [] #f]]]]
[define get-tvar-fail  [lambda [tvar-name fail-thunk] [hash-ref vars tvar-name fail-thunk]]]
[define set-tvar! [lambda [tvar-name a-value]
                    [hash-set! vars tvar-name a-value]
                    [printf "Saving tvars ~a\n" vars]
                    [put-preferences '[vars] [list [hash->list vars]] ]
                    ]]
[unless [get-tvar "welcome-text"] [set-tvar! "welcome-text" welcome-text]]
[unless [get-tvar "current-filename"] [set-tvar! "current-filename" "no file"]]


[define [highlight-active? a-text]
  [letrec [
           [highlight-start [send a-text get-start-position]]
           [hightlight-end [send a-text get-end-position]]]
    [not [eq? highlight-start hightlight-end]]]]





[define viewport-data '[]]
;  [define add-viewport [the-viewport name ]]
[define viewports '[]]
[define viewports-start-len '[]]
[define viewports-name '[]]
[define shutdown-funcs '[]]
[define num 0]
[define seqnum [lambda [] [set! num [add1 num]][format "~a" num]]]

;Create left text area
[define my-frame% [class frame% 
                    [super-new]
                   
                    [define/augment on-close [lambda args [letrec 
                                                              [[text [send left-text-editor get-text 0 9999999]]]
                                                            ;[set-tvar! "welcome-text" text]
                                                            [put-preferences '[vars] [list [hash->list vars]] ][exit]]]]]]
;Create right text area class
[define my-frame2% [class frame% 
                     [super-new]
                     [define/augment on-close [lambda args [letrec 
                                                               [[text [send left-text-editor get-text 0 9999999]]]
                                                             ;[set-tvar! "welcome-text" text]
                                                             [put-preferences '[vars] [list [hash->list vars]] ][exit]]]]]]

;
(define editor-window [dox "Make new frame" (new my-frame% [label (application:current-app-name)]
                                                 [width 800]
                                                 [height 600])])
;(define commentary-window [dox "Make new frame" (new my-frame2% [label "Commentary"]
;                                                     [width 800]
;                                                     [height 600])])
[send editor-window create-status-line]
(define hpane (new horizontal-pane% [parent editor-window]))

(define left-editor-canvas (new editor-canvas% [parent hpane]))
[define right-panel (new vertical-panel%	 
                         [parent hpane]		 
                         [enabled #t])]
[define settings-panel (new vertical-panel%	 
                            [parent right-panel]		 
                            [enabled #t])]
[set-tvar! "settings-panel-active" #t]
[define source-dirs-text [new text%]]
[send source-dirs-text insert [get-tvar-fail "source-dirs" [lambda [] "./\n"]]]
[define source-dirs-canvas [new editor-canvas% [parent settings-panel] [line-count 3]]]

                          
(send source-dirs-canvas set-editor source-dirs-text)

[define [get-source-dirs]
  [string-split  [send source-dirs-text get-text 0 'eof #t #f] "\n"]
  ]

(define source-buttons-panel (new horizontal-panel% [parent settings-panel]
                                  [alignment '(center center)]))
 
[new button% [label "Add source"] [parent source-buttons-panel]
     [callback [lambda [a b] [send source-dirs-text insert [string-append  [aif [get-directory] [path->string it] "./\n"] "\n"]]]]]

[new button% [label "Refresh"] [parent source-buttons-panel]
     [callback [lambda [a b]
                 ;[printf "~a\n" [format [send gotags-refresh-field get-value] "./"]]
                 ;[printf "~a\n" [command-output [format [send gotags-refresh-field get-value] "~/"]]]
                 [debug "Gotags command: ~a\n" [append (list "./gotags" "-R" "-f" "tags") [string-split [send source-dirs-text get-text] "\n"]]]
                 [debug "~a\n" (apply system* [append (list "./gotags" "-R" "-f" "tags") [string-split [send source-dirs-text get-text] "\n"]])]
                 [map  [lambda [x] [cindex-directory x] ]  [string-split [send source-dirs-text get-text] "\n"]]
                 ;[printf "~a\n"[format [send csearch-refresh-field get-value] "~/"]]
                 ;[printf "~a\n" [command-output [format [send csearch-refresh-field get-value] "./"]]]
                 ]]]

;[define gotags-refresh-field [new text-field% [label "tags command"] [parent settings-panel] [init-value "./gotags -R -f tags ~a"] ]]
[define max-results-field [new text-field% [label "Max Results"] [parent settings-panel] [init-value [get-tvar-fail "max-results" [lambda [] "50"]]] ]]
[define [get-max-results] [string->number [send max-results-field get-value]]]
;[define csearch-refresh-field [new text-field% [label "csearch command"] [parent settings-panel] [init-value "./cindex ~a"] ]]
[define wiktionary-api-field [new text-field% [label "wiktionary api"] [parent settings-panel]
                                  [init-value
                                   [get-tvar-fail "wiktionary-api" [lambda [] "https://en.wiktionary.org/w/api.php?action=parse&page=~a&prop=wikitext&formatversion=2&format=json"] ]]]]

(define modules-panel (new horizontal-panel% [parent settings-panel]
                           [alignment '(center center)]))

[map [lambda [a-module-name]
       
       [printf "Initialising ~a to ~a from ~a\n" a-module-name [get-tvar-fail  a-module-name #t] vars ]
       (new check-box%	 
            [label a-module-name]	 
            [parent modules-panel]
            
            [value [get-tvar-fail a-module-name #t]]
            [callback [lambda [a-box a-event]
                        [printf "Module ~a is ~a\n" a-module-name [send a-box get-value]]
                        [set-tvar! a-module-name [send a-box get-value]]
                        ]])]
     '["wiktionary" "search" "tags"]]  ;TODO Split out csearch for fulltext search?


(define commentary-window-canvas (new editor-canvas% [parent right-panel]))
[define mydelta (make-object style-delta% )]
[send mydelta  set-family 'modern]
[send mydelta  set-face #f]

;Left editor widget class
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

;Create right editor widget
(define my-commentary-text% [class scheme:text%
                              [super-new]
                  
                              ;[define/augment after-insert [lambda [start end] [write "aaaa"][send this change-style mydelta start end]]]
                              ;[define/augment after-insert [lambda [start end] ]]
                   
                              ])


;Adds an image to an editor
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

[define [set-filename! fname]
  [set-tvar! "current-filename"  fname]
  [send editor-window set-label [get-tvar "current-filename"]]
  ]

(define image-jump-snip% [class image-snip%
                           [super-new]
                           [field [data #f]]
                          
                           [define/override on-event [lambda [dc x y ex ey event]
                                                       [super on-event  dc x y ex ey event]
                                                       [when [send event get-left-down]
                                                         [let [[target [sub1 [third data]]]]
                                                       
                                                         [displayln [format "Scrolling to ~s of ~s ~n" [second data] (send left-text-editor num-scroll-lines)]]
                                                         [set! undo-stack [cons (send left-text-editor get-flattened-text) undo-stack]]
                                                         [set! undo-pos-stack [cons (send left-text-editor get-start-position) undo-pos-stack]]
                                                         [set! undo-filename-stack [cons [get-tvar "current-filename"] undo-filename-stack]]
                                                         [printf "Saved undo point\n"]
                                                         [send left-text-editor erase]
                                                         [send left-text-editor insert [file->string [first data]]]
                                                         [set-filename! [first data]]
                                                         
                                                         [send left-text-editor scroll-to-position target]
                                                         
                                                         [send left-text-editor set-position target]
                                                         [send left-text-editor highlight-range
                                                               target
                                                               [send left-text-editor find-newline  'forward  target [+ 100 [third data]]] "light blue"]
                                                         [send [send left-text-editor get-canvas] focus]
                                                         ]
                                                       ]]]
                           [define/override on-char [lambda [dc x y ex ey event]
                                                     
                                                    
                                                      [super on-char  dc x y ex ey event]
                                                     
                                                      [displayln [format "Scrolling to ~s~n" [second data]]]
                                                      [set! undo-stack [cons (send left-text-editor get-flattened-text) undo-stack]]
                                                      [set! undo-pos-stack [cons (send left-text-editor get-start-position) undo-pos-stack]]
                                                      [printf "Saved undo point\n"]
                                                      [send left-text-editor erase]
                                                      [send left-text-editor insert [file->string [first data]]]
                                                      [set-filename! [first data]]
                                                      [send left-text-editor scroll-to-position [second data]]
                                                      [send left-text-editor set-position  [third data]]
                                                      [send [send left-text-editor get-canvas] focus]
                                                      ]]
                           ;[define/augment after-insert [lambda [start end] [write "aaaa"][send this change-style mydelta start end]]]
                           ;[define/augment after-insert [lambda [start end] ]]
                   
                           ])

(define left-text-editor (new my-editor-text%))

(define commentary-text (new text%))

[send left-text-editor auto-wrap #t]
[send commentary-text auto-wrap #t]
(send left-editor-canvas set-editor left-text-editor)
(send commentary-window-canvas set-editor commentary-text)
[send left-text-editor set-max-undo-history 50]
[send left-text-editor insert welcome-text]
(send [send left-text-editor get-canvas] force-display-focus #t) 
(send  [send commentary-text get-canvas] allow-scroll-to-last #f)
;text% is relentless in its desire to apply ANY style other than the one I want
[define force-style [lambda [a-text]
                      [send [send left-text-editor get-wordbreak-map] set-map #\- [list 'selection]]
                      [send [send left-text-editor get-wordbreak-map] set-map #\_ [list 'selection]]
                      [define slist [send left-text-editor get-style-list]]
                      [send left-text-editor set-paste-text-only #f]
                      [send slist new-named-style "J" [send slist find-or-create-style [send slist basic-style] mydelta]]
                              
                      [send left-text-editor change-style  mydelta 0 1]
                      [send left-text-editor set-styles-sticky #t]
                      ]]
[force-style left-text-editor]
[define a-keymap [send left-text-editor get-keymap]]

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





[define pop-viewport [make-pop-func [lambda [new-box word]  [letrec [[linked [assoc word defs]]]
                                                              [set! viewports-name [cons [cons new-box word]  viewports-name]]
                                                              [if linked [cdr linked] #f]]]
                                    [lambda [parent child text] [cdr [assq child viewports-name]]]]]

[define [do-csearch word] [command-output [string-concatenate `[csearch-path " " ,word " | head -" [send max-results-field get-value]]]]]



[define [shutdown-dispatcher b e] [ letrec [[snip [send  [send b get-admin] get-snip]]
                                            [t [send [send snip get-admin] get-editor]]
                                            [ed-snip [send snip get-editor]]
                                            [shutdown-func   [cdr [assq snip shutdown-funcs]]]]
                                     [shutdown-func b e]]]









[define close-viewport [make-shutdown-func [lambda [parent child text] text]]]
[define abort-viewport [make-shutdown-func [lambda [parent child text] ""]]]





[define insert-keybindings [lambda [a-text] [let [[ a-keymap [new keymap:aug-keymap%]]]
                                              
                                              [set-keybindings a-keymap]
                                              
                                              [send [send a-text get-keymap] chain-to-keymap a-keymap    #t]
                                              ;[write  [send a-keymap get-map-function-table]]
                                              
                                              ;[write [send [send a-text get-keymap] get-map-function-table]]
                                              ;[send t set-keymap a-keymap]
                                              
                                              
                                              ;[write [send [car (send a-keymap get-chained-keymaps)] ]]
                                              ]]]
;[new button% [label "Open viewport"] [parent f] [callback ]]




(define button-pane (new horizontal-panel% [parent editor-window]))
(send button-pane stretchable-height #f)
;[new button% [label "Close viewport"] [parent button-pane] [callback close-let]]

;[new button% [label "Cindex"] [parent button-pane] [callback [lambda [a b] [cindex-directory [get-directory]]]]]
[new button% [label "Settings"] [parent button-pane] [callback [lambda [a b] [show-settings]]]]
[new button% [label "Back"] [parent button-pane] [callback [lambda [a b] 
                                                             [printf "undo-pos-stack: ~a~n" undo-pos-stack]
                                                             [when [not [empty? undo-stack]]
                                                               [set! undo-forward-stack [cons (send left-text-editor get-flattened-text) undo-forward-stack]]
                                                               [set! undo-forward-pos-stack [cons (send left-text-editor get-start-position) undo-forward-pos-stack]]
                                                               [set! undo-forward-filename-stack [cons [get-tvar "current-filename"] undo-forward-filename-stack]]
                                                          

                                                               [send left-text-editor erase]
                                                               [send left-text-editor insert [first undo-stack]]
                                                               [set-filename! [first undo-filename-stack]]
                                                               [set! undo-stack [cdr undo-stack]]

                                                               [send left-text-editor set-position [first undo-pos-stack]]
                                                               [set! undo-pos-stack [cdr undo-pos-stack]]
[set! undo-filename-stack [cdr undo-filename-stack]]
                                                               ]]]]

              [define [count-chars str char pos count]
                [if [equal? [string-length str] pos]
                    count
                [count-chars str char [add1 pos] [if [char=? char [string-ref str pos]]
                                                     [add1 count]
                                                     count]]]]




[new button% [label "Forwards"] [parent button-pane] [callback [lambda [a b] 
                                                                 [printf "undo-forward-pos-stack: ~a~n" undo-forward-pos-stack]
                                                                 [when [not [empty? undo-forward-stack]]
                                                                   [set! undo-stack [cons (send left-text-editor get-flattened-text) undo-stack]]
                                                                   [set! undo-pos-stack [cons (send left-text-editor get-start-position) undo-pos-stack]]
                                                                   [set! undo-filename-stack [cons [get-tvar "current-filename"] undo-filename-stack]]

                                                                   [send left-text-editor erase]
                                                                   [send left-text-editor insert [first undo-forward-stack]]
                                                                   [set-filename! [first undo-forward-filename-stack]]
                                                                   [set! undo-forward-stack [cdr undo-forward-stack]]

                                                                   [send left-text-editor set-position [first undo-forward-pos-stack]]
                                                                   [set! undo-forward-pos-stack [cdr undo-forward-pos-stack]]
                                                                   [set! undo-forward-filename-stack [cdr undo-forward-filename-stack]]]]]]

[new button% 
[label "Open in visual code"] 
[parent button-pane] 
[callback [lambda [a b]

  [open-visual-code
    [get-tvar "current-filename" ]
    [letrec [[text [send left-text-editor get-text 0 [send left-text-editor get-start-position]]]
    [lines [count-chars text #\newline 0 0]]]
      [printf "Counted ~a lines in ~a\n" lines text]
      lines]]]]]
    

[define [cindex-directory a-dir]
  [let [[cmd [format "./cindex \"~a\"" a-dir]]]
    [displayln cmd]
    [shell-out cmd [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 

                     [send commentary-text erase]
                                                               
                                                                    
                     [send commentary-text insert [format "~a" 

                                                          [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]]]
                     ]]]]



; Ideally, we would be able to display these to the user, let them edit, then read them back
[define [set-keybindings a-keymap]
  [send a-keymap add-function "close-varedit" shutdown-dispatcher]
  
  ;;; [send a-keymap add-function "pop-varedit" pop-varedit]
  ;;; [send a-keymap add-function "pop-listvars" pop-listvars]
  ;;; [send a-keymap add-function "pop-keybindings" pop-keybindings]
  ;;; [send a-keymap add-function "pop-defs" pop-defs]
  
  ; [send a-keymap add-function "pop-csearch" pop-csearch]
  
  [send a-keymap add-function "close-viewport" close-viewport]
  [send a-keymap add-function "abort-viewport" abort-viewport]
  
  [send a-keymap add-function "pop-viewport" pop-viewport]
  ; [send a-keymap add-function "open-let" open-let1]

  ; [send a-keymap add-function "eval-selection" eval-selection]
  ; [send a-keymap add-function "open-mexpr" open-mexpr]
  
  ;[send a-keymap add-function "open-html" open-html]
  
  ; [send a-keymap add-function "system-command" system-command]
  
  [send a-keymap add-function "shutdown-dispatcher" shutdown-dispatcher]
  ;[send a-keymap add-function "pop-command-viewport" pop-command-viewport]
  [send a-keymap map-function "c:down" "shutdown-dispatcher"]
  ;[send a-keymap add-function "open-file" open-file]
  ;[send a-keymap map-function "c:," "close-let"]
  
  [map [lambda [definition]
         ;[display [format "Binding ~a to ~a~n" [first definition] [second definition]]]
         [send a-keymap map-function [first definition] [second definition]]]
       keymaps]
  ]

[insert-keybindings left-text-editor]
[insert-keybindings commentary-text]
(send editor-window show #t)
;(send commentary-window show #t)


(define last-file-name #f)
(define mb (new menu-bar% [parent editor-window]))
(define m-file (new menu% [label "File"] [parent mb]))
[begin 
  [new menu-item% [label "Open..."] [parent m-file] [callback [lambda args [load-file [path->string [get-file]]]]] [shortcut #\o]]
  ;  [new menu-item% [label "Open Scheme"] [parent m-file] [callback [lambda args [load-scheme-file [get-file]]]] [shortcut #\o]]
  ;  [new menu-item% [label "Open Perl"] [parent m-file] [callback [lambda args [load-perl-file [get-file]]]] [shortcut #\o]]
  [new menu-item% [label "Save..."] [parent m-file] [callback [lambda args [save-file last-file-name]]] [shortcut #\a]]
  [new menu-item% [label "Save As..."] [parent m-file] [callback [lambda args [save-file [put-file]]]] [shortcut #\a]]
  [new menu-item% [label "Exit"] [parent m-file] [callback [lambda args [put-preferences '[vars] [list [hash->list vars]] ][exit]]] [shortcut #\q]]
  ""]
(define m-edit (new menu% [label "Edit"] [parent mb]))
(define m-font (new menu% [label "Font"] [parent mb]))
;(append-editor-file-menu-items m-file #f)
(append-editor-operation-menu-items m-edit #f)
(append-editor-font-menu-items m-font)
;[write [send t insert-box 'text]]
;[send [send [car viewports] get-editor] insert "hello"]
;[write viewports]
; Show the frame by calling its show method


[define [slurp-file a-path]
  (port->string (open-input-file a-path) #:close? #t)
  ]

[define load-file [lambda  [a-path]
                    [send left-text-editor erase]
                           
                    [let  [[file-source [slurp-file a-path]]]
                      (set! last-file-name a-path)
                      [send left-text-editor insert file-source]]
                    [set-filename! a-path]
                    ]]

[define [process-lines f a-path]
                    
  (for ([l (in-lines (open-input-file a-path))])
    (f l)
    [displayln "---"]
    (newline))]

[define ctg [list->vector [file->lines "tags"]]]



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



[debug "Bin search: ~a\n" [binary-search-all-matches ctg "API"]]





[define csearch-path "./csearch"]
[define csearch [lambda [a-string]
                  [if  [< [string-length a-string] 4] ""
                       [shell-out [format "~a -f \\.go\\$ -n ~a | head -100" csearch-path a-string]
                                  [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
                                    [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]
                                    ]]
                       ]]]


[define [status some-text] [send editor-window set-status-text some-text]]

[define save-file [lambda [a-path]
                    [when a-path
                      [call-with-atomic-output-file
                       a-path
                       [lambda [a-port another-path]
                         [display [send left-text-editor get-text 0 9999999] a-port]]]]]]

[define [find-ctag name ctags] [filter [lambda [x] [equal? name [car x]]] ctags]]
[define [load-ctags-file a-path] [map [lambda [x] [string-split  x #px"\t+|\\s+" ]] [file->lines a-path] ]]


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

[define [binsearch-ctags-file a-term]
  [debug "Binearching for ~a\n" a-term]
  [if [eq? a-term ""] '()
      [map [lambda [x] [string-split  x #px"\t+|\\s+" ]] [vector->list [binary-search-all-matches ctg a-term] ]]]]

[define [take-at-most a-list a-number]
  [if [<= a-number 0]
      '()
      [if [null? a-list]
          '()
          [cons (car a-list) [take-at-most (cdr a-list) (sub1 a-number)]]
          ]]]

[define [format-ctags-results results]
  [debug "Formatting ctags results: ~a" results]
  [map [lambda [tag-data]
         [letrec [
                  [tag [first tag-data]]
                  [filename [second  tag-data ]]
                  [line-number [sub1 [false-to-zero [string->number [break-line-field [third  tag-data ]]]]]]
                  ]
           [list tag filename line-number]
           ]]
       [take-at-most results [get-max-results] ]]
        
        
  ]

;/Users/jeremyprice/racketProgs/the-helpful-editor/editor.scm:439:[define pop-keybindings  [make-pop-func [lambda [a-box word] [write "popping keybindings"]
[define [format-csearch-results tag results]
  [debug [format "Formatting csearch results ~a~n" results]]
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
      [if [equal? text ""]
          0
          [let [[letter [string-ref text current-pos]]]
        [if [equal? #\newline letter]
            [line->position text target-line [add1 linecount] [add1 current-pos]]
            [line->position text target-line linecount [add1 current-pos]]]
        ]]
      ]
  ]

[define [render-filename word commentary editor]
  [send commentary insert [get-tvar "current-filename"]]
  

  ]
  
[define [render-search word commentary editor direction]
  [if [equal? word ""]
      ""
      [begin
  [debug "Searching ~a for ~a\n" direction word]
  [let [[snp [make-object image-callback-snip% [if [eq? direction 'forward]
                                                   "graphics/jump-16.png"
                                                   "graphics/left-16.png" ]]]]
    ;[set-field! data snp [list [second  tag-data ]   char-position]]
    [let [[next [send editor find-string word direction [if [eq? direction 'forward]
                                                            [add1 [send editor get-start-position]]
                                                            [sub1 [send editor get-start-position]]]]]]
      [if next 
          [begin 
            [set-field! callback snp [lambda [dc x y ex ey event]
                               
                                       [begin [displayln [format "Skipping to ~a" next]]
                                              [send editor scroll-to-position next]
                                              [send editor set-position next]]
                                 
                                       ]
                        ]
                                 
                                 
            [send snp set-flags '[ handles-events ]]
            [send commentary insert snp]
            [send commentary insert [format "Skip ~a to next '~a'" direction word ]]
            ]
          [debug "No more matches\n"]
          ]]
                     
    ]]]]


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
                         [format-ctags-results  [binsearch-ctags-file word]]]]]
    [if [empty? tag-list]
        [format "No results found for ~a" word]
        [begin
          [map [lambda [tag-data]
                 [letrec [
                          [text [file->string [second  tag-data ]]]
                          [line-number [third  tag-data ]]
                          [ sample [format "~a" [extract-line text line-number]]]
                          [char-position [line->position text [- line-number 5] 0 0]]
                          [real-position [max 0 [add1 [line->position text [sub1 line-number] 0 0]]]]
                          ]
                   ;[displayln [format "line-number: ~a" line-number]]
                   
                   [let [[snp [make-object image-jump-snip% "graphics/jump-16.png" ]]]
                     [set-field! data snp [list [second  tag-data ]   char-position real-position]] 
                     [send snp set-flags '[ handles-events ]]
                     [send commentary insert snp]
                     [send commentary insert [string-trim-both sample]]
                                                                       
                     ;[send editor insert     [make-object string-snip% "Load"  ]]
                     [send commentary insert "\n"]
                     [send commentary insert 
                           [format "~a"  
                                   [list
                                    [car [reverse [string-split  [second  tag-data ]  "/" ]]]
                                    line-number
                                    [second  tag-data ]]]]
                     [send commentary insert "\n\n"]
                     sample
                     ]]
                 ] tag-list]
          ""
          ]
        ]
    ]
  ]


[define [show-settings]
  [begin
    [when [not [get-tvar "settings-panel-active"]]
      [send [send settings-panel get-parent] add-child settings-panel]
      [send settings-panel enable #t]
      [send settings-panel show #t]
      [set-tvar! "settings-panel-active" #t]]]
  ]

[define [hide-settings]
  [begin
    [when  [get-tvar "settings-panel-active"]
      [send settings-panel enable #f]
      [send settings-panel show #f]
      [send [send settings-panel get-parent] delete-child settings-panel]
      [set-tvar! "settings-panel-active" #f]]
    [set-tvar! "source-dirs" [send source-dirs-text get-text]]
    [set-tvar! "wiktionary-api" [send wiktionary-api-field get-value]]

    ]
  ]

[define [render-search-term word commentary editor]
  [send commentary insert [format "Searching for ->~a<-\n\n" word]]
  ]


[define [comment-callback editor commentary type event word]

  [if [and  [find [lambda [x] [equal? word x]] '["setting" "settings" "config" "configuration" "prefs" "preferences" "options"]]]
      [show-settings]
      [hide-settings]]

  (send editor begin-edit-sequence	 #f #f)
  [send right-panel show #f]
  [send right-panel enable #f]
  (call-with-exception-handler [lambda [x] x] [lambda [] 
  ;[render-settings word commentary editor]
  ;[display [format "->~a<-" csearch-list]]
  ;[display commentary]
                                                [render-search-term word commentary editor]
  [render-filename word commentary editor]
  [send commentary insert "\n\n"]
  [when [get-tvar "search"]
     [render-search word commentary editor 'backward]
    [render-search word commentary editor 'forward]
    [send commentary insert "\n\n"]]
  [when [get-tvar "wiktionary"]
    [send commentary insert "--- wiktionary ---\n\n"]
    [render-wiktionary word commentary editor]]
  [when [get-tvar "tags"]
    [send commentary insert "--- ctags / csearch ---\n\n"]
    [render-jump-to-file word commentary editor]]
  [send commentary set-position 0]])
  [send commentary scroll-to-position 0]
  [send right-panel show #t]
  [send right-panel enable #t]
  (send editor end-edit-sequence)
  ""
  ]

[define [open-visual-code filename linenumber]
[system* "/Applications/Visual Studio Code.app/Contents/MacOS/Electron" [format "~a:~a" filename [add1 linenumber]]  "--goto"]
  ]



