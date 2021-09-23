#lang sketching

[require "spath.rkt"]
[require srfi/1]

 (require compatibility/mlist)

[define m '[w "toplevel" [id "Toplevel container"] [type "toplevel"]
              [children
               [w "A Test Window" [id "Test window"] [type "window"] [x 50] [y 50]
                  [children
                   [w "A handy little paragraph of text that should test the renderer a bit"
                      [id "test text"] [type "text"]]
                   [w "OK" [id "ok button"] [type "button"]]]]]
                                                        
              [w "menu" [id "Popup menu"] [type "popup"][children
                                                         [w "Do thing" [type "button"] [id "do thing button"]]
                                                         [w "Exit" [id "exit button"][type "button"]]]]
             
              ]]

[define [mx x] [s= mx x]]
[define [my x] [s= my x]]
[define [startx x] [s= startx x]]
[define [starty x] [s= starty x]]
[define [mouse-event x] [s= mouse-event x]]
[define [do-draw x] [s= do-draw x]]
[define [button-down? x] [s= button-down?  x]]
[define [advancer x y x2 y2] [list x y2]]


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
                     [advancer . ,advancer]
                     [drag-target . 'drag-target]
                     [dragvecx . 0]
                     [dragvecy . 0] ;Total drag vector, x and y
                     ]]

[define [inside? mx my x1 y1 x2 y2]
  [and
   [and [> mx x1] [< mx x2]]
   [and [> my y1] [< my y2]]
   ]]


[define button-down #f]
[define persist-mouse-event #f]
[define [button-click id]
  [printf "Clicked on button: ~a~n" id]
  [exit 0]
  ]


[define [want-to-render? t state]
  [letrec [
           [ data [cadr t]]
           [attribs [cddr t]]
           [type [cadr [assoc 'type attribs]]]
           [children [assoc 'children attribs]]]
    [if [equal? type "popup"]
        [or [button-down? state] [mouse-event state]]
        #t
        ]
    ]

  ]


[define [render data type attribs children t state]
  ;[printf "Rendering ~a~nState: ~a~n" type state]

  [letrec [[x [mx state]]
           [y  [my state]]]
    
    [cond
      [[equal? type "text"][letrec [
                                    [x2 [+ x 100]]
                                    [y2 [ + y 100]]]
                             [fill 255]
                             [stroke 0 0 0 255]
                             [rect x y  100 100]
                             [text-size 11]
                             [fill 0]
                             [text data x y 100 100 ]
                             [append [list `[mx . ,[car [advancer x y x2 y2]]] `[my . ,[cadr [advancer x y x2  y2]]] ] state ]]]
      [[equal? type "button"] [letrec [
                                       [x2 [+ x 50]]
                                       [y2 [ + y 15]]
                                       [hover? [inside? mouse-x mouse-y x y x2 y2]]]
                                [when [do-draw state]
                                  [if hover?
                                      [fill 128 128 128 255]
                                      (fill 255 255 255 0)
                                    
                                      ]
                                  [stroke 0 0 0 255]
                                  [rect x y  50   11]
                                  [text-size 11]
                                  [fill 0]
                                  [text data x y ]
                                  ]
                                ; [printf "Hover:~a id:~a mouse-event:~a\n" hover? [assoc 'id attribs] [mouse-event state]]
                                [when hover?
                                  [when [assoc 'id attribs]
                                    [when [equal? [mouse-event state] 'release]
                                      [button-click [cadr [assoc 'id attribs]]]
                                      ]]]
                                [append [list `[mx . ,[car [advancer x y x2 y2]]] `[my . ,[cadr [advancer x y x2  y2]]] ] state ]]]
      [[equal? type "window"]
       ;[printf "case: window~n"]
       [letrec [
                [x [+ [if [s= button-down? state] [s= dragvecx state] 0] [cadr[assoc 'x attribs]]]]
                [y [+ [if [s= button-down? state][s= dragvecy state] 0] [cadr [assoc 'y attribs]]]]
                [x2 [+ x 200]]
                [y2 [ + y 200]]
                [hover? [inside? mouse-x mouse-y x y x2 y2]]]
         [when [do-draw state]
           [if hover?
               [stroke 255 128 128 255]
               [stroke 0 0 0 255]
                                    
               ]
           [fill 255]
           [rect x y  200 200]
           [text-size 11]
           [fill 0]
           [text data [/ [+ x x2] 2] y ]
           ]
         ; [printf "Hover:~a id:~a mouse-event:~a\n" hover? [assoc 'id attribs] [mouse-event state]]
                                
                                  [when hover?
                                  [when [assoc 'id attribs]
                                    [when [equal? [mouse-event state] 'release]
                                      [let [[pair [assoc 'x attribs]]]
                                        [set-mcdr! pair [list x]]
                                        ]
                                      ]]]
         [append [list `[mx . ,[car [advancer x y x2  [+ y 22]]]] `[my . ,[cadr [advancer x y x2  [+ y 22]]]] ] state ]]]
      [[equal? type "popup"] [begin
                               [append [list `[mx . ,[startx state]] `[my . ,[starty state]]] state]
                               ]]
      [else state]
    
  
      ]
      
    ]

  ]

[define [fold-children children state]
  [display "fold-children"]
  [displayln children]
  [display "State:"]
  [displayln state]
  [if [< [length children] 1]
      state
      [fold-children [cdr children] [parse-tree [car children] state]]
  
      ]]

[define [parse-tree t state]
  ; [printf "Parsetree ~a~nState: ~a~n" t state]
  [letrec [
           [ data [cadr t]]
           [attribs [cddr t]]
           [type [cadr [assoc 'type attribs]]]
           [children [assoc 'children attribs]]]
    ;Used to enable/disable widgets
    [if [want-to-render? t state]
        ;render sub tree
        [let [[new-state [render data type attribs children t state]]]
          ;If there are children
          [when children
            ;Render them
            [fold-children [cdr children] new-state]]
          ;[printf "Parsetree after children ~a~nNew state: ~a~n" t new-state]
          new-state
          ]
        state]]]



(size 640 480) 

[define [on-mouse-pressed]
  [set! persist-mouse-event 'press]]

[define [on-mouse-released]
  [set! persist-mouse-event 'release]
  [displayln "Mouse button released"]]
  
(define (draw)

  [background 255]

 

  [set! last-state [letrec [[new-state [parse-tree [list->mlist m] `[
                                                       [mx . ,mouse-x]
                                                       [my . ,mouse-y]  ;Current draw position
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
                                                       [advancer . ,advancer]
                                                       [drag-target . 'drag-target]
                                                       [dragvecx . ,[- mouse-x [startx last-state]]]
                                                       [dragvecy . ,[- mouse-y [starty last-state]]] ;Total drag vector, x and y
                                                       ]]]]
                                         
                     new-state]]
  [if mouse-pressed  
      [set! button-down #t]
      [set! button-down #f]]

  
                  

                     

  [set! persist-mouse-event #f]
  
  )