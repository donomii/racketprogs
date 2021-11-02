#lang racket
(require net/http-easy)
(require (prefix-in  srfi_ srfi/1 ))

[require "lastgui.rkt"]
[require "spath.rkt"]
[require "parse.rkt"]

(require racket/match
         web-server/servlet-dispatch
         web-server/web-server)
(require (prefix-in  crap_ web-server/http/response-structs))
(require web-server/http/request-structs)
(require web-server/http/bindings)

(define age [lambda [req] 

              ;[displayln (cdr (assq 'x (request-bindings req)))]
              [displayln (request-bindings req)]
              [draw
               [string->number (cdr (assq 'x (request-bindings req)))]
               [string->number (cdr (assq 'y (request-bindings req)))]
               (cdr (assq 'action (request-bindings req)))]
              (crap_response/full
               301 #"Moved Permanently"
               (current-seconds) #"text/html; charset=utf-8"
               (list (make-header #"Location"
                                  #"http://racket-lang.org/download"))
               (list #"<html><body><p>"
                     #"Please go to <a href=\""
                     #"http://racket-lang.org/download"
                     #"\">here</a> instead."
                     #"</p></body></html>"))

              ])

[displayln "Starting webserver"]
(define stop
   
  (serve
   #:dispatch (dispatch/servlet age)
   #:listen-ip "127.0.0.1"
   #:port 8081))



;(with-handlers ([exn:break? (lambda (e)
;                              (stop))])
;  (sync/enable-break never-evt))
[displayln "Webserver started"]
[define frame-count 0]
[define last-frame-count 0]
[define last-frame-time (current-inexact-milliseconds) ]
[define my-frame-rate 0]
[define frame-rate 0]

[define file-list [directory-list]]

[define m `

  [w "toplevel" [id "Toplevel container"] [type "toplevel"][dropzone #t]  [x 0] [y 0][draggable #t]
     [children
      [w "Program" [id "Program button"][detached #t][draggable #t][advancer horizontal] [x 10] [y 10] [w 50] [h 50][type "button"] [extra-data  null ]] ;,[parse-go]]]
      [w "A Test Window" [id "Test window"][dropzone #t] [draggable #t][type "window"] [x 500] [y 500] [w 200] [h 200] [min-w 200][min-h 200][advancer window]
         [children
                   
          [w "A big container" [type "container"] [advancer vertical][w 200] [children
                                                                              [w "A h1container" [type "container"] [w 100] [min-w 100][expand 0.5] [advancer horizontal][children
                                                                                                                                                                          [w ,[lambda [] [format "Frame rate: ~a" [round frame-rate]]]
                                                                                                                                                                             [id "test text"] [type "text"][min-w 100][w 100] [h 100][expand 0.5][advancer vertical]]
                                                                                                                                                                          [w "OK" [id "ok button"] [type "button"][advancer vertical]]]]
                                                                              [w "A h2container" [type "container"] [w 100] [min-w 100][expand 0.5][advancer horizontal][children
                                                                                                                                                                         [w "Dump widgets"
                                                                                                                                                                            [id "DumpWidgetsLabel"][w 100][min-w 100] [h 100][expand 0.5] [type "text"]]
                                                                                                                                                                         [w "OK" [id "DumpWidgets"] [type "button"]]]]]]]
         ]
      [w "Another Test Window" [id "Another Test window"][dropzone #t]  [draggable #t][type "window"] [x 150] [y 150][min-w 300][min-h 200]  [w 300] [h 400]
         [children
          [w "A h2container" [type "container"] [w 100] [min-w 100][expand 0.5][advancer vertical][children
                                                                                                                      [w ,[map [lambda [x] [list x [format "dir/~a" x]]] file-list]
                                                                                                                         [type "list"][expand 1/3] [w 100][h 300][advancer horizontal]]
                                                                                                   [w [[1 1] [2 2] [3 3] [4 4]]
                                                                                                      [type "list"][expand 1/3] [w 100][h 300][advancer horizontal]]
                                                                                                   [w [[1 1] [2 2] [3 3] [4 4]]
                                                                                                      [type "list"] [expand 1/3][w 100][h 300][advancer horizontal]]]]
          [w "Quit" [id "exit"] [type "button"]]]]
                                                        
      ;              [w "menu" [id "Popup menu"] [type "popup"][children
      ;                                                         [w "Do thing" [type "button"] [id "do thing button"]]
      ;                                                         [w "Exit" [id "exit button"][type "button"]]]]

      ]]
             
  ]

;some more state
[define button-down #f]
[define persist-mouse-event #f]




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
[define [drop-handler onto obj]
  [printf "Dropped ~a onto ~a~n" obj onto]
  ]
[define background  (lambda(a b c d)(get (format "http://localhost:8080/command/background(~a,~a,~a,~a);" a b c d)))]
[define draw-funcs `[
                     [fill . ,(lambda(a b c d) (get (format "http://localhost:8080/command/fill(~a,~a,~a,~a);" a b c d)))]

                     [rect . ,(lambda(a b c d e) (get (format "http://localhost:8080/command/rectangle(~a,~a,~a,~a);" a b c d)))]
                     [stroke . ,(lambda(a b c d) (get (format "http://localhost:8080/command/stroke(~a,~a,~a,~a);" a b c d)))]
                     [text-size . ,(lambda(a) (get (format "http://localhost:8080/command/textsize(~a);" a )))]
                     [text . ,(lambda(a b c d e) (get (format "http://localhost:8080/command/text(`~a`,~a,~a,~a,~a);" a b c d e)))]
                     [text-align . ,(lambda(a b) a)] ;,(lambda(a b c d) (get (format "http://localhost:8080/command/stroke(~a,~a,~a,~a);" a b c d)))]]
                     [button-click . ,button-click]
                     [drop-callback . ,drop-handler]
                     ]]
[set-draw-funcs! draw-funcs]


(define (draw mouse-x mouse-y action)
  [when [equal? action "press"]
    [set! persist-mouse-event 'press]
    [set! button-down #t]]

  [when [equal? action "release"]
    [set! persist-mouse-event 'release]
    [set! button-down #f]]
  [set! frame-count [add1 frame-count]]
  [when [> [- (current-inexact-milliseconds)  last-frame-time] 1000]
    [set! frame-rate [* 1000 [/ [- frame-count last-frame-count] [- (current-inexact-milliseconds)  last-frame-time]]]]
    [set! last-frame-time (current-inexact-milliseconds) ]
    [set! last-frame-count frame-count]]
  ;clear the window
  (get (format "http://localhost:8080/immediate/clear"))
  [background 255 255 0 255]
   
  ;[when persist-mouse-event [printf "Mouse button: ~a~n" mouse-button]
  ;   [printf "Mouse position: ~a~n"[list mouse-x mouse-y]]]

  [letrec [[alist [do-frame
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
                                         
    [set! last-state [srfi_delete-duplicates  new-state [lambda [x y] [equal? [car x] [car y]]]]]
    [set! m new-template]
    ]
  
  
  
                  

                     

  [set! persist-mouse-event #f]
 
  
  
  ;[displayln (output-profile-results)]
  ;[displayln (get-profile-results)]
  
  )

(draw 0 0 'null)