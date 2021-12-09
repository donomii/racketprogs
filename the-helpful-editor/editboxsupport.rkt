(module editboxsupport racket
[require srfi/13 mzlib/string "support.rkt"  mred framework]
   (provide )

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