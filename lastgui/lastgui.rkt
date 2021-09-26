#lang sketching

[require "spath.rkt"]
[require srfi/1]


;lastgui is an experiment in creating a portable, simple, and useful gui.  To achieve this, lastgui is a library, not a framework.  The surrounding program
;provides a window, the draw routines and a description of the gui, and lastgui renders onto the canvas provided.  Input is collected by the program using
;whatever native libraries, then passed into the gui to be processed.

;In order to actually make progress, I'm focussing on simple, effective solutions rather than complex complete solutions.  So lastgui contains significantly fewer features
;and less polish than other toolkits.

;Lastgui is not specifically a immediate or delayed mode gui, the best way to put it might be "state separated".  The widget tree defines the layout, and usually doesn't change
;(unless you change the layout by dragging a window or something else.  The state variable holds the ephemeral state - mouse clicks and movements, drag state, etc.  It is
;recreated on every frame, sometimes using data from the previous state.

;The state vairable is effectively global for this module

[define m '[w "toplevel" [id "Toplevel container"] [type "toplevel"]
              [children
               [w "A Test Window" [id "Test window"] [type "window"] [x 50] [y 50] [advancer window]
                  [children
                   [w "A big container" [type "container"] [advancer vertical] [children
                                                                                [w "A h1container" [type "container"] [advancer vertical][children
                                                                                                                                          [w "A handy little paragraph of text that should test the renderer a bit"
                                                                                                                                             [id "test text"] [type "text"][advancer horizontal]]
                                                                                                                                          [w "OK" [id "ok button"] [type "button"][advancer horizontal]]]]
                                                                                [w "A h2container" [type "container"] [advancer horizontal][children
                                                                                                                                            [w "A handy little paragraph of text that should test the renderer a bit"
                                                                                                                                               [id "test text"] [type "text"]]
                                                                                                                                            [w "OK" [id "ok button"] [type "button"]]]]]]] ]
               [w "Another Test Window" [id "Another Test window"] [type "window"] [x 150] [y 150]
                  [children
                   [w "A handy little paragraph of text that should test the renderer a bit"
                      [type "text"]]
                   [w "Not OK" [id "not ok button"] [type "button"]]]]]
                                                        
              [w "menu" [id "Popup menu"] [type "popup"][children
                                                         [w "Do thing" [type "button"] [id "do thing button"]]
                                                         [w "Exit" [id "exit button"][type "button"]]]]]
             
  ]



; Some helper functions to deal with state
[define [mx x] [s= mx x]]
[define [my x] [s= my x]]
[define [nx x] [s= nextx x]]
[define [ny x] [s= nexty x]]
[define [startx x] [s= startx x]]
[define [starty x] [s= starty x]]
[define [mouse-event x] [s= mouse-event x]]
[define [do-draw x] [s= do-draw x]]
[define [button-down? x] [s= button-down?  x]]

