#lang racket
(require racket/draw)
(require racket/date)
; initialize the library
(open-graphics)

[require "lastgui.rkt"]
[require "spath.rkt"]
[require srfi/1]
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



(define MainWindow 
  (open-viewport "Jaarproject (2012-2013)" 800 800))


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

[define [my-circle x y w h]
  
  ((draw-ellipse MainWindow) (make-posn x y) w h)

 ]

[define [my-rect x y w h]

  
((draw-rectangle MainWindow)
    (make-posn x y)
  w h
   )]

[define [my-text data x y x2 y2]
[text data x [+ y [/ [- y2 y]3]] [- x2 x] [- y2 y] ]
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
  [alist-cons 'children [map
                         [lambda [x]
                           `[w ,[format "~a" [if [and [list? x] [not [equal? '[] x]]] [format "~a*" [car x]] x]] [id ,[format "button ~a" x]] [extra-data ,x][x 10] [y 10] [w 50] [h 50][discard-child-position #t][advancer vertical][child-advancer horizontal][type "button"]] ]
                       
                          extra-d] attribs]
  attribs
  
  ]
             
  ]]
[define draw-funcs `[
                     [fill . ,fill]
                     [rect . ,my-rect]
                     [stroke . ,stroke]
                     [text-size . ,text-size]
                     [text . ,text]
                     [text-align . ,text-align]
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
  [background 255]
  [when persist-mouse-event [printf "Mouse button: ~a~n" mouse-button]
    [printf "Mouse position: ~a~n"[list mouse-x mouse-y]]]
[when focused?
  [letrec [[alist [walk-widget-tree
                   m
                   `[[nextx . ,[car [s=f x [cddr m] '[0]]]];Current draw position
                     [nexty . ,[car [s=f y [cddr m] '[0]]]];Current draw position
                     [mx . ,mouse-x]
                     [my . ,mouse-y]  
                     [startx  .  ;Drag start x
                                                           
                              ,[if [not button-down]
                                   mouse-x
                                   [startx last-state]]]
                     ;Drag start y
                     [starty . ,[if [not button-down]
                                    mouse-y
                                    [starty last-state]]]
                     ;Mouse event in progress? (false, press, release)
                     [mouse-event . ,persist-mouse-event]
                     [do-draw . #t]   ;do draw
                     [button-down? . ,button-down] ;Is the button currently down?
                     [advancer . ,vertical-advancer]
                     [drag-target . ,[s= drag-target last-state]]
                     [dragvecx . ,[- mouse-x [startx last-state]]]
                     [dragvecy . ,[- mouse-y [starty last-state]]] ;Total drag vector, x and y
                     ]
                   [list 0 0 0 0]
                   '[]]]
           [new-state [cadr alist]]
           [new-template [car alist]]
           ]
                                         
    [set! last-state [delete-duplicates  new-state [lambda [x y] [equal? [car x] [car y]]]]]
    [set! m new-template]
    ]
  ]
  ; [printf "New state: ~a~n" last-state]
  ;[printf "New widget tree: ~a~n" m]
  [if mouse-pressed  
      [set! button-down #t]
      [set! button-down #f]]

  [when [equal?  persist-mouse-event 'release]
  
    [set! last-state [alist-cons 'drag-target #f last-state]]
    [set! last-state [alist-cons 'resize-target #f last-state]]
    ]
  
                  

                     

  [set! persist-mouse-event #f]
  
(set-frame-rate! 30)
  
;[displayln (output-profile-results)]
;[displayln (get-profile-results)]
  
  )