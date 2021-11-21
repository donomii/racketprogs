#lang sketching
(require racket/match
         web-server/http
         web-server/servlet-dispatch
         web-server/web-server)
 (require web-server/http/request-structs)
 (require web-server/http/bindings)

(define age [lambda [x]
              (displayln (request-bindings x))(response/full 200 #"alalala" 0 #f '() '(#"ok"))])

(define stop
  (serve
   #:dispatch (dispatch/servlet age)
   #:listen-ip "127.0.0.1"
   #:port 8000))