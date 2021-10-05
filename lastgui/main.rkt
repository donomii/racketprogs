#lang sketching
[require "lastgui.rkt"]
[require "spath.rkt"]
[require srfi/1]
[define m '[w "toplevel" [id "Toplevel container"] [type "toplevel"]
              [children
               [w "A Test Window" [id "Test window"] [type "window"] [x 50] [y 50] [w 200] [h 200] [advancer window]
                  [children
                   [w "A big container" [type "container"] [advancer vertical] [children
                                                                                [w "A h1container" [type "container"] [advancer horizontal][children
                                                                                                                                          [w "A handy little paragraph of text that should test the renderer a bit"
                                                                                                                                             [id "test text"] [type "text"][w 200] [h 100][advancer horizontal]]
                                                                                                                                          [w "OK" [id "ok button"] [type "button"][advancer vertical]]]]
                                                                                [w "A h2container" [type "container"] [advancer horizontal][children
                                                                                                                                            [w "A handy little paragraph of text that should test the renderer a bit"
                                                                                                                                               [id "test text"][w 100] [h 200] [type "text"]]
                                                                                                                                            [w "OK" [id "ok button"] [type "button"]]]]]]] ]
               [w "Another Test Window" [id "Another Test window"] [type "window"] [x 150] [y 150]  [w 400] [h 400]
                  [children
                   [w "A handy little paragraph of text that should test the renderer a bit"
                      [type "text"]]
                   [w "Not OK" [id "not ok button"] [type "button"]]]]]
                                                        
              [w "menu" [id "Popup menu"] [type "popup"][children
                                                         [w "Do thing" [type "button"] [id "do thing button"]]
                                                         [w "Exit" [id "exit button"][type "button"]]]]]
             
  ]

;some more state
[define button-down #f]
[define persist-mouse-event #f]



;[display fill]
;[set-display-tree! m]
(size 800 600) 

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
                     [drag-target . 'drag-target]
                     [dragvecx . 0]
                     [dragvecy . 0] ;Total drag vector, x and y
                     ]]

[define draw-funcs `[
                     [fill . ,fill]
                     [rect . ,rect]
                     [stroke . ,stroke]
                     [text-size . ,text-size]
                     [text . ,text]
                     [text-align . ,text-align]
                     ]]
[set-draw-funcs! draw-funcs]
(define (draw)

  ;clear the window
  [background 255]
[when focused?
  [letrec [[alist [walk-widget-tree
                   m
                   `[[nextx . 0];Current draw position
                     [nexty . 0];Current draw position
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
  [if mouse-pressed  
      [set! button-down #t]
      [set! button-down #f]]

  [when [equal?  persist-mouse-event 'release]
  
    [set! last-state [alist-cons 'drag-target #f last-state]]
    [set! last-state [alist-cons 'resize-target #f last-state]]
    ]
  
                  

                     

  [set! persist-mouse-event #f]
  
  )