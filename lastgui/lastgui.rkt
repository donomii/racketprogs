
[module lastgui racket
  [provide set-display-tree! set-draw-funcs! horizontal-advancer vertical-advancer  walk-widget-tree startx starty]
  (require srfi/1)
  [require (file "./spath.rkt")]


  ;lastgui is an experiment in creating a portable, simple, and useful gui.  To achieve this, lastgui is a library, not a framework.  The surrounding program
  ;provides a window, the draw routines and a description of the gui, and lastgui renders onto the canvas provided.  Input is collected by the program using
  ;whatever native libraries, then passed into lastgui to be processed.

  ;In order to actually make progress, I'm focussing on simple, effective solutions rather than complex complete solutions.  So lastgui contains significantly fewer features
  ;and less polish than other toolkits.

  ;Lastgui is not specifically a immediate or delayed mode gui, the best way to put it might be "state separated".  The widget tree defines the layout, and usually doesn't change
  ;(unless you change the layout by dragging a window or something else).  The state variable holds the between-frames state - mouse clicks and movements, drag state, etc.  It is
  ;recreated on every frame, sometimes using data from the previous state.

 

  [define draw-funcs '[]]
  [define [set-draw-funcs! funcs]
    [set! draw-funcs funcs]]
  [define [df name]
    [cdr [assoc name draw-funcs ]]]
  ;[error [format "~a not defined in ~a" name draw-funcs]]
  [define display-tree '[]]

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
  [define [get-attribs x] [cddr x]]

  ;The advancers.  At the moment, layout is performed by specifying which side of the current widget to draw the next widget on.
  [define [vertical-advancer x y x2 y2] [list x y2]]
  [define [horizontal-advancer x y x2 y2] [list x2 y]]
  [define [new-advancer name bounds state]
    ;[when name
    ;[printf "Advancer: ~a Bounds: ~a~n" name bounds]]
    [let [[res
           [if [procedure? name]
               [let [[nextPos  [name  [first bounds]  [second bounds]  [third bounds]   [fourth bounds]]]]
                 [set-state 'nextx [car nextPos] [set-state 'nexty [cadr nextPos] state]]]
           [cond
                 ;Place the next widget under the title bar
                 [[equal? name 'window][set-state 'nextx [first bounds] [set-state 'nexty [+ 22 [second bounds]] state]]]
                 ;Place the next widget to the top right of the current one
                 [[equal? name 'horizontal][set-state 'nextx [third bounds] [set-state 'nexty [second bounds] state]]]
                 ;Place the next widget to the bottom left of the current one
                 [[equal? name 'vertical][set-state 'nextx [first bounds] [set-state 'nexty [fourth bounds] state]]]
                 [else state]
      
                 ]]]]
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

 
  ;helper function to add to the attribs conslist
  [define [set-attrib key value attribs]
    [delete-duplicates [cons  [list key value] attribs] ;Can't use alist-cons here because attribs isn't a proper conslist
                       [lambda [x y] [equal? [car x] [car y]]]]]

  ;helper function to add to the state conslist
  [define [set-state key value attribs]
    [cons [cons key value] attribs]]

  ;helper function to add to the downstate conslist
  [define [set-downstate key value attribs]
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


  ;the main render routine, is responsible for putting the graphics on the canvas
  ;returns [list bounds attribs state]
  ;
  ; bounds - a bounding box for the last draw operation
  ; attribs - the attributes for the current widget, including things like position, scroll position, and widget state
  ; state - the ephemeral state
  [define [render data type attribs children t state parent-bounds downstate]
  ;  [printf "Rendering widget: ~a~nState: ~a~n" type state]

    [letrec [
             [disabled [s=f disabled downstate #f]]
             [mouse-x [mx state]]
             [mouse-y [my state]]
             [x [nx state]]
             [y  [ny state]]
             [id [s=f id attribs #f]]
             [font-size 11]
             [w [if [s=f w attribs #f] [car [s= w attribs]] [* font-size [string-length data]]]]
             [h [if [s=f h attribs #f] [car [s= h attribs]] [* font-size 2]]]
             [expansion-factor [car [s=f expand attribs '[0]]]]
             [resizing? [s=f resizing downstate #f]]             
             [advancer [car [s=f advancer attribs [list [s=f advancer state #f]]]]]

              [x2 [+ x  [max [car [s=f min-w attribs '[50]]] [+ w [if resizing? [* expansion-factor [s= dragvecx state]] 0]]]]]
              [y2 [+ y  [max [car [s=f min-h attribs '[50]]] [+ h [if resizing? [* expansion-factor [s= dragvecy state]] 0]]]]]
              ;[x2 [+ x   [max [+ w [if resizing? [* expansion-factor [s= dragvecx state]] 0]] 50]]]
              ;[y2 [+ y [max  [+ h   [if resizing? [* expansion-factor [s= dragvecy state]] 0]] 50]]]
              [hover? [inside? mouse-x mouse-y x y x2 y2]]
             ]
    
      ;[when [not id] [error [format "Error:  No id found for widget ~a~n" t]]]
    
      [cond
        [[equal? type "toplevel"][letrec [
                                      
                                  
                                      [dragging? [and [button-down? state] [equal? [s= drag-target state] [s= id attribs]]]]
                                      
                                     [dx [if dragging? [+ x [s= dragvecx state]] x]]
                                     [dy [if dragging? [+ y [s= dragvecy state]] y]]
                                     
                                     
                                      ]
                             
                                 [when [and dragging? [equal? [mouse-event state] 'release]]
                                   [set! x  dx][set! y dy]
                                   [printf "Setting x ~a y ~a dvx ~a dvy ~a ~n" x y [s= dragvecx state] [s= dragvecy state]]
                                   ]
                               [when dragging?
                               [[df 'rect] dx dy w h 5]
                              ]
                               [list
                                [list dx dy dx dy]
                                downstate
                                [set-attrib 'h h [set-attrib 'w w [set-attrib 'y [if [and dragging? [equal? [mouse-event state] 'release]] dy y] [set-attrib 'x [if [and dragging? [equal? [mouse-event state] 'release]] dx x]  attribs]]]]
                                [set-drag-target-if [equal? [mouse-event state] 'press] id
                                                    [new-advancer 'vertical [list dx dy dx dy] state] ]]]]
        [[equal? type "text"][letrec [
                                      
                                    
                                      
                                     
                                      ]
                               [when resizing?
           
                                 [when [equal? [mouse-event state] 'release]
                                   [set! w  [- x2 x]][set! h [- y2 y]]
                                   [printf "Setting w ~a h ~a dvx ~a dvy ~a ~n" w h [s= dragvecx state] [s= dragvecy state]]
                                   ]]
                               [[df 'fill] 255 255 255 255]
                               [[df 'stroke] 0 0 0 255]
                               [[df 'rect] x y [- x2 x] [- y2 y] 5]
                               [[df 'text-size] font-size]
                               [[df 'fill] 0 0 0 0]
                               [[df 'text-align] 'center 'center]
                               [[df 'text] [if [procedure? data] [format "~a"[data]] [format "~a" data]] x [+ y [/ [- y2 y]3]] [- x2 x] [- y2 y] ]
                               [list
                                [list x y x2 y2]
                                downstate
                                [set-attrib 'h h [set-attrib 'w w [set-attrib 'y y [set-attrib 'x x attribs]]]]
                                [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                                                    [new-advancer advancer [list x y x2 y2] state] ]]]]
         [[equal? type "list"][letrec [
                                      
                                    
                                     
                                     [new-children [map [lambda [x] `[ w ,[format "~a" [car x]] [id ,x] [type "button"] [w ,w] [h 20]]] data]]
                                      ]
                               [when resizing?
           
                                 [when [equal? [mouse-event state] 'release]
                                   [set! w  [- x2 x]][set! h [- y2 y]]
                                   [printf "Setting w ~a h ~a dvx ~a dvy ~a ~n" w h [s= dragvecx state] [s= dragvecy state]]
                                   ]]
                               [[df 'fill] 255 255 255 255]
                               [[df 'stroke] 0 0 0 255]
                               [[df 'rect] x y [- x2 x] [- y2 y] 5]
                               [[df 'text-size] font-size]
                               [[df 'fill] 0 0 0 0]
                               [[df 'text-align] 'center 'center]
                               ;[[df 'text] [if [procedure? data] [format "~a"[data]] [format "~a" data]] x [+ y [/ [- y2 y]3]] [- x2 x] [- y2 y] ]
                               ; [displayln [alist-cons 'children new-children [set-attrib 'h h [set-attrib 'w w [set-attrib 'y y [set-attrib 'x x attribs]]]]]]
                               [list
                                [list x y x2 y2]
                                downstate
                               [alist-cons 'children new-children[set-attrib 'h h [set-attrib 'w w [set-attrib 'y y [set-attrib 'x x attribs]]]]]
                                [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                                                    [set-state 'nextx x [set-state 'nexty y state] ]]]]]
        [[equal? type "button"] [letrec [
                                      
                                         [x2 [+ x w]]
                                         [y2 [ + y h]]
                                         [hover? [inside? mouse-x mouse-y x y x2 y2]]]
                                  
                                  [when [and [do-draw state] [not disabled]]
                                    [if hover?
                                        [[df 'fill] 128 128 128 255]
                                        ([df 'fill] 255 255 255 0)
                                    
                                        ]
                                    [[df 'stroke] 0 0 0 255]
                                    [[df 'rect] x y  w   h 5]
                                    [[df 'text-size] font-size]
                                    [[df 'fill] 0 0 0 255]
                                    [[df 'text-align] 'center 'center]
                                    [[df 'text] data x y w h]
                                    ]
                                  ;[printf "Hover:~a id:~a mouse-event:~a drag-target:~a is drag-target:~a\n" hover? [s= id attribs] [mouse-event state] [s= drag-target state][equal? [s= drag-target state] [s= id attribs]]]
                                  [when hover?
                                  
                                    [when [equal? [s= drag-target state] [s=f id attribs #f]]
                                      [when [equal? [mouse-event state] 'release]
                                        [set! attribs [[df 'button-click]   [car [s=f id attribs '["You forgot to set an ID for this button"]]] t attribs]]
                                        ]]]
                                  [list [list x y x2 y2]
                                        downstate
                                        attribs
                                        [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                                                           [new-advancer advancer [list x y x2 y2] state ] ]]]]
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
                  [x2 [+ x  [max [car [s=f min-w attribs '[50]]][if resizing? [+ w [s= dragvecx state]] w]]]]
                  [y2 [+ y  [max [car [s=f min-h attribs '[50]]][if resizing? [+ h [s= dragvecy state]] h]]]]
                  [font-size 11]
                  [hover? [inside? mouse-x mouse-y x y x2 y2]]
                  [resize-hover? [inside? mouse-x mouse-y [- x2 font-size] [- y2 font-size] x2 y2]]
                  ]
           [when [do-draw state]
             [if [or resizing? dragging?]
                 [[df 'stroke] 255 128 128 255]
                 [[df 'stroke] 0 0 0 255]]
             [[df 'fill] 255 255 255 255]
             [[df 'rect] x y  [- x2 x] [- y2 y] 5]
             [[df 'text-size] font-size]
             [[df 'fill] 0 0 0 0]
             [[df 'text-align] 'center 'center]
             [[df 'text] data  [+ x font-size]  y [- x2 x]  [- y2 y] ]
             [[df 'fill] 0 0 0 0]
             [[df 'rect] [- x2 font-size] [- y2 font-size] font-size font-size 5]
             [[df 'rect] x y font-size font-size 5]
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
            [set-downstate 'resizing resizing? downstate]
            [set-attrib 'h h [set-attrib 'w w [set-attrib 'y y [set-attrib 'x x attribs]]]]
            [set-resize-target-if [and resize-hover? [equal? [mouse-event state] 'press]] id
                                  [set-drag-target-if [and hover? [equal? [mouse-event state] 'press]] id
                                                      [new-advancer advancer [list x y x2  [+ y [* 2 font-size]]] state]] ]]]]


      
        [[equal? type "popup"] [begin
                                 [list [list x y x y]
                                       [alist-cons 'disabled [s=f drag-target state #f] downstate] attribs
                                     
                                       [set-state 'nextx [startx state]
                                                  [set-state 'nexty [starty state] state]]]
                                 ]]
        [[equal? type "container"][letrec [
                                           [x2 [+ x   [max [+ w [if resizing? [* expansion-factor [s= dragvecx state]] 0]] 50]]]
                                           [y2 [+ y [max  [+ h   [if resizing? [* expansion-factor [s= dragvecy state]] 0]] 50]]]
                                           [nextPos  [list x y]]
                                           [hover? [inside? mouse-x mouse-y x y x2 y2]]
                                           ]
                                    [when resizing?
                                      [when [equal? [mouse-event state] 'release]
                                        [set! w  [- x2 x]][set! h [- y2 y]]
                                        [printf "Setting w ~a h ~a dvx ~a dvy ~a ~n" w h [s= dragvecx state] [s= dragvecy state]]
                                        ]]
                                    [[df 'fill] 255 255 255 255]
                                    [[df 'stroke] 0 0 0 255]
                                    [[df 'rect] x y [- x2 x] [- y2 y] 5]
                                    [[df 'text-size] 11]
                                    [[df 'fill] 0 0 0 0]
                                    ;[[df 'text] data x y [- x2 x] [- y2 y] ]
                                    [list [list x y x2 y2] downstate [set-attrib 'h h [set-attrib 'w w [set-attrib 'y y [set-attrib 'x x attribs]]]]
                                   
                                          [set-state 'nextx [car nextPos] [set-state 'nexty [cadr nextPos] state] ]]]]
        [else [list parent-bounds downstate attribs state]]
    
  
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
  [define [map-children children state parent-bounds downstate]
    ;[printf "Child list: ~a~n" children]
    [let [[out-bounds parent-bounds]]
      [let [[new-widget-tree  [map [lambda [c]
                                     ;[printf "Mapping ~a~n" [second c]]
                                     [letrec [[alist [walk-widget-tree c state parent-bounds downstate]]
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

  [define [get-child-pressures children]
    [letrec [[pressures [map [lambda [c] [car [s=f pressures [get-attribs c] '[1]]] children]]]
             [total [fold + 0 pressures]]
             [percentages [map [lambda [c] [/ c total]]]]]
      percentages
      ]]

  ;walk the widget tree, drawing each widget from top down
  [define [walk-widget-tree t state parent-bounds downstate]
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
          [letrec [[alist [render data type attribs children t state parent-bounds downstate]]
                   [new-parent-bounds [car alist]]
                   [new-downstate [cadr alist]]
                   [new-attribs [caddr alist]]
                   [advancer [s= advancer state]]
                   ;[nextPos  [apply advancer new-parent-bounds]]
                   ; ;[new-state [new-advancer [car [s=f advancer new-attribs '[#f #f]]] new-parent-bounds [cadddr alist]]]
                   ;[new-state [set-state 'nx [car nextPos] [set-state 'ny [cadr nextPos] [cadddr alist]]]]
                   [new-state [cadddr alist]]
                   [children1 [assoc 'children new-attribs]]
                   [new-widget   [append `[w ,data ]  new-attribs]]
                 
                   ]
            ;If there are children, render them now
            [if children1
                ;Render them
                [letrec [[new-alist [map-children [cdr children1] [new-advancer [car [s=f child-advancer new-attribs '[#f #f]]] new-parent-bounds new-state] new-parent-bounds new-downstate]]
                         [new-children [car new-alist]]
                         [new-state1 [cadr new-alist]]
                         [new-child-bounds [caddr new-alist]]
                         [new-new-attribs [delete-duplicates [cons [cons 'children new-children]   new-attribs] [lambda [x y] [equal? [car x] [car y]]]]]
                         [new-new-widget   [append `[w ,data ]  new-new-attribs]]]
                  ;[printf "~nNew widget ~a~nNew state: ~a~nNew children ~a~n~n" new-new-widget new-state1 new-children]
                  [set! new-parent-bounds [merge-bounds new-child-bounds new-parent-bounds]]
         
            
                  [set! new-state1 [new-advancer [car [s=f advancer attribs '[#f #f]]] [if [s=f discard-child-position new-attribs '[#f]] new-parent-bounds new-child-bounds] new-state1]]
                  [list new-new-widget new-state1 new-child-bounds]]
                [begin
                  ;[set! new-state [new-advancer [car [s=f advancer attribs '[#f #f]]] new-parent-bounds new-state]]
                  [list [append `[w ,data ]  new-attribs] new-state new-parent-bounds]
                  ]]] ;FIXME use new attributes
          [list t state [list 0 0 0 0]] ;FIXME process mouse events without render
          ]]]




                                                           
  ]