;The advancers.  At the moment, layout is performed by specifying which side of the current widget to draw the next widget on.
[define [vertical-advancer x y x2 y2] [list x y2]]
[define [horizontal-advancer x y x2 y2] [list x2 y]]
[define [new-advancer name bounds state]
  [when name
    [printf "Advancer: ~a Bounds: ~a~n" name bounds]]
  [let [[res [cond
               ;Place the next widget under the title bar
               [[equal? name 'window][set-state 'nextx [first bounds] [set-state 'nexty [+ 22 [second bounds]] state]]]
               ;Place the next widget to the top right of the current one
               [[equal? name 'horizontal][set-state 'nextx [third bounds] [set-state 'nexty [second bounds] state]]]
               ;Place the next widget to the bottom left of the current one
               [[equal? name 'vertical][set-state 'nextx [first bounds] [set-state 'nexty [fourth bounds] state]]]
               [else state]
      
               ]]]
    ;[printf "Advanced: ~a~n" res]
    res]]


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


;is mx, my inside the box x1,y1-x2,y2
[define [inside? mx my x1 y1 x2 y2]
  [and
   [and [> mx x1] [< mx x2]]
   [and [> my y1] [< my y2]]
   ]]


;some more state
[define button-down #f]
[define persist-mouse-event #f]

;example button callback
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

;helper function to add to the attribs conslist
[define [set-attrib key value attribs]
  [cons [list key value] attribs]]

;helper function to add to the state conslist
[define [set-state key value attribs]
  [cons [cons key value] attribs]]

;helper, sets drag state if conditions are met
[define [set-drag-target-if hover? id state]
  [if hover?
      [set-state 'drag-target id state]
      state]]

;the main render routine, is responsible for putting the graphics on the canvas
;returns [list bounds attribs state]
;
; bounds - a bounding box for the last draw operation
; attribs - the attributes for the current widget, including things like position, scroll position, and widget state
; state - the ephemeral state
[define [render data type attribs children t state parent-bounds]
  ;[printf "Rendering ~a~nState: ~a~n" type state]

  [letrec [[x [nx state]]
           [y  [ny state]]
           [id [s=f id attribs #f]]
           [advancer [s=f advancer state #f]]]
    
    ;[when [not id] [error [format "Error:  No id found for widget ~a~n" t]]]
    
    [cond
      [[equal? type "text"][letrec [
                                    [x2 [+ x 100]]
                                    [y2 [ + y 100]]
                                    [nextPos  [advancer x y x2  y2]]
                                    [hover? [inside? mouse-x mouse-y x y x2 y2]]
                                    ]
                             [fill 255]
                             [stroke 0 0 0 255]
                             [rect x y  100 100]
                             [text-size 11]
                             [fill 0]
                             [text data x y 100 100 ]
                             [list [list x y x2 y2] attribs
                                   [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                                                       [set-state 'nextx [car nextPos] [set-state 'nexty [cadr nextPos] state] ]]]]]
      [[equal? type "button"] [letrec [
                                       [x2 [+ x 50]]
                                       [y2 [ + y 15]]
                                       [nextPos  [advancer x y x2  y2]]
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
                                ;[printf "Hover:~a id:~a mouse-event:~a drag-target:~a is drag-target:~a\n" hover? [s= id attribs] [mouse-event state] [s= drag-target state][equal? [s= drag-target state] [s= id attribs]]]
                                [when hover?
                                  
                                  [when [equal? [s= drag-target state] [s= id attribs]]
                                    [when [equal? [mouse-event state] 'release]
                                      [button-click  [s= id attribs]]
                                      ]]]
                                [list [list x y x2 y2] attribs
                                      [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                                                          [set-state 'nextx [car nextPos] [set-state 'nexty [cadr nextPos] state ] ]]]]]
      [[equal? type "window"]
       ;[printf "case: window~n"]
       [letrec [
                [dragging? [and [button-down? state] [equal? [s= drag-target state] [s= id attribs]]]]
                [x [if dragging?  mouse-x  [cadr[assoc 'x attribs]]]]
                [y  [if dragging? mouse-y  [cadr [assoc 'y attribs]]]]
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
           [text data  x  y ]
           ]
         ; [printf "Hover:~a id:~a mouse-event:~a\n" hover? [assoc 'id attribs] [mouse-event state]]
                                
         [when hover?
           [when [assoc 'id attribs]
             [when [equal? [mouse-event state] 'release]
               [let [[pair [assoc 'x attribs]]]
                 [printf ""]
                 ;[set-mcdr! pair [list x]] ;Set window coords here
                 ]
               ]]]
         
         [list
          [list x y x2 y2]
          [set-attrib 'y y [set-attrib 'x x attribs]]
          [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                              [set-state 'nextx  [car [advancer x y x2  [+ y 22]]]
                                         [set-state 'nexty  [cadr [advancer x y x2  [+ y 22]]] state]] ]]]]


      
      [[equal? type "popup"] [begin
                               [list [list x y x y] attribs
                                     [set-state 'nextx [startx state]
                                                [set-state 'nexty [starty state] state]]]
                               ]]
      [[equal? type "container"][letrec [
                                         [x2 [+ x 100]]
                                         [y2 [ + y 100]]
                                         [nextPos  [list x y]]
                                         [hover? [inside? mouse-x mouse-y x y x2 y2]]
                                         ]
                                  [fill 255]
                                  [stroke 0 0 0 255]
                                  [rect x y  100 100]
                                  [text-size 11]
                                  [fill 0]
                                  [text data x y 100 100 ]
                                  [list [list x y x2 y2] attribs
                                   
                                        [set-state 'nextx [car nextPos] [set-state 'nexty [cadr nextPos] state] ]]]]
      [else [list parent-bounds attribs state]]
    
  
      ]
      
    ]

  ]

;find the smallest box that covers both bounding boxes
[define [merge-bounds b1 b2]
  [list
   [if [> [first b1] [first b2]] [first b1] [first b2]]
   [if [> [second b1] [second b2]] [second b1] [second b2]]
   [if [> [third b1] [third b2]] [third b1] [third b2]]
   [if [> [fourth b1] [fourth b2]] [fourth b1] [fourth b2]]
   ]
  ]

;draw the children for a widget
;returns [list new-widget-tree state bounds]
;
; new-widget-tree - a widget tree, possibly identical to the input tree
; state - the ephemeral state
; bounds - a box covering all of the rendered children
[define [map-children children state parent-bounds]
  ;[printf "Child list: ~a~n" children]
  [let [[out-bounds parent-bounds]]
    [let [[new-widget-tree  [map [lambda [c]
                                   ;[printf "Mapping ~a~n" [second c]]
                                   [letrec [[alist [walk-widget-tree c state parent-bounds]]
                                            [new-widget [car alist]]
                                            [new-state [cadr alist]]
                                            [new-bounds [caddr alist]]]
                                     [set! new-bounds [merge-bounds new-bounds out-bounds]]
                                     [set! state new-state]
                                     new-widget
                                     ]] children]]]
      ;[printf "Returning children: ~a~n" returns]
      [list new-widget-tree state out-bounds]
      ]]]

;walk the widget tree, drawing each widget from top down
[define [walk-widget-tree t state parent-bounds]
  ;[printf "Parsetree ~a~nState: ~a~n~n" t state]
  [letrec [
           [ data [cadr t]]
           [attribs [cddr t]]
           [type [cadr [assoc 'type attribs]]]
           [children [assoc 'children attribs]]
           ]
    ;Used to enable/disable widgets
    [if [want-to-render? t state]
        ;first, render the current widget
        [letrec [[alist [render data type attribs children t state parent-bounds]]
                 [new-parent-bounds [car alist]]
                 [new-attribs [cadr alist]]
                 [advancer [s= advancer state]]
                 [nextPos  [apply advancer new-parent-bounds]]
                 [new-state [set-state 'mx [car nextPos] [set-state 'my [cadr nextPos] [caddr alist]]]]
                 [children1 [assoc 'children new-attribs]]
                 [new-widget   [append `[w ,data ]  new-attribs]]
                 
                 ]
          ;If there are children, render them now
          [if children1
              ;Render them
              [letrec [[new-alist [map-children [cdr children1] new-state new-parent-bounds]]
                       [new-children [car new-alist]]
                       [new-state1 [cadr new-alist]]
                       [new-child-bounds [caddr new-alist]]
                       [new-new-attribs [delete-duplicates [cons [cons 'children new-children]   new-attribs] [lambda [x y] [equal? [car x] [car y]]]]]
                       [new-new-widget   [append `[w ,data ]  new-new-attribs]]]
                ;[printf "~nNew widget ~a~nNew state: ~a~nNew children ~a~n~n" new-new-widget new-state1 new-children]
      
         
            
                [set! new-state1 [new-advancer [car [s=f advancer attribs '[#f #f]]] new-child-bounds new-state1]]
                [list new-new-widget new-state1 new-child-bounds]]
              [begin
                [set! new-state [new-advancer [car [s=f advancer attribs '[#f #f]]] new-parent-bounds new-state]]
                [list t new-state new-parent-bounds]
                ]]] ;FIXME use new attributes
        [list t state [list 0 0 0 0]] ;FIXME process mouse events without render
        ]]]



(size 800 600) 

;Handle sketch input events
[define [on-mouse-pressed]
  [set! persist-mouse-event 'press]]

[define [on-mouse-released]
  [set! persist-mouse-event 'release]
  [displayln "Mouse button released"]]
  
(define (draw)

  ;clear the window
  [background 255]

  [letrec [[alist [walk-widget-tree  m `[[nextx . 0]
                                         [nexty . 0]
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
                                         [advancer . ,vertical-advancer]
                                         [drag-target . ,[s= drag-target last-state]]
                                         [dragvecx . ,[- mouse-x [startx last-state]]]
                                         [dragvecy . ,[- mouse-y [starty last-state]]] ;Total drag vector, x and y
                                         ]
                                     [list 0 0 0 0]]]
           [new-state [cadr alist]]
           [new-template [car alist]]
           ]
                                         
    [set! last-state new-state]
    [set! m new-template] ]
  ;[printf "New state: ~a~n" last-state]
  [if mouse-pressed  
      [set! button-down #t]
      [set! button-down #f]]

  
                  

                     

  [set! persist-mouse-event #f]
  
  )