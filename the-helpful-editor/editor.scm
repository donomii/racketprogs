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
         mzlib/defmacro)
;(require (planet "htmlprag.ss" ("neil" "htmlprag.plt" 1 3)))
[define vars [make-hash [get-preference 'vars [lambda [] [list]]]]]

;[define vars [make-hash]]
[defmacro indent-dedent args `[begin [indent] [let [[temp ,[car args]]] [dedent] temp]]]
[defmacro dox args [cadr args]]
[defmacro myset args `[set! ,[car args] ,[cdr args]]]
(application:current-app-name "Helpful Editor")

[define [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
  [close-input-port stderr-pipe]
  [close-output-port stdin-pipe]
  ;[control-proc 'wait]
  [read-string 99999 stdout-pipe]
  ;[close-input-port stdout-pipe]
  ]
[define [handler-load-perl-file stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
  [display "C:\\Documents and Settings\\user\\My Documents\\My Dropbox\\git\\entirety\\source\\bin\\nmea.pl" stdin-pipe]
  [newline stdin-pipe]
  [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]
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
    ]
  ]


[define defs '[["word" . 
                       "The Helpful Editor will open a text portal when you press Control + Up.  Exactly 
what appears in the portal depends on context.  Here it is just text, but it can 
also be a code definition or the results of a function.  Portals can also nest:

> Nesting <

(Control + Up on 'Nesting')"]
               ["Nesting" . "Portals can nest as deeply as you like.  To close a portal, press Control + Down"]
               
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

[define command-output [lambda [a-command] [letrec [[pipes [process a-command]]
                                                    [stdout [car pipes]]]
                                             [read-string 99999 stdout]]]]
[define get-word [lambda [a-text]  [letrec [[startbox [box [send a-text get-start-position]]] 
                                            [endbox [box [send a-text get-start-position]]]  
                                            [start (send a-text find-wordbreak startbox #f 'selection)]
                                            [end (send a-text find-wordbreak #f endbox  'selection)]]
                                     [send a-text get-text [unbox startbox] [unbox endbox]]]]]
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
(define f [dox "Make new frame" (new my-frame% [label (application:current-app-name)]
                                     [width 800]
                                     [height 600])])
[send f create-status-line]
(define c (new editor-canvas% [parent f]))
[define mydelta (make-object style-delta% )]
[send mydelta  set-family 'modern]
[send mydelta  set-face #f]

(define my-text% [class scheme:text%
                   [super-new]
                   ;[define/augment after-insert [lambda [start end] [write "aaaa"][send this change-style mydelta start end]]]
                   ;[define/augment after-insert [lambda [start end] ]]
                   
                   ])

(define t (new my-text%))
(send c set-editor t)
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
[define ensure-list [lambda [e] [if [list? e] e [list e]]]]
[define indent-level 0]
[define [indent] [set! indent-level [+ 4 indent-level]]]
[define [dedent] [set! indent-level [- indent-level 4]]]
[define [spaces] [make-string indent-level #\ ]]
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
[define statements->mexpr [lambda [statements]
                            [string-join [map [lambda [s] [string-append [spaces] [sexpr->mexpr s ";"  "\n"]]] [ensure-list statements]]]]]

[define search-text-for-snip-recur [lambda [atext asnip pos] [let [[testsnip [send atext get-text pos [add1 pos]]]]
                                                               [display "Comparing "]
                                                               [write asnip]
                                                               [write testsnip]
                                                               [newline]
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
[define [make-pop-func f close-f] [lambda [t e]
                                    [letrec [[untrimmed-word [get-word t]]
                                             [word [regexp-replace* "\\[|\\]|\\(|\\)" untrimmed-word ""]]
                                             ]
                                      [display [format "Found word: ~a~n" word]]
                                      
                                      [begin 
                                        [let [[new-box [new editor-snip%]]
                                              [new-text [new my-text%]]]
                                          
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
                                                     [display [format "Found word: ~a~n" word]]
                                      
                                                     [begin 
                                                       [let [[new-box [new editor-snip%]]
                                                             [new-text [new my-text%]]]
                                          
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

[define pop-varedit  [make-pop-func [lambda [a-box word] [write "popping varedit"]
                                      ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                      [pretty-format [hash-ref vars word [lambda [] "unknown"]]]]
                                    
                                    [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
                                                                                 [the-set! [format "(set! ~a [quote ~a])" var-name the-text]]]
                                                                          [display [format "Evalling ~a~n" the-set!]]
                                                                          ;[eval-string the-set!]
                                                                          
                                                                          [hash-set! vars var-name [read [open-input-string the-text]]]
                                                                          ""]]]]
[define pop-listvars  [make-pop-func [lambda [a-box word] [write "popping listvars"]
                                       ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                       [pretty-format [hash-keys vars ]]
                                       ]
                                    
                                     [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
                                                                                  [the-set! [format "(set! ~a [quote ~a])" var-name the-text]]]
                                                                           [display [format "Evalling ~a~n" the-set!]]
                                                                           ;[eval-string the-set!]
                                                                          
                                                                           [hash-set! vars var-name [read [open-input-string the-text]]]
                                                                           ""]]]]

[define pop-keybindings  [make-pop-func [lambda [a-box word] [write "popping keybindings"]
                                          ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                          [format "`~a" [pretty-format keymaps]]
                                          ]
                                    
                                        [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
                                                                                     ]
                                                                              [display [format "closing ~a~n" var-name]]
                                                                              ;[eval-string the-set!]
                                                                          

                                                                              [set! keymaps [eval-string the-text]]
                                                                              [map [lambda [definition]
                                                                                     [display [format "Binding ~a to ~a~n" [first definition] [second definition]]]
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
                                                                       [display [format "closing ~a~n" var-name]]
                                                                       ;[eval-string the-set!]
                                                                          

                                                                       [set! defs [eval-string the-text]]
                                                                          
                                                                       ""]]]]
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
                                           [display text]
                                           [printf "Found word '~s' at ~a" word position]
                                           [send editor set-position [+ 200 position]]
                                           [send editor set-position position]
                                           ]
      
                                         ]
                                    
                                       [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]]
                                                                             [display [format "closing ~a~n" var-name]]
                                                                             ;[eval-string the-set!]
                                                                          

                                                                             var-name]]]]

[define [shutdown-dispatcher b e] [ letrec [[snip [send  [send b get-admin] get-snip]]
                                            [t [send [send snip get-admin] get-editor]]
                                            [ed-snip [send snip get-editor]]
                                            [shutdown-func   [cdr [assq snip shutdown-funcs]]]]
                                     [shutdown-func b e]]]

[define strip-brackets [lambda [a-list pad-length]
                         [string-join 
                          [map
                           [lambda [f]
                             [format "~a = ~a ~n"  [string-pad-right [format "~a" [car f]] pad-length] [sexpr->mexpr [cadr f] "" ""]]]
                           a-list]
                          ""]
                         ]]
[define def-names [lambda [a-list]
                    [map car a-list]]]

[define [make-open-selection f close-f] [lambda [t e] 
                                          [letrec [[some-text [send t get-text [send t get-start-position] [send t get-end-position]]]
                                                   
                                                   [new-box [send t on-new-box 'text]]
                                                   ]
                                            
                                            
                                            [send new-box set-editor [new my-text%]]
                                            [force-fucking-style [send new-box get-editor]]
                                            [send t insert new-box]
                                            [set! viewports-name [cons [cons new-box some-text]  viewports-name]]
                                            
                                            
                                            [send [send new-box get-editor] insert   [regexp-replace* "\r" [format "~a" [f t new-box some-text]] ""]]
                                            [send [send new-box get-editor] set-caret-owner #f 'global]
                                            ;[send [send new-box get-editor] tabify-all]
                                            [insert-keybindings [send new-box get-editor]]
                                            
                                            [add-shutdown-func new-box close-f]]]]
[define close-viewport [make-shutdown-func [lambda [parent child text] text]]]

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
                                           [display defs-maxlength]
                                           
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

[define open-mexpr [make-open-selection [lambda [parent child text] [statements->mexpr  [read [open-input-string text]]]] 
                                        [lambda [parent child text] text]]]
;[define open-html [make-open-selection [lambda [parent child text] [pretty-format [html->shtml   text]]]
;                                         [lambda [parent child text] [display "converting to html..."] [shtml->html text][shtml->html [read [open-input-string text]]]]]]
[define system-command [make-open-selection [lambda [parent child some-text] [command-output some-text]]
                                            [lambda [parent child text] text]]]

[define eval-selection [make-open-selection [lambda [parent child some-text] [eval-string some-text]]
                                            [lambda [parent child text] text]]]



[new button% [label "Close viewport"] [parent f] [callback close-let]]


; Ideally, we would be able to display these to the user, let them edit, then read them back
[define [set-keybindings a-keymap]
  [send a-keymap add-function "close-varedit" shutdown-dispatcher]
  
  [send a-keymap add-function "pop-varedit" pop-varedit]
  
  [send a-keymap add-function "pop-listvars" pop-listvars]
  [send a-keymap add-function "pop-keybindings" pop-keybindings]
  [send a-keymap add-function "pop-defs" pop-defs]
  [send a-keymap add-function "pop-ctag" pop-ctag]
  
  [send a-keymap add-function "close-viewport" close-viewport]
  [send a-keymap add-function "pop-viewport" pop-viewport]
  [send a-keymap add-function "open-let" open-let1]

  [send a-keymap add-function "eval-selection" eval-selection]
  [send a-keymap add-function "open-mexpr" open-mexpr]
  
  ;[send a-keymap add-function "open-html" open-html]
  
  [send a-keymap add-function "system-command" system-command]
  
  [send a-keymap add-function "shutdown-dispatcher" shutdown-dispatcher]
  [send a-keymap map-function "c:down" "shutdown-dispatcher"]
  ;[send a-keymap map-function "c:," "close-let"]
  
  [map [lambda [definition]
         [display [format "Binding ~a to ~a~n" [first definition] [second definition]]]
         [send a-keymap map-function [first definition] [second definition]]]
       keymaps]
  ]

[insert-keybindings t]
(send f show #t)



(define last-file-name #f)
(define mb (new menu-bar% [parent f]))
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
                                                            [send t insert file-source]
                             
                                                            [get-defs   [call-with-input-file a-path [lambda [in] [read-syntax #f in]] #:mode 'text] file-source]
                                                            ]]
                                                        input-files] ]]
[define load-file [lambda  [a-path]
                    [send t erase]
                           
                    [let  [[file-source [call-with-input-file a-path [lambda [in] [read-string 999999 in]] #:mode 'text]]]
                      (set! last-file-name a-path)
                      [send t insert file-source]]
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
                                                                             [send f set-status-text [format "Loading ~a" a-path]]
                                                                             [display a-path stdin-pipe]
                                                                             [newline stdin-pipe]
                                                                             [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]
                                                                             ]]]]
                     input-files]]]
[define [status some-text] [send f set-status-text some-text]]
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
[define [load-ctags-file a-path] [map [lambda [x] [string-split  x "\t"]] [file->lines a-path] ]]

