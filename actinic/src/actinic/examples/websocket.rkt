#lang racket

(require "../actinic.ss")
[require srfi/1]
(require net/rfc6455)
(require net/http-client)



 [letrec [[ports (websocket "http://echo.websocket.org")]]
   ;[displayln ports]
   [display "Hello!" [second ports]]
   [display [format "~a~a" #\return #\linefeed] [second ports]]
   [display [format "~a~a" #\return #\linefeed] [second ports]]
   [flush-output [second ports]]

   ;Add frame handling
                        [map [lambda [x] [let  [[b [read-bytes 1 [first ports]]]]
                                                                          [when [not [eof-object? b]]
                                                                            [display b]]]] [iota 10000]]
   "done"
   ]
                                                
 
 