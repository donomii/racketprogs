
[module lastgui racket
[provide set-display-tree! set-draw-funcs! horizontal-advancer vertical-advancer  walk-widget-tree startx starty]
  (require srfi/1)
  [require (file "./spath.rkt")]


  ;lastgui is an experiment in creating a portable, simple, and useful gui.  To achieve this, lastgui is a library, not a framework.  The surrounding program
  ;provides a window, the draw routines and a description of the gui, and lastgui renders onto the canvas provided.  Input is collected by the program using
  ;whatever native libraries, then passed into the gui to be processed.

  ;In order to actually make progress, I'm focussing on simple, effective solutions rather than complex complete solutions.  So lastgui contains significantly fewer features
  ;and less polish than other toolkits.

  ;Lastgui is not specifically a immediate or delayed mode gui, the best way to put it might be "state separated".  The widget tree defines the layout, and usually doesn't change
  ;(unless you change the layout by dragging a window or something else.  The state variable holds the ephemeral state - mouse clicks and movements, drag state, etc.  It is
  ;recreated on every frame, sometimes using data from the previous state.

  ;The state variable is effectively global for this module

;  
;[define fill #f]
;  [define stroke #f]
;  [define rect #f]
;  [define text-size #f]
;  [define text #f]per
;  [define text-align #f]
;  [define size #f]
;  [define background #f]
;  [define mouse-x #f]
;  [define mouse-y #f]
;[define mouse-pressed #f]

  [define draw-funcs '[]]
  [define [set-draw-funcs! funcs]
    [set! draw-funcs funcs]]
  [define [df name]
    [cdr [assoc name draw-funcs ]]]
;[error [format "~a not defined in ~a" name draw-funcs]]
  [define display-tree '[w "toplevel" [id "Toplevel container"] [type "toplevel"]
                [children
                 [w "A Test Window" [id "Test window"] [type "window"] [x 50] [y 50] [w 200] [h 200] [advancer window]
                    [children
                     [w "A big container" [type "container"] [advancer vertical] [children
                                                                                  [w "A h1container" [type "container"] [advancer vertical][children
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

  [define [set-display-tree! tree]
[set! display-tree tree]
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
    ;[when name
    ;[printf "Advancer: ~a Bounds: ~a~n" name bounds]]
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





  ;is mx, my inside the box x1,y1-x2,y2
  [define [inside? mx my x1 y1 x2 y2]
    [and
     [and [> mx x1] [< mx x2]]
     [and [> my y1] [< my y2]]
     ]]





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

    ;example button callback
  [define [button-click id]
    [printf "Clicked on button: ~a~n" id]
    [exit 0]
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

  ;helper, sets drag state to id-resize if conditions are met
  [define [set-resize-target-if hover? id state]
    [let [[resize-id [format "~a-resize" id]]]
      [if hover?
          [set-state 'drag-target resize-id state]
          state]]]

  ;Tey:  on window drag, propogate the drag amount down and let sub-widgets add it to their size.



  ;the main render routine, is responsible for putting the graphics on the canvas
  ;returns [list bounds attribs state]
  ;
  ; bounds - a bounding box for the last draw operation
  ; attribs - the attributes for the current widget, including things like position, scroll position, and widget state
  ; state - the ephemeral state
  [define [render data type attribs children t state parent-bounds]
    ;[printf "Rendering ~a~nState: ~a~n" type state]

    [letrec [[mouse-x [mx state]]
             [mouse-y [my state]]
             [x [nx state]]
             [y  [ny state]]
             [id [s=f id attribs #f]]
             [font-size 11]
             [w [if [s=f w attribs #f] [car [s= w attribs]] [* font-size [string-length data]]]]
             [h [if [s=f h attribs #f] [car [s= h attribs]] [* font-size 2]]]
                                   
             [advancer [s=f advancer state #f]]]
    
      ;[when [not id] [error [format "Error:  No id found for widget ~a~n" t]]]
    
      [cond
        [[equal? type "text"][letrec [
                                    
                                      [x2 [+ x w]]
                                      [y2 [ + y h]]
                                      [nextPos  [advancer x y x2  y2]]
                                      [hover? [inside? mouse-x mouse-y x y x2 y2]]
                                      ]
                               [[df 'fill] 255]
                               [[df 'stroke] 0 0 0 255]
                               [[df 'rect] x y w h]
                               [[df 'text-size] font-size]
                               [[df 'fill] 0]
                               [[df 'text] data x y w h ]
                               [list [list x y x2 y2] attribs
                                     [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                                                         [set-state 'nextx [car nextPos] [set-state 'nexty [cadr nextPos] state] ]]]]]
        [[equal? type "button"] [letrec [
                                      
                                         [x2 [+ x w]]
                                         [y2 [ + y h]]
                                         [nextPos  [advancer x y x2  y2]]
                                         [hover? [inside? mouse-x mouse-y x y x2 y2]]]
                                  [when [do-draw state]
                                    [if hover?
                                        [[df 'fill] 128 128 128 255]
                                        ([df 'fill] 255 255 255 0)
                                    
                                        ]
                                    [[df 'stroke] 0 0 0 255]
                                    [[df 'rect] x y  w   h]
                                    [[df 'text-size] font-size]
                                    [[df 'fill] 0]
                                    ([df 'text-align] 'center)
                                    [[df 'text] data x y w h]
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
                  [resizing? [and [button-down? state] [equal? [s= drag-target state] [format "~a-resize" [s= id attribs]]]]]
                  [orig-x [cadr[assoc 'x attribs]]]
                  [orig-y [cadr [assoc 'y attribs]]]
                  [x [if dragging?  mouse-x  orig-x]]
                  [y  [if dragging? mouse-y  orig-y]]
                  [attrib-w [car [s=f w attribs '[50]]]]
                  ;[w [if resizing? [+ attrib-w [s= dragvecx state]] attrib-w]]
                  [w attrib-w]
                  [h [car [s=f h attribs '[50]]]]
                  [x2 [+ x  [if resizing? [+ w [s= dragvecx state]] w]]]
                  [y2 [+ y  [if resizing? [+ h [s= dragvecy state]] h]]]
                  [font-size 11]
                  [hover? [inside? mouse-x mouse-y x y x2 y2]]
                  [resize-hover? [inside? mouse-x mouse-y [- x2 font-size] [- y2 font-size] x2 y2]]
                  ]
           [when [do-draw state]
             [if hover?
                 [[df 'stroke] 255 128 128 255]
                 [[df 'stroke] 0 0 0 255]]
             [[df 'fill] 255]
             [[df 'rect] x y  [- x2 x] [- y2 y]]
             [[df 'text-size] font-size]
             [[df 'fill] 0]
             ([df 'text-align] 'center)
             [[df 'text] data  [+ x font-size]  y [- x2 x]  [- y2 y] ]
             [[df 'fill] 0]
             [[df 'rect] [- x2 font-size] [- y2 font-size] font-size font-size ]
             [[df 'rect] x y font-size font-size ]
             ]
           ; [printf "Hover:~a id:~a mouse-event:~a\n" hover? [assoc 'id attribs] [mouse-event state]]
                                
           [when resize-hover?
             [when [assoc 'id attribs]
               [when [equal? [mouse-event state] 'release]
                 [set! w  [- x2 x]][set! h [- y2 y]]
                 [set! resize-hover? #f]
                 ]]]
         
           [list
            [list x y x2 y2]
            [set-attrib 'h h [set-attrib 'w w [set-attrib 'y y [set-attrib 'x x attribs]]]]
            [set-resize-target-if [and resize-hover? [equal? [mouse-event state] 'press]] id
                                  [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                                                      [set-state 'nextx  [car [advancer x y x2  [+ y [* 2 font-size]]]]
                                                                 [set-state 'nexty  [cadr [advancer x y x2  [+ y [* 2 font-size]]]] state]] ]]]]]


      
        [[equal? type "popup"] [begin
                                 [list [list x y x y] attribs
                                       [set-state 'nextx [startx state]
                                                  [set-state 'nexty [starty state] state]]]
                                 ]]
        [[equal? type "container"][letrec [
                                           [horiz-expand? [s=f horiz-expand attribs #f]]
                                           [bounds [if horiz-expand? [merge-bounds-horiz [list x y [+ x w] [+ y h]]  parent-bounds] [list x y [+ x w] [+ y h]] ]]
                                           [x2 [third bounds]]
                                           [y2 [ + y 100]]
                                           [nextPos  [list x y]]
                                           [hover? [inside? mouse-x mouse-y x y x2 y2]]
                                           ]
                                    [[df 'fill] 255]
                                    [[df 'stroke] 0 0 0 255]
                                    [[df 'rect] x y  100 100]
                                    [[df 'text-size] 11]
                                    [[df 'fill] 0]
                                    [[df 'text] data x y 100 100 ]
                                    [list [list x y x2 y2] attribs
                                   
                                          [set-state 'nextx [car nextPos] [set-state 'nexty [cadr nextPos] state] ]]]]
        [else [list parent-bounds attribs state]]
    
  
        ]
      
      ]

    ]

  ;find the smallest box that covers both bounding boxes
  [define [merge-bounds b1 b2]
    [list
     [if [< [first b1]  [first b2]]  [first b1]  [first b2]]
     [if [< [second b1] [second b2]] [second b1] [second b2]]
     [if [> [third b1]  [third b2]]  [third b1]  [third b2]]
     [if [> [fourth b1] [fourth b2]] [fourth b1] [fourth b2]]
     ]
    ]

  ;find the smallest box that covers both bounding boxes horizontally
  [define [merge-bounds-horiz b1 b2]
    [list
     [if [< [first b1]  [first b2]]  [first b1]  [first b2]]
     [second b1]
     [third b2]
     [fourth b2]
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
                                       ;[printf "Merging old bounds ~a with ~a (~a)" out-bounds  [cddr  new-widget] new-bounds]
                                       [set! new-bounds [merge-bounds new-bounds out-bounds]]
                                       [set! out-bounds [merge-bounds new-bounds out-bounds]]
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
                   [new-state [set-state 'nx [car nextPos] [set-state 'ny [cadr nextPos] [caddr alist]]]]
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
                  [set! new-parent-bounds [merge-bounds new-child-bounds new-parent-bounds]]
         
            
                  [set! new-state1 [new-advancer [car [s=f advancer attribs '[#f #f]]] new-child-bounds new-state1]]
                  [list new-new-widget new-state1 new-child-bounds]]
                [begin
                  [set! new-state [new-advancer [car [s=f advancer attribs '[#f #f]]] new-parent-bounds new-state]]
                  [list t new-state new-parent-bounds]
                  ]]] ;FIXME use new attributes
          [list t state [list 0 0 0 0]] ;FIXME process mouse events without render
          ]]]





  ]