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
[define verbose #f]
[define debug [lambda args [if verbose [displayln [apply format args]] #f]]]
[define csearch-path "./csearch"]


[define vars [make-hash [get-preference 'vars [lambda [] [list]]]]]


[debug "Loaded prefs: ~a\n" vars]

;The undo/redo stacks
[define undo-stack '()]
[define undo-pos-stack '()]
[define undo-filename-stack '()]

[define undo-forward-stack '()]
[define undo-forward-pos-stack '()]
[define undo-forward-filename-stack '()]


[defmacro dox args [cadr args]]
[defmacro myset args `[set! ,[car args] ,[cdr args]]]


;Start the application framework
(application:current-app-name "Commentary")







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
                    [debug "Saving tvars ~a\n" vars]
                    [put-preferences '[vars] [list [hash->list vars]] ]
                    ]]
[unless [get-tvar "welcome-text"] [set-tvar! "welcome-text" welcome-text]]
[unless [get-tvar "current-filename"] [set-tvar! "current-filename" "no file"]]



;Is there a user-highlighted section in a-text?
[define [highlight-active? a-text]
  [letrec [
           [highlight-start [send a-text get-start-position]]
           [hightlight-end [send a-text get-end-position]]]
    [not [eq? highlight-start hightlight-end]]]]


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

;The actual window
(define editor-window [dox "Make new frame" (new my-frame% [label (application:current-app-name)]
                                                 [width 800]
                                                 [height 600])])


;Add status line
[send editor-window create-status-line]

;Create an invisible horizontal layout box
(define hpane (new horizontal-pane% [parent editor-window]))

;Left editor display canvas
(define left-editor-canvas (new editor-canvas% [parent hpane]))

;Create an invisible vertical layout box
[define right-panel (new vertical-panel%	 
                         [parent hpane]		 
                         [enabled #t])]

[define settings-panel (new vertical-panel%	 
                            [parent right-panel]		 
                            [enabled #t])]

;Display settings pane?
[set-tvar! "settings-panel-active" #t]

;Setup default settings
[define source-dirs-text [new text%]]
[send source-dirs-text insert [get-tvar-fail "source-dirs" [lambda [] "./\n"]]]
[define source-dirs-canvas [new editor-canvas% [parent settings-panel] [line-count 3]]]              
(send source-dirs-canvas set-editor source-dirs-text)

[define [get-source-dirs]
  [string-split  [send source-dirs-text get-text 0 'eof #t #f] "\n"]]

(define source-buttons-panel (new horizontal-panel% [parent settings-panel]
                                  [alignment '(center center)]))
 
[new button% [label "Add source"] [parent source-buttons-panel]
     [callback [lambda [a b] [send source-dirs-text insert [string-append  [aif [get-directory] [path->string it] "./\n"] "\n"]]]]]

[new button% [label "Refresh"] [parent source-buttons-panel]
     [callback [lambda [a b]
                 [debug "Gotags command: ~a\n" [append (list "./gotags" "-R" "-f" "tags") [string-split [send source-dirs-text get-text] "\n"]]]
                 [debug "~a\n" (apply system* [append (list "./gotags" "-R" "-f" "tags") [string-split [send source-dirs-text get-text] "\n"]])]
                 [map  [lambda [x] [cindex-directory x] ]  [string-split [send source-dirs-text get-text] "\n"]]
                 ]]]

[define max-results-field [new text-field% [label "Max Results"] [parent settings-panel] [init-value [get-tvar-fail "max-results" [lambda [] "50"]]] ]]
[define [get-max-results] [string->number [send max-results-field get-value]]]
[define wiktionary-api-field [new text-field% [label "wiktionary api"] [parent settings-panel]
                                  [init-value
                                   [get-tvar-fail "wiktionary-api" [lambda [] "https://en.wiktionary.org/w/api.php?action=parse&page=~a&prop=wikitext&formatversion=2&format=json"] ]]]]

;Checkboxes to swtich on/off modules
(define modules-panel (new horizontal-panel% [parent settings-panel]
                           [alignment '(center center)]))

;The modules that can appear on the right commentary panel
[define modules '["wiktionary" "search" "tags"]]
[map [lambda [a-module-name]
       [debug "Initialising ~a to ~a from ~a\n" a-module-name [get-tvar-fail  a-module-name #t] vars ]
       (new check-box%	 
            [label a-module-name]	 
            [parent modules-panel]
            
            [value [get-tvar-fail a-module-name #t]]
            [callback [lambda [a-box a-event]
                        [printf "Module ~a is ~a\n" a-module-name [send a-box get-value]]
                        [set-tvar! a-module-name [send a-box get-value]]
                        ]])]
     modules]  ;TODO Split out csearch for fulltext search?


;Create the display canvas
(define commentary-window-canvas (new editor-canvas% [parent right-panel]))

;Text style
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
                          ])

;Create right editor widget
(define my-commentary-text% [class scheme:text%  [super-new]])


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
                               ])

;Updates the current filename for the editor window
[define [set-filename! fname]
  [set-tvar! "current-filename"  fname]
  [send editor-window set-label [get-tvar "current-filename"]]]

;An image class that jumps the editor window to a new file when clicked.  Can be created with the filename and line number.
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
                                                         
                                                           [send left-text-editor scroll-to-position [second data]]
                                                         
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
                           ])

;Create an assign the editors
(define left-text-editor (new my-editor-text%))
(define commentary-text (new text%))

;Configure them
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







[define search-text-for-snip-recur [lambda [atext asnip pos] [let [[testsnip [send atext get-text pos [add1 pos]]]]
                                                               ;[display "Comparing "]
                                                               ;[write asnip]
                                                               ;[write testsnip]
                                                               ;[newline]
                                                               [if [eq? testsnip asnip]
                                                                   pos
                                                                   [search-text-for-snip-recur atext asnip [add1 pos]]]]]]
[define search-text-for-snip [lambda [atext asnip] [search-text-for-snip-recur atext asnip 0] ]]




[define [do-csearch word] [command-output [string-concatenate `[csearch-path " " ,word " | head -" [send max-results-field get-value]]]]]

(define button-pane (new horizontal-panel% [parent editor-window]))
(send button-pane stretchable-height #f)

;The bottom row of buttons
[new button% [label "Settings"] [parent button-pane] [callback [lambda [a b]
                                                                 [if [get-tvar "settings-panel-active"]
[hide-settings]
                                                                     [show-settings]]]]]
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
    

;Update google codesearch
[define [cindex-directory a-dir]
  [let [[cmd [format "./cindex \"~a\"" a-dir]]]
    [displayln cmd]
    [shell-out cmd [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 

                     [send commentary-text erase]
                                                               
                                                                    
                     [send commentary-text insert [format "~a" 

                                                          [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]]]
                     ]]]]




(send editor-window show #t)

;Setup the menu
(define last-file-name #f)
(define mb (new menu-bar% [parent editor-window]))
(define m-file (new menu% [label "File"] [parent mb]))
[begin 
  [new menu-item% [label "Open..."] [parent m-file] [callback [lambda args [load-file [path->string [get-file]]]]] [shortcut #\o]]
  [new menu-item% [label "Save..."] [parent m-file] [callback [lambda args [save-file last-file-name]]] [shortcut #\a]]
  [new menu-item% [label "Save As..."] [parent m-file] [callback [lambda args [save-file [put-file]]]] [shortcut #\a]]
  [new menu-item% [label "Exit"] [parent m-file] [callback [lambda args [put-preferences '[vars] [list [hash->list vars]] ][exit]]] [shortcut #\q]]
  ""]
(define m-edit (new menu% [label "Edit"] [parent mb]))
(define m-font (new menu% [label "Font"] [parent mb]))
(append-editor-operation-menu-items m-edit #f)
(append-editor-font-menu-items m-font)


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
       [take-at-most results [get-max-results] ]]]

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
           [string-split results "\n"]]]]




[define [render-filename word commentary editor]
  [send commentary insert [get-tvar "current-filename"]]]
  
[define [render-search word commentary editor direction]
  [if [equal? word ""]
      ""
      [begin
        [debug "Searching ~a for ~a\n" direction word]
        [let [[snp [make-object image-callback-snip% [if [eq? direction 'forward]
                                                         "graphics/jump-16.png"
                                                         "graphics/left-16.png" ]]]]
          [let [[next [send editor find-string word direction [if [eq? direction 'forward]
                                                                  [add1 [send editor get-start-position]]
                                                                  [sub1 [send editor get-start-position]]]]]]
            [if next 
                [begin 
                  [set-field! callback snp [lambda [dc x y ex ey event]
                                             [begin [displayln [format "Skipping to ~a" next]]
                                                    [send editor scroll-to-position next]
                                                    [send editor set-position next]]]]
                                 
                                 
                  [send snp set-flags '[ handles-events ]]
                  [send commentary insert snp]
                  [send commentary insert [format "Skip ~a to next '~a'" direction word ]]
                  ]
                [debug "No more matches\n"]
                ]]
                     
          ]]]]


;Display the wiktionary results in the commentary pane
[define [render-wiktionary word commentary editor ]
  [letrec [[search-results [http-get [format "https://en.wiktionary.org/w/api.php?action=parse&page=~a&prop=wikitext&formatversion=2&format=json" word]]]
           [json-results [bytes->jsexpr [http-response-body search-results] ]]
           ;[urls [fourth json-results]]
           [wikitext  [sf 'parse/wikitext json-results ""]]
           [sections [string-split wikitext [format "\n=="]]]
           [wanted [filter [lambda [str] [regexp-match "Noun|Verb|Adjective|Adverb" str]] sections]]
           [text [string-join wanted [format "\n"]]]
           ]  
    [send commentary insert text]]]
  

;Display file jump targets  (FIXME make generic)
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


;Show and enable the settings panel
[define [show-settings]
  [begin
    [when [not [get-tvar "settings-panel-active"]]
      [send [send settings-panel get-parent] add-child settings-panel]
      [send settings-panel enable #t]
      [send settings-panel show #t]
      [set-tvar! "settings-panel-active" #t]]]
  ]

;Hide and disable the settings panel
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
  [send commentary insert [format "Searching for ->~a<-\n\n" word]]]

[define [render-search-finish word commentary editor]
  [send commentary insert [format "Search complete for ->~a<-\n\n" word]]]

[define load-file [lambda  [a-path]
                    [send left-text-editor erase]
                           
                    [let  [[file-source [slurp-file a-path]]]
                      (set! last-file-name a-path)
                      [send left-text-editor insert file-source]]
                    [set-filename! a-path]
                    ]]

[define [comment-callback editor commentary type event word]
  ;pop settings panel if someone types settings, etc
  [if [and  [find [lambda [x] [equal? word x]] '["setting" "settings" "config" "configuration" "prefs" "preferences" "options"]]]
      [show-settings]
      [hide-settings]]

  ;hide editor display to speed up rendering
  (send editor begin-edit-sequence	 #f #f)
  [send right-panel show #f]
  [send right-panel enable #f]

  ;render it
  (call-with-exception-handler [lambda [x] x] [lambda [] 
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
                                                render-search-finish
                                                [send commentary set-position 0]])

  ;show editor display
  [send commentary scroll-to-position 0]
  [send right-panel show #t]
  [send right-panel enable #t]
  (send editor end-edit-sequence)
  ""
  ]



