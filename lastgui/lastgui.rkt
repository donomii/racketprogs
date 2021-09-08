#lang sketching

[define m '[w "toplevel" [name "Toplevel container"] [type "toplevel"][children
                                                                       [w "A Test Window" [name "Test window"] [type "window"] [x 50] [y 50]]
                                                                       [w "menu" [name "Popup menu"] [type "popup"][children
                                                                                                                    [w "Do thing" [type "button"] [id "do thing button"]]
                                                                                                                    [w "Exit" [id "exit button"][type "button"]]]]
             
                                                                       ]]]

[define [mx x] [car x]]
[define [my x] [cadr x]]
[define [startx x] [caddr x]]
[define [starty x] [cadddr x]]
[define [mouse-event x] [cadr [cdddr x]]]
[define [do-draw x] [caddr [cdddr x]]]
[define [button-down? x] [cadddr [cdddr x]]]
[define [advancer x y x2 y2] [list x y2]]

[define last-state '[0 0 0 0 #f]]

[define [inside? mx my x1 y1 x2 y2]
  [and
   [and [> mx x1] [< mx x2]]
   [and [> my y1] [< my y2]]
   ]]


[define button-down #f]
[define persist-mouse-event #f]
[define [button-click id]
  [printf "Clicked on button: ~a~n" id]
  [exit 0]]


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
  [printf "Rendering ~a~nState: ~a~n" type state]

  [letrec [[x [mx state]]
           [y  [my state]]]
    
    [cond
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
                                [printf "Hover:~a id:~a mouse-event:~a\n" hover? [assoc 'id attribs] [mouse-event state]]
                                [when hover?
                                  [when [assoc 'id attribs]
                                    [when [equal? [mouse-event state] 'release]
                                      [button-click [cadr [assoc 'id attribs]]]
                                      ]]]
                                
                                [list [car [advancer x y x2  y2]] [cadr [advancer x y x2  y2]] [startx state] [starty state] [mouse-event state] [do-draw state] advancer]]]
      [[equal? type "window"] [letrec [
                                       [x [cadr[assoc 'x attribs]]]
                                       [y [cadr [assoc 'y attribs]]]
                                       [x2 [+ x 200]]
                                       [y2 [ + y 200]]
                                       [hover? [inside? mouse-x mouse-y x y x2 y2]]]
                                [when [do-draw state]
                                  [if hover?
                                      [stroke 255 128 128 255]
                                      [stroke 0 0 0 255]
                                    
                                      ]
                                  [fill 255]
                                  [rect x y  x2 y2]
                                  [text-size 11]
                                  [fill 0]
                                  [text data [/ [+ x x2] 2] y ]
                                  ]
                                [printf "Hover:~a id:~a mouse-event:~a\n" hover? [assoc 'id attribs] [mouse-event state]]
                                [when hover?
                                  [when [assoc 'id attribs]
                                    [when [equal? [mouse-event state] 'release]
                                      [button-click [cadr [assoc 'id attribs]]]
                                      ]]]
                                
                                [list [car [advancer x y x2  y2]] [cadr [advancer x y x2  y2]] [startx state] [starty state] [mouse-event state] [do-draw state] [button-down? state] advancer]]]
      [[equal? type "popup"] [begin
                               [list [startx state] [starty state] [startx state] [starty state] [mouse-event state] [do-draw state] [button-down? state] advancer]
                               ]]
      [else state]
    
  
      ]
      
    ]

  ]

[define [fold-children children state]
  ;  [display "fold-children"]
  ;  [displayln children]
  ;  [display "State:"]
  ;  [displayln state]
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

  [set! last-state [letrec [[new-state [parse-tree m [list mouse-x mouse-y  ;Current draw position
                                                           ;Drag start x
                                                           [if [not button-down]
                                                               mouse-x
                                                               [startx last-state]]
                                                           ;Drag start y
                                                           [if [not button-down]
                                                               mouse-y
                                                               [starty last-state]]
                                                           ;Mouse event in progress? (false, press, release)
                                                           persist-mouse-event
                                                           #t   ;do draw
                                                           button-down ;Is the button currently down?
                                                           advancer]]]]
                                         
                     new-state]]
  [when mouse-pressed  
          [set! button-down #t]]

  
                    

                     

  [set! persist-mouse-event #f]
  
  )