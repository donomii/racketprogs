#lang racket
(require net/http-easy)
 (require (prefix-in  srfi_ srfi/1 ))

[require "lastgui.rkt"]
[require "spath.rkt"]
[require "parse.rkt"]

[define frame-count 0]
[define last-frame-count 0]
[define last-frame-time (current-inexact-milliseconds) ]
[define my-frame-rate 0]
[define frame-rate 0]

[define m `(w "toplevel" (children (w "OK" (id "ok button") (advancer horizontal) (x 10) (y 10) (w 50) (h 50) (type "button") (extra-data ("" ("package" "main" "import" ("\"fmt\"" "\"io/ioutil\"" "\"github.com/lu4p/astextract\"") "func" "main" () ("code" "," "_" ":" "=" "ioutil.ReadFile" ("\"astdump.go\"") "f" "," "err" ":" "=" "astextract.Parse" ("string" ("code")) "if" "err" "!" "=" "nil" ("panic" ("err")) "fmt.Printf" ("\"%+v\\n\"" "," "f"))) ""))) (w "A Test Window" (children (w "A big container" (children (w [lambda [] [format "Frame rate: ~a" frame-rate]] (children  (w "OK" (id "ok button") (type "button") (advancer vertical))) (h 22) (w 100) (y 485) (x 534) (type "container") (min-w 100) (expand 0.5) (advancer horizontal)) (w "A h2container" (children (w "Dump widgets" (h 100) (w 100) (y 485) (x 634) (id "DumpWidgetsLabel") (min-w 100) (expand 0.5) (type "text")) (w "OK" (children) (id "DumpWidgets") (type "button"))) (h 22) (w 100) (y 485) (x 634) (type "container") (min-w 100) (expand 0.5) (advancer horizontal))) (h 22) (w 200) (y 485) (x 534) (type "container") (advancer vertical))) (h 200) (w 200) (y 463) (x 534) (id "Test window") (type "window") (min-w 200) (min-h 200) (advancer window)) (w "Another Test Window" (children (w "A h2container" (children  (w ((1 1) (2 2) (3 3) (4 4)) (children (w "1" (id (1 1)) (type "button") (w 100) (h 20)) (w "2" (id (2 2)) (type "button") (w 100) (h 20)) (w "3" (id (3 3)) (type "button") (w 100) (h 20)) (w "4" (id (4 4)) (type "button") (w 100) (h 20))) (h 300) (w 100) (y 54) (x 568) (type "list") (expand 1/3) (advancer horizontal)) (w ((1 1) (2 2) (3 3) (4 4)) (children (w "1" (id (1 1)) (type "button") (w 100) (h 20)) (w "2" (id (2 2)) (type "button") (w 100) (h 20)) (w "3" (id (3 3)) (type "button") (w 100) (h 20)) (w "4" (id (4 4)) (type "button") (w 100) (h 20))) (h 300) (w 100) (y 54) (x 668) (type "list") (expand 1/3) (advancer horizontal))) (h 22) (w 100) (y 54) (x 468) (type "container") (min-w 100) (expand 0.5) (advancer vertical)) (w "Quit" (id "exit") (type "button"))) (h 400) (w 300) (y 32) (x 468) (id "Another Test window") (type "window") (min-w 300) (min-h 200))) (h 22) (w 88) (y 0) (x 0) (id "Toplevel container") (type "toplevel"))

;  [w "toplevel" [id "Toplevel container"] [type "toplevel"] [x 0] [y 0]
;              [children
;                [w "OK" [id "ok button"][advancer horizontal] [x 10] [y 10] [w 50] [h 50][type "button"] [extra-data ,[parse-go]]]
;               [w "A Test Window" [id "Test window"] [type "window"] [x 500] [y 500] [w 200] [h 200] [min-w 200][min-h 200][advancer window]
;                  [children
;                   
;                   [w "A big container" [type "container"] [advancer vertical][w 200] [children
;                                                                                [w "A h1container" [type "container"] [w 100] [min-w 100][expand 0.5] [advancer horizontal][children
;                                                                                                                                          [w ,[lambda [] [format "Frame rate: ~a" frame-rate]]
;                                                                                                                                             [id "test text"] [type "text"][min-w 100][w 100] [h 100][expand 0.5][advancer vertical]]
;                                                                                                                                          [w "OK" [id "ok button"] [type "button"][advancer vertical]]]]
;                                                                                [w "A h2container" [type "container"] [w 100] [min-w 100][expand 0.5][advancer horizontal][children
;                                                                                                                                            [w "Dump widgets"
;                                                                                                                                               [id "DumpWidgetsLabel"][w 100][min-w 100] [h 100][expand 0.5] [type "text"]]
;                                                                                                                                            [w "OK" [id "DumpWidgets"] [type "button"]]]]]]] ]
;               [w "Another Test Window" [id "Another Test window"] [type "window"] [x 150] [y 150][min-w 300][min-h 200]  [w 300] [h 400]
;                  [children
;                   [w "A h2container" [type "container"] [w 100] [min-w 100][expand 0.5][advancer vertical][children
;                   [w ,[map [lambda [x] [list x [format "dir/~a" x]]] [directory-list]]
;                      [type "list"][expand 1/3] [w 100][h 300][advancer horizontal]]
;                   [w [[1 1] [2 2] [3 3] [4 4]]
;                      [type "list"][expand 1/3] [w 100][h 300][advancer horizontal]]
;                   [w [[1 1] [2 2] [3 3] [4 4]]
;                      [type "list"] [expand 1/3][w 100][h 300][advancer horizontal]]]]
;                   [w "Quit" [id "exit"] [type "button"]]]]
;                                                        
;;              [w "menu" [id "Popup menu"] [type "popup"][children
;;                                                         [w "Do thing" [type "button"] [id "do thing button"]]
;;                                                         [w "Exit" [id "exit button"][type "button"]]]]
;
;              ]]
             
  ]

;some more state
[define button-down #f]
[define persist-mouse-event #f]



;Handle sketch input events
[define [on-mouse-pressed]
  [set! persist-mouse-event 'press]]

[define [on-mouse-released]
  [set! persist-mouse-event 'release]]
  

;set an initial state
[define last-state `[
                     [mx . 0]
                     [my . 0]  ;Current draw position
                     [startx  . 0 ;Drag start x
                                                           
                              ]
                     ;Drag start y
                     [starty . 0]
                     ;Mouse event in progress? (false, press, release)
                     [mouse-event . 'false]
                     [do-draw . #t]   ;do draw
                     [button-down? . #f] ;Is the button currently down?
                     [advancer . vertical-advancer]
                     [drag-target . #f]
                     [dragvecx . 0]
                     [dragvecy . 0] ;Total drag vector, x and y
                     ]]




[define [my-text data x y x2 y2]
   (get (format "http://localhost:8080/command/text(~a,~a,~a);" data x [+ y [/ [- y2 y]3]]  ))

  ]

[define [button-click id widget attribs]
[printf "You clicked on button ~a: ~a~n" id widget]
  [cond
    [[equal? id "exit"] [exit 0]]
    [[equal? id "DumpWidgets"] [write m]]
    ]
  ;[alist-cons 'children [cons '[w "OK" [id "ok button"] [x 10] [y 10] [w 50] [h 50][type "button"]] [s=f children attribs '[]]] attribs]
  [let [[extra-d [car [s=f extra-data attribs '[[]]]]]]
    [if [list? extra-d]
  [srfi_alist-cons 'children [map
                         [lambda [x]
                           `[w ,[format "~a" [if [and [list? x] [not [equal? '[] x]]] [format "~a*" [car x]] x]] [id ,[format "button ~a" x]] [extra-data ,x][x 10] [y 10] [w 50] [h 50][discard-child-position #t][advancer vertical][child-advancer horizontal][type "button"]] ]
                       
                          extra-d] attribs]
  attribs
  
  ]
             
  ]]

[define background  (lambda(a b c d)(get (format "http://localhost:8080/command/background(~a,~a,~a,~a);" a b c d)))]
[define draw-funcs `[
                     [fill . ,(lambda(a b c d) (get (format "http://localhost:8080/command/fill(~a,~a,~a,~a);" a b c d)))]

                     [rect . ,(lambda(a b c d e) (get (format "http://localhost:8080/command/rectangle(~a,~a,~a,~a);" a b c d)))]
                     [stroke . ,(lambda(a b c d) (get (format "http://localhost:8080/command/stroke(~a,~a,~a,~a);" a b c d)))]
                     [text-size . ,(lambda(a) (get (format "http://localhost:8080/command/textsize(~a);" a )))]
                     [text . ,(lambda(a b c d e) (get (format "http://localhost:8080/command/text(`~a`,~a,~a);" a b c )))]
                     [text-align . ,(lambda(a b) a)] ;,(lambda(a b c d) (get (format "http://localhost:8080/command/stroke(~a,~a,~a,~a);" a b c d)))]]
                     [button-click . ,button-click]
                     ]]
[set-draw-funcs! draw-funcs]
(define (draw)
[set! frame-count [add1 frame-count]]
  [when [> [- (current-inexact-milliseconds)  last-frame-time] 1000]
    [set! frame-rate [* 1000 [/ [- frame-count last-frame-count] [- (current-inexact-milliseconds)  last-frame-time]]]]
  [set! last-frame-time (current-inexact-milliseconds) ]
  [set! last-frame-count frame-count]]
  ;clear the window
  (get (format "http://localhost:8080/command/clear();"))
  [background 255 255 0 255]
   
  ;[when persist-mouse-event [printf "Mouse button: ~a~n" mouse-button]
 ;   [printf "Mouse position: ~a~n"[list mouse-x mouse-y]]]

  [letrec [[alist [walk-widget-tree
                   m
                   `[[nextx . ,[car [s=f x [cddr m] '[0]]]];Current draw position
                     [nexty . ,[car [s=f y [cddr m] '[0]]]];Current draw position
                     [mx . 0]
                     [my . 0]  
                     [startx  .  ;Drag start x
                                                           
                              ,[if [not button-down]
                                   0
                                   [startx last-state]]]
                     ;Drag start y
                     [starty . ,[if [not button-down]
                                   0
                                    [starty last-state]]]
                     ;Mouse event in progress? (false, press, release)
                     [mouse-event . ,persist-mouse-event]
                     [do-draw . #t]   ;do draw
                     [button-down? . ,button-down] ;Is the button currently down?
                     [advancer . ,vertical-advancer]
                     [drag-target . ,[s= drag-target last-state]]
                     [dragvecx . ,[- 0 [startx last-state]]]
                     [dragvecy . ,[- 0 [starty last-state]]] ;Total drag vector, x and y
                     ]
                   [list 0 0 0 0]
                   '[]]]
           [new-state [cadr alist]]
           [new-template [car alist]]
           ]
                                         
    [set! last-state [srfi_delete-duplicates  new-state [lambda [x y] [equal? [car x] [car y]]]]]
    [set! m new-template]
    ]
  
  ; [printf "New state: ~a~n" last-state]
  ;[printf "New widget tree: ~a~n" m]
;  [if mouse-pressed  
;      [set! button-down #t]
;      [set! button-down #f]]

  [when [equal?  persist-mouse-event 'release]
  
    [set! last-state [srfi_alist-cons 'drag-target #f last-state]]
    [set! last-state [srfi_alist-cons 'resize-target #f last-state]]
    ]
  
                  

                     

  [set! persist-mouse-event #f]
  
  
;[displayln (output-profile-results)]
;[displayln (get-profile-results)]
  
  )

(draw)