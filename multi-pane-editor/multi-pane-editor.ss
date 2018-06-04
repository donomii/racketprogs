#lang scheme
(require mred
         mzlib/class
         mzlib/math
         sgl
         sgl/gl-vectors
         framework
         mzlib/string)
[define abstract-edit%
  (class editor-canvas%
    (super-new)
    
    )]
[define slurp [lambda [] [let [[l [read-line]]]
                           [if [eof-object? l]
                               ""
                               [string-append l [slurp]]]]]]
[define o (lambda () (let ([f-name (get-file)])
                       (with-input-from-file f-name (lambda () (set! text-list (list->vector (perl-split  (slurp))))))))]
[define (perl-split a-text) (let ([lines (regexp-split #rx"sub" a-text)])
                              (map (lambda (l) (string-append "sub " l)) lines))]
[define (cr-split a-text)  (regexp-split "\n|\r" a-text)]
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
                (eval (read-from-string command))))
            
            
            [super on-char ev])]]
    )]
[define bottom-edit%
  (class abstract-edit%
    (super-new)
    [define/override [on-focus ev]
      [when ev
        [scroll-down]
        [super on-focus ev]]]
    [define/override [on-char ev]
      [write "caught char"]
      
      [super on-char ev]]
    )]

[define myedit%
  (class abstract-edit%
    (super-new)
    [define/override [on-focus ev]
      [write "caught click in mid-edit"]
      [super on-focus ev]] 
    [define/override [on-char ev]
      (define b (box ""))
      [send mid-box get-position b]
      [write [format "caught char in mid-edit at ~a(~a)~n" b [send mid-box get-text [- [unbox b] 5] [+ [unbox b] 5]]]]
      [write ev]
      [newline]
      
      
      
      [super on-char ev]]
    )]
[define top-edit%
  (class abstract-edit%
    (super-new)
    [define/override [on-focus ev]
      [when ev
        [scroll-up]
        [super on-focus ev]]]
    [define/override [on-char ev]
      [write "caught char"]
      [super on-char ev]]
    )]
[define mw 200]
(define topwin (new (class frame%
                      (augment* [on-close (lambda () (exit))])
                      (super-new))
                    [label "editwin"]
                    [style '(metal)]))
(define menus (new (class frame:standard-menus%
                     (augment* [on-close (lambda () (exit))])
                     (super-new))
                   [label "editwin"]
                   [parent topwin]
                   [style '(metal)]))

;[define topwin [new  [label "menu"] [parent rootwin] ]]
;[send topwin show #t]
[define [make-editor editor-class a-parent ]  
  ;(let[[ c (new editor-canvas% [parent a-parent])]
  (let[[ c (new editor-class [parent a-parent][min-width mw][min-height 150])]
       ( t (new text%))]
    (send t auto-wrap #t)
    (send c set-editor t)
    [list c t])]


[define [make-top-editor-pane a-parent ]  
  [make-editor top-edit% a-parent ]]
[define [make-command-pane a-parent ]  
  [make-editor command-pane% a-parent ]]
[define [make-bottom-editor-pane a-parent ]
  [make-editor bottom-edit% a-parent ]]
[define [make-editor-pane a-parent ]  
  [make-editor myedit% a-parent ]]
[define [make-center-stack a-parent]
  [let [[v [new vertical-pane% [parent a-parent]]]]
    [list 
     [make-top-editor-pane v]
     [make-editor-pane v]
     [make-bottom-editor-pane v]]
    ]]
[define [make-left-stack a-parent]
  [let [[v [new vertical-pane% [parent a-parent]]]]
    [list 
     [make-top-editor-pane v]
     [make-editor-pane v]
     [make-command-pane v]]
    ]]
[define h [new horizontal-pane% [parent topwin]]]
[define  all-panes 
  [list [make-left-stack h]
        [make-center-stack h]
        [make-center-stack h]]]
[define mid-box [second [second [second all-panes]]]]
[define top-box [second [first [second all-panes]]]]
[define bottom-box [second [third [second all-panes]]]]
[define command-box [second [third [first all-panes]]]]
[send mid-box insert "mid" 0]
[send top-box insert "top" 0]
[send bottom-box insert "bottom" 0]
[send topwin show #t]
[define current-item 4]
[define text-list [list->vector [list "[define top-edit%
                      (class abstract-edit%
                        (super-new)
                        [define/override [on-focus ev]
                          [when ev
                            [scroll-up]
                            [super on-focus ev]]]
                        [define/override [on-char ev]
                          [write caught char]
                          [super on-char ev]]
                        )]"
                                      
                                      "(define topwin (new (class frame%
                                          (augment* [on-close (lambda () (exit))])
                                          (super-new))
                                        [label editwin]
                                        [style '(metal)]))"
                                      "[define [make-top-editor-pane a-parent ]  
                      ;(let[[ c (new editor-canvas% [parent a-parent])]
                      (let[[ c (new top-edit% [parent a-parent])]
                           ( t (new text%))]
                        (send c set-editor t)
                        [list c t])]"
                                      "[define [make-bottom-editor-pane a-parent ]  
                      ;(let[[ c (new editor-canvas% [parent a-parent])]
                      (let[[ c (new bottom-edit% [parent a-parent])]
                           ( t (new text%))]
                        (send c set-editor t)
                        [list c t])]"
                                      "[define [make-editor-pane a-parent ]  
                      ;(let[[ c (new editor-canvas% [parent a-parent])]
                      (let[[ c (new myedit% [parent a-parent])]
                           ( t (new text%))]
                        (send c set-editor t)
                        [list c t])]"
                                      "[define [make-stack a-parent]
                      [let [[v [new vertical-pane% [parent a-parent]]]]
                        [list 
                         [make-top-editor-pane v]
                         [make-editor-pane v]
                         [make-bottom-editor-pane v]]
                        ]]"
                                      
                                      "[define h [new horizontal-pane% [parent topwin]]]"]]]
[define [set-pane t offset]
  (send t do-edit-operation 'select-all)
  (send t do-edit-operation 'clear)
  ;  [send mid-box clear]
  [send t insert [vector-ref text-list [+ current-item offset]] 0]
  ;  [send top-box insert "top" 0]
  ;   [send bottom-box insert "bottom" 0]
  ]
[define [set-panes] 
  [map [lambda [t] [apply set-pane t]] [list [list top-box -1]  [list mid-box 0]  [list bottom-box 1]]]] 
[define [save-mid-box] [vector-set! text-list current-item [send mid-box get-text 0 'eof #t]]]
[define [scroll-down]
  [save-mid-box]
  [set! current-item [add1 current-item]]
  [set-panes]
  [send [first [second [second all-panes]]] focus]]
[define [scroll-up]
  [save-mid-box]
  [set! current-item [sub1 current-item]]
  [set-panes]
  [send [first [second [second all-panes]]] focus]]

