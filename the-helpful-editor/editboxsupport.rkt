(module editboxsupport racket
[require srfi/13  "support.rkt"  mred framework]
   (provide )
[define viewport-data '[]]
;  [define add-viewport [the-viewport name ]]
[define viewports '[]]
[define viewports-start-len '[]]
[define viewports-name '[]]
[define shutdown-funcs '[]]

  ; Create a sequence of unique numbers
[define num 0]
[define seqnum [lambda [] [set! num [add1 num]][format "~a" num]]]

  ;
;[insert-keybindings left-text-editor]
;[insert-keybindings commentary-text]
  
;[define a-keymap [send left-text-editor get-keymap]]

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

  [define rebuild-let [lambda [defs-list code]
                      [let [[str-port [open-output-string]]]
                        [display [format "(let ("] str-port]
                        [map [lambda [a-def] [when [> [length a-def] 1] [display [format "(~a ~a)\n" [car a-def] [cadr a-def]] str-port]]] defs-list]
                        [display [format ")\n~a)" code] str-port]
                        [get-output-string str-port]
                        ]]]

  [define insert-keybindings [lambda [a-text] [let [[ a-keymap [new keymap:aug-keymap%]]]
                                              
                                              [set-keybindings a-keymap]
                                              
                                              [send [send a-text get-keymap] chain-to-keymap a-keymap    #t]
                                              ;[write  [send a-keymap get-map-function-table]]
                                              
                                              ;[write [send [send a-text get-keymap] get-map-function-table]]
                                              ;[send t set-keymap a-keymap]
                                              
                                              
                                              ;[write [send [car (send a-keymap get-chained-keymaps)] ]]
                                              ]]]

  

  [define [add-shutdown-func an-editor l] [set! shutdown-funcs [cons [cons an-editor
                                                                         [make-shutdown-func l]]  shutdown-funcs]]]
;[send t set-clickback 0 3 [lambda [atext x y] [display "CLicky!"][newline]]]


[define [shutdown-dispatcher b e] [ letrec [[snip [send  [send b get-admin] get-snip]]
                                            [t [send [send snip get-admin] get-editor]]
                                            [ed-snip [send snip get-editor]]
                                            [shutdown-func   [cdr [assq snip shutdown-funcs]]]]
                                     [shutdown-func b e]]]









  
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

  
[define close-viewport [make-shutdown-func [lambda [parent child text] text]]]
[define abort-viewport [make-shutdown-func [lambda [parent child text] ""]]]



; The first function prepares to open the box.  The return value is placed in the box
; The second function closes the box
[define [make-pop-func f close-f] [lambda [t e editor-class%]
                                    [letrec [[untrimmed-word [get-word t]]
                                             [word [regexp-replace* "\\[|\\]|\\(|\\)" untrimmed-word ""]]
                                             ]
                                      ;[display [format "Found word: ~a~n" word]]
                                      
                                      [begin 
                                        [let [[new-box [new editor-snip% [left-margin 20][max-width 40] [max-height 40]]]
                                              [new-text [new editor-class%]]]
                                          
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


[define defs '[["word" . 
                       "The Helpful Editor will open a text portal when you press Control + Up.  Exactly 
what appears in the portal depends on context.  Here it is just text, but it can 
also be a code definition or the results of a function.  Portals can also nest:

> Nesting <

(Control + Up on 'Nesting')"]
               ["Nesting" . "Portals can nest as deeply as you like.  To close a portal, press Control + Down"]
               ; FIXME add actions like ["keybindings" . ,[lambda [x] [pop-keybindings]]]
               ]]


[define pop-viewport [make-pop-func [lambda [new-box word]  [letrec [[linked [assoc word defs]]]
                                                              [set! viewports-name [cons [cons new-box word]  viewports-name]]
                                                              [if linked [cdr linked] #f]]]
                                    [lambda [parent child text] [cdr [assq child viewports-name]]]]]
  
  ;Return longest string from a list
  [define longest-string [lambda [a-list] 
                         [let [[longest 0]]
                           [map [lambda [s] [when [> [string-length s] longest]
                                              [set! longest [string-length s]]]] 
                                a-list]
                           longest]]]
  


  [define def-names [lambda [a-list]
                    [map car a-list]]]
  
;  [define open-let1 [make-open-selection [lambda [parent child some-text]
;                                         
;                                         [letrec [[a-list [read [open-input-string some-text]]]
;                                                  [defs [cadr a-list]]
;                                                  [code [cddr a-list]]
;                                                  [temp-str ""]
;                                                  
;                                                  [defs-maxlength [longest-string [map symbol->string [def-names defs]]]]]
;                                           ;[display defs-maxlength]
;                                           
;                                           [string-append  
;                                            [strip-brackets  defs defs-maxlength]
;                                            "\n---\n\n"
;                                            [statements->mexpr code]
;                                            ]]] close-let] ]


[define mydelta (make-object style-delta% )]
                          ;text% is relentless in its desire to apply ANY style other than the one I want
[define force-style [lambda [t a-text]
                              [send [send t get-wordbreak-map] set-map #\- [list 'selection]]
                              [send [send t get-wordbreak-map] set-map #\_ [list 'selection]]
                              [define slist [send t get-style-list]]
                              [send t set-paste-text-only #f]
                              [send slist new-named-style "J" [send slist find-or-create-style [send slist basic-style] mydelta]]
                              
                              [send t change-style  mydelta 0 1]
                              [send t set-styles-sticky #t]
                              ]]

  [define [make-open-selection f close-f] [lambda [t e] 
                                          [letrec [[some-text [send t get-text [send t get-start-position] [send t get-end-position]]]
                                                   
                                                   [new-box [send t on-new-box 'text]]
                                                   ]
                                            
                                            
                                            [send new-box set-editor [new scheme:text%]]
                                            [force-style [send new-box get-editor]]
                                            [send t insert new-box]
                                           
                                            
                                            
                                            [send [send new-box get-editor] insert   [regexp-replace* "\r" [format "~a" [f t new-box some-text]] ""]]
                                            [send [send new-box get-editor] set-caret-owner #f 'global]
                                            ;[send [send new-box get-editor] tabify-all]
                                            ;FIXME
                                            ;[insert-keybindings [send new-box get-editor]]

                                            ;FIXME
                                            ;[add-shutdown-func new-box close-f]

                                            ]]]
;
;  [define open-mexpr [make-open-selection [lambda [parent child text] [statements->mexpr  [read [open-input-string text]]]] 
;                                        [lambda [parent child text] text]]]

  [define system-command [make-open-selection [lambda [parent child some-text] [command-output some-text]]
                                            [lambda [parent child text] text]]]

[define eval-selection [make-open-selection [lambda [parent child some-text] [eval-string some-text]]
                                            [lambda [parent child text] text]]]
;
;  [define open-file [make-open-selection
;                   [lambda [parent child some-text] 
;                     [letrec [[a-text  [file->string some-text]]]
;                       a-text]] close-let] ]
  
;[define open-html [make-open-selection [lambda [parent child text] [pretty-format [html->shtml   text]]]
;                                         [lambda [parent child text] [display "converting to html..."] [shtml->html text][shtml->html [read [open-input-string text]]]]]]

;Three functions.  The first loads the text for the snip, the second is called after loading, and the third is called on shutdown
[define [make-extra-pop-func f middle-f close-f] [lambda [t e]
                                                   [letrec [[untrimmed-word [get-word t]]
                                                            [word [regexp-replace* "\\[|\\]|\\(|\\)" untrimmed-word ""]]
                                                            ]
                                                     ;[display [format "Found word: ~a~n" word]]
                                      
                                                     [begin 
                                                       [let [[new-box [new editor-snip% [max-width 600] [max-height 300]]]
                                                             [new-text [new scheme:text%]]]
                                          
                                                         [let [[replacement-text [f new-box word]]]
                                                           [when replacement-text
                                                             [zap-word t]
                                              
                                              
                                                             ;[let [[new-box [send t on-new-box 'text]]]
                                                             [send new-box set-editor new-text]
                                                             [send t insert new-box]
                                                             ;[set! viewports-name [cons [cons new-box word]  viewports-name]]
                                              
                                              
                                                             [send [send new-box get-editor] insert  [regexp-replace* "\r" replacement-text ""]]
                                                             [send [send new-box get-editor] set-caret-owner #f 'global]
                                                            ; [insert-keybindings [send new-box get-editor]]
                                                             [middle-f new-box word]
                                              
                                              
                                                             ;[add-shutdown-func new-box close-f]
                                                             ]
                                                           ;shutdown-funcs
                                                           ]
                                                           ]]]]]
  [define pop-csearch  [make-extra-pop-func [lambda [a-box word] [write "popping csearch"]
                                            ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
                                            ;[do-csearch word]
                                         
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
                                    
                                          [lambda [parent a-textbox the-text] [letrec [[var-name [cdr ;[assq a-textbox viewports-name]
                                                                                                      ]]]
                                                                                [display [format "closing ~a~n" var-name]]
                                                                                ;[eval-string the-set!]
                                                                          

                                                                                var-name]]]]
;[define load-scheme-file [lambda  [a-path editor]
;                           [send editor erase]
;                           [read-accept-reader #t]
;                           ;[set! defs [get-multi-defs [cons a-path [hash-ref vars "project-files" [lambda [] '[]]]]]]
;                           [let  [[file-source [call-with-input-file a-path [lambda [in] [read-string 999999 in]] #:mode 'text]]]
;                             (set! last-file-name a-path)
;                             [send left-text-editor insert file-source]]
;                           [pretty-write defs]]]
;[define [get-perl-multi-defs input-files]
;  [apply append [map [lambda [a-path]
;                       [read-from-string [shell-out "perl extract_subs.pl" [lambda [ stdout-pipe stdin-pipe proc-id stderr-pipe control-proc] 
;                                                                             [send editor-window set-status-text [format "Loading ~a" a-path]]
;                                                                             [display a-path stdin-pipe]
;                                                                             [newline stdin-pipe]
;                                                                             [handler-capture-output stdout-pipe stdin-pipe proc-id stderr-pipe control-proc]
;                                                                             ]]]]
;                     input-files]]]

;  [define load-perl-file [lambda  [a-path editor]
;                         [send editor erase]
;                         [read-accept-reader #t]
;                         [let  [[file-source [call-with-input-file a-path [lambda [in] [read-string 999999 in]] #:mode 'text]]]
;                           [send editor insert file-source]
;                           [set! defs [get-perl-multi-defs [cons a-path [hash-ref vars "perl-project-files" [lambda [] '[]]]]]]
;                           
;                           [write defs]]
;                         [status [format "Loaded ~a" a-path]]]]

;;; [define pop-command-viewport  [make-pop-func [lambda [new-box word]
;;;                                                [write "Creating command box"]
;;;                                                [set! viewports-name [cons [cons new-box word]  viewports-name]]
;;;                                                ""
;;;                                                ]
;;;                                              [lambda [parent child text]  [write "closing command box"](with-input-from-string text
;;;                                                                                                          (lambda () (eval (read))))]]]

;;; [define pop-varedit  [make-pop-func [lambda [a-box word] [write "popping varedit"]
;;;                                       ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
;;;                                       [pretty-format [hash-ref vars word [lambda [] "unknown"]]]]
                                    
;;;                                     [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
;;;                                                                                  [the-set! [format "(set! ~a [quote ~a])" var-name the-text]]]
;;;                                                                           ;[display [format "Evalling ~a~n" the-set!]]
;;;                                                                           ;[eval-string the-set!]
                                                                          
;;;                                                                           [hash-set! vars var-name [read [open-input-string the-text]]]
;;;                                                                           ""]]]]
;;; [define pop-listvars  [make-pop-func [lambda [a-box word] [write "popping listvars"]
;;;                                        ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
;;;                                        [pretty-format [hash-keys vars ]]
;;;                                        ]
                                    
;;;                                      [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
;;;                                                                                   [the-set! [format "(set! ~a [quote ~a])" var-name the-text]]]
;;;                                                                            ;[display [format "Evalling ~a~n" the-set!]]
;;;                                                                            ;[eval-string the-set!]
                                                                          
;;;                                                                            [hash-set! vars var-name [read [open-input-string the-text]]]
;;;                                                                            ""]]]]

;;; [define pop-keybindings  
;;; [make-pop-func 
;;; [lambda [a-box word] [write "popping keybindings"]
;;;                                           ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
;;;                                           [format "`~a" [pretty-format keymaps]]
;;;                                           ]
                                    
;;;                                         [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
;;;                                                                                      ]
;;;                                                                               ;[display [format "closing ~a~n" var-name]]
;;;                                                                               ;[eval-string the-set!]
                                                                          

;;;                                                                               [set! keymaps [eval-string the-text]]
;;;                                                                               [map [lambda [definition]
;;;                                                                                      ;[display [format "Binding ~a to ~a~n" [first definition] [second definition]]]
;;;                                                                                      [send a-keymap map-function [first definition] [second definition]]]
;;;                                                                                    keymaps]
;;;                                                                               [insert-keybindings t]
;;;                                                                               ""]]]]


;;; [define pop-defs  [make-pop-func [lambda [a-box word] [write "popping defs"]
;;;                                    ;[set! viewports-name [cons [cons a-box word]  viewports-name]]
;;;                                    [format "`~a" [pretty-format defs]]
;;;                                    ]
                                    
;;;                                  [lambda [parent a-textbox the-text] [letrec [[var-name [cdr [assq a-textbox viewports-name]]]
;;;                                                                               ]
;;;                                                                        ;[display [format "closing ~a~n" var-name]]
;;;                                                                        ;[eval-string the-set!]
                                                                          

;;;                                                                        [set! defs [eval-string the-text]]
                                                                          
;;;                                                                        ""]]]] 
  )