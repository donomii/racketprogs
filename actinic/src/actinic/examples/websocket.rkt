#lang racket

(require "actinic/src/actinic/actinic.ss")
[require srfi/1]
(require net/rfc6455)

 [letrec [[ports (websocket "ws://rockets.cc:3210/")]]
                                              [displayln ports]
   [display [format "~a~a" #\return #\linefeed] [second ports]]
   [display "{\"channel\": \"test\",\"filters\": {\"subreddit\": [ \"space\", \"news\" ] } }"
     
     [second ports]]
   [display [format "~a~a" #\return #\linefeed] [second ports]]
   [display [format "~a~a" #\return #\linefeed] [second ports]]
   [flush-output [second ports]]
                                                  [true [map [lambda [x] [let  [[b [read-bytes 1 [first ports]]]]
                                                                          [when [not [eof-object? b]]
                                                                            [display b]]]] [iota 10000]]]]
                                                
 
 