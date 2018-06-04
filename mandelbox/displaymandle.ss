#lang scheme
[require [file "mandlebox.ss"]]
[require scheme/gui]
[in-mandlebox? 0 0 0 4 100]
; Make a 300 x 300 frame
(define frame (new frame% [label "Mandelbox"]
                   [width 300]
                   [height 300]))
; Make the drawing area
(define canvas (new canvas% [parent frame]))
; Get the canvas's drawing context
(define dc (send canvas get-dc))
  
; Make some pens and brushes
(define no-pen (make-object pen% "BLACK" 1 'transparent))
(define no-brush (make-object brush% "BLACK" 'transparent))
(define blue-brush (make-object brush% "BLUE" 'solid))
(define yellow-brush (make-object brush% "YELLOW" 'solid))
(define red-pen (make-object pen% "RED" 2 'solid))
  
; Define a procedure to draw a mandelbox

  
; Show the frame
(send frame show #t)
; Wait a second to let the window get ready
(sleep/yield 1)
[define [plot dc n scale]
  [map [lambda [x] 
         [map [lambda [y]
                [if [in-mandlebox? [/ [- x [round [/ n 3]]] scale]  [/ [ - y [round [/ n 3]]] scale] 0.15 5 100]
                    #f
                    [send dc draw-point x y]]]
              [build-list n values]]
         ]
       [build-list n values]]
  #t]
                        
; Draw the mandelbox
(plot dc [expt 2 8] [expt 2 7])