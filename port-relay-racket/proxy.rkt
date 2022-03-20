#lang racket/gui
(require db)
  ;(require (lib "string.ss"))
  (require (lib "string.ss" "srfi" "13"))
  (require (lib "selector.ss" "srfi" "1"))
  (require (lib "list.ss" "srfi" "1"))
  (require (lib "mzssl.ss" "openssl"))
  (require (lib "class.ss"))
  (require file/gunzip)
(require openssl)
[require [file "actinic/actinic.ss"]]
[define [debug text]
  ;[displayln text]
  #t]
[define possible-title "No title detected"]


;"biz" "addthis" "imageshack.us" "amazon"  "paypal" "doubleclick" "AdSense" "api.stats" "google_analytics"
[define banlist [list  "443" "https"]]
;[define banlist [list ]]

[define banned [lambda [hostname] [ormap [lambda [x] [regexp-match x hostname]] banlist]]]

[define no-thread [lambda [a-thunk] [a-thunk]]]
[define l [lambda args #t]]
;[define l [lambda args [displayln [apply format args]]]]
[define ll ;[lambda args #t]]
  [lambda args [displayln [apply format args]]]]
[define proxy-server [cons "www-proxy.ericsson.se" 8080]]

[define capture_traffic #t]
;[define log_dir "G:\\flv"]
[define log_dir [get-directory]]
[define sqlc (sqlite3-connect	 	#:database [format "~a\\~a" log_dir "cache.sqlite" ]	 
 		#:mode 'create
 	 	#:use-place #t)]

[query-exec sqlc "CREATE TABLE IF NOT EXISTS cache (
url text, 
time_downloaded integer, 
data blob, 
headers text)"]

[define serial_num 1]
[define [get_num] [set! serial_num [add1 serial_num]] [sub1 serial_num]]

[define sanitise-filename [lambda [a-name] 
                            [let [[new-filename 
                                   [regexp-replace* "/|__"
                                    [regexp-replace* " " [string-pad-right[regexp-replace* "[^A-Za-z0-9.]" a-name "_"] 100] 
                                                                 ""]
                                    "_"]]]
                              [ll [format "Sanitised filename to: ~a" new-filename]]
                              new-filename]]]

[define [make-buffer] (make-bytes [* 5 1024] (char->integer #\_)) ]

[define [my-copy-port-length buffer source target  fileport print-session data-length]
  [when [> data-length 0]
  [l "Copying ~a bytes of data" data-length]
  [l [format "Reading source port ~a" source]]
  [let [[data [read-bytes-avail!  buffer source]]]
    [if  [and [not [eof-object? data]] [> data-length 0]]
      [begin 
        [l [format "Relaying ~a bytes from ~a to ~a ()" data source target ]]
           [write-bytes buffer target 0 data]
           [when print-session 
             [begin
               [l "Session data: "]
               [write-bytes buffer print-session 0 data]]]
           [when fileport [write-bytes buffer fileport 0 data]]
           [flush-output target]
           [when fileport [flush-output fileport]]
           [my-copy-port-length buffer source target fileport print-session [- data-length data]]]
      [begin
        ;Don't close the port here, it might be a keep-alive connection!
        ;[when fileport [close-output-port fileport]]
        [l "Finished copy!"]
      ]]]]]

[define [my-copy-port buffer source target  fileport print-session ]
  [l [format "Reading source port ~a for unlimitd copy" source]]
  [let [[data [read-bytes-avail!  buffer source]]]
    [if  [not [eof-object? data]]
      [begin 
        [l [format "Relaying ~a bytes from ~a to ~a ()" data source target ]]
           [write-bytes buffer target 0 data]
           [when print-session 
             [begin
               [l "Session data: "]
               [write-bytes buffer print-session 0 data]]]
           [when fileport [write-bytes buffer fileport 0 data]]
           [flush-output target]
           [when fileport [flush-output fileport]]
           [my-copy-port buffer source target fileport print-session ]]
      [begin
        [debug "Port closed!"]
      ;[close-input-port source]
      ;[close-output-port  target]
      ;[close-output-port fileport]
      ]]]]

[define drain-port [lambda [a-port buffer] 
                     [let [[data [read-bytes-avail!  buffer a-port]]]
                       ;[write-bytes buffer [current-output-port] 0 data]
                        [unless [eof-object? data]
                          [drain-port a-port buffer]]]]]
[define save-port [lambda [read-port a-port buffer]
                    [let [[data [read-bytes-avail!  buffer read-port]]]
                       ;[write-bytes buffer [current-output-port] 0 data]
                        [unless [eof-object? data]
                          [write-bytes buffer a-port 0 data]
                          [save-port read-port a-port buffer]]]
                    ]]
[define handle-tap [lambda [a-port]
                     [l [read-response a-port #t]]
                            ;[drain-port a-port [make-buffer]]
                     
                     [save-port a-port [open-output-file [format "~a.data" log_dir ] #:exists 'truncate] [make-buffer]]
                            ]]


  (define process-chunks
    (lambda (a-port out-port tap-port)
      ;(display "Starting process-chunks")
      
        (let ([length-line (read-line a-port 'return-linefeed)])
          (display (format "~nChunk length line ~s~n" length-line))
        (let ([chunk-length (string->number   ( string-trim-both length-line) 16)])
          [display length-line out-port]
          [display crlf out-port]
          (if (equal? chunk-length 0)
              
            (begin
              ;[display "0" out-port]
              ;[display crlf out-port]
              [let [[header (read-header a-port) ]]
              [map [lambda [x] [display x  out-port]
                     [l "~a~n" x]
                [display crlf out-port]] header]
                [display crlf out-port]
                [display crlf out-port]
                [l "Header: ~a" header]
              #""]
              )
          (let ([chunk (read-bytes chunk-length a-port)])
            ;[l "Chunk data: ~a" chunk]
            [display chunk out-port][display chunk tap-port]
            [display (read-line a-port 'return-linefeed) out-port]
            ;[display [crlf] out-port]
            ;(display (format "Read: ~a~n" chunk))
            
            (process-chunks a-port out-port tap-port)))))))
  
  
[define start-relay-server-to-client [lambda [url  filename server-readp client-writep rangeStart]
(let-values [[(in out) (make-pipe)]]
    
  
   [no-thread [thunk [with-handlers ([[thunk* #f] [lambda [err] [displayln [format "Thread closed: ~a" err] ]#f]]) 
                         [ll "Using filename ~s" filename]
                       [let [[fileport [if [and range filename] [open-output-file  filename #:mode 'binary #:exists 'can-update] #f]]]
                                  [when fileport
                                    [file-position fileport [if [string? rangeStart] [string->number rangeStart]rangeStart]]]
                         [ll "Using fileport ~s" fileport]
                           
                         [let [[retval 
                                [let [[headers [read-response server-readp #t]]]
                           
                           [l "~s" headers]
                           [l "~s" [build-response headers]]
                           [display [build-response headers] client-writep]
                           
                           
                           [if [equal? "304"  [first headers]]
                               [begin
                                 #t
                                 
                                 [display [build-request headers] client-writep]
                                 [flush-output client-writep]
                                 [and [assoc "Connection" [fourth headers]] [equal? "Keep-Alive" [cdr [assoc "Connection" [fourth headers]]]]]
                                 ;[start-relay-server-to-client filename server-readp client-writep]
                                 ]
                                
                                  [if [and [assoc  "Transfer-Encoding" [fourth headers]] [equal? "chunked" [cdr[assoc  "Transfer-Encoding" [fourth headers]]]]]    
                               [begin
                                 [letrec [
                                              [stringport  [open-output-bytes]]]
                                 [process-chunks server-readp client-writep stringport]
                                 [flush-output client-writep]
                                 
                                   
                                       ;[displayln [gunzip-through-ports [open-input-bytes [get-output-bytes stringport]] [current-output-port]]]
                                   [if [and [assoc  "Content-Encoding" [fourth headers]] [equal? "gzip" [cdr [assoc  "Content-Encoding" [fourth headers]]]]]    
                                   [begin [letrec [[contentport [open-output-bytes]]]
                                            [gunzip-through-ports [open-input-bytes [get-output-bytes stringport]] contentport]
                                     [letrec [
                                            [content [get-output-bytes contentport]]
                                            [title [regexp-match "meta property=.og:title. content=.([^\"]+)"   content]]]
                                     
                                     [when title ;[displayln [format "Title: ~a" [second title]]]
                                       [set! possible-title [second title]]]
                                       [close-output-port contentport]
                                       [debug [format "Inserting~a " [list url  0 [format "~a" headers] content]] ]
                                            [query-exec sqlc "INSERT INTO cache (url, time_downloaded, headers, data) VALUES ($1, $2, $3, $4);" url  0 [format "~a" headers] content]]
                                     ]]
                                          [letrec [
                                            [content [get-output-bytes stringport]]
                                            [title [regexp-match "meta property=.og:title. content=.([^\"]+)"   content]]]
                                            
                                     
                                     [when [and title [> [bytes-length title] 3]] ;[displayln [format "Title: ~a" [second title]]]
                                       [set! possible-title [second title]]]
                                            [debug [format "Inserting~a " [list url  0 [format "~a" headers] content]] ]
                                            [query-exec sqlc "INSERT INTO cache (url, time_downloaded, headers, data) VALUES ($1, $2, $3, $4);" url  0 [format "~a" headers] content]]
                                          ]
                                     
                                     
                                 [close-output-port stringport]
                                   
                                   ]
                                 [and [assoc "Connection" [fourth headers]] [equal? "Keep-Alive" [cdr [assoc "Connection" [fourth headers]]]]]]
                           [if [assoc  "Content-Length" [fourth headers]]
                               [begin
                               
                               [if [and  [assoc  "Content-Type" [fourth headers]] [equal? "text/html" [cdr [assoc  "Content-Type" [fourth headers]]]]]
                                   [begin
                                     [letrec [
                                              [stringport  [open-output-string]]]
                         [my-copy-port-length [make-buffer] server-readp client-writep  stringport #f [string->number [cdr[assoc  "Content-Length" [fourth headers]]]]]
                                       ;[displayln "!!!"]
                                       ;[displayln [get-output-string stringport]]
                                       ;[displayln "!!!"]
                                       [close-output-port stringport]
                                       [debug [format "Inserting~a " [list url  0 [format "~a" headers] [get-output-string stringport]]] ]
                                            [query-exec sqlc "INSERT INTO cache (url, time_downloaded, headers, data) VALUES ($1, $2, $3, $4);" url  0 [format "~a" headers] [get-output-string stringport]]
                                       #t
                         ]]
                         [begin 
                           [letrec [
                                              [stringport  [open-output-string]]]
                           [my-copy-port-length [make-buffer] server-readp client-writep  fileport stringport [string->number [cdr[assoc  "Content-Length" [fourth headers]]]]]
                                       [debug [format "Inserting~a " [list url  0 [format "~a" headers] [get-output-string stringport]]] ]
                                            [query-exec sqlc "INSERT INTO cache (url, time_downloaded, headers, data) VALUES ($1, $2, $3, $4);" url  0 [format "~a" headers] [get-output-string stringport]]]
                         [and [assoc "Connection" [fourth headers]] [equal? "Keep-Alive" [cdr [assoc "Connection" [fourth headers]]]]]]]]
                         [begin
                           [my-copy-port [make-buffer] server-readp client-writep  fileport #f]
                           #f]
                         ;[displayln "No content-length, not starting relay"]
                         ]]
                                  ]]]]
                           [when fileport
                             [ll "Closing ~s" fileport]
                                    [close-output-port fileport]]
                           retval]
                           
                           ]
                    ]]])]]
                                       ;[l "Reading next server response from ~a" server-readp]
                                       ;[start-relay-server-to-client filename server-readp client-writep]
                                       
                               
                               
                                       


[define [relay filename server-readp server-writep client-readp client-writep]
  [l "Starting relay threads"]
  (let-values [[(in out) (make-pipe)]]
    
  [map thread-wait[filter thread? [list 
   [when capture_traffic 
   [thread [thunk [with-handlers ([[thunk* #t] [lambda [err] [displayln [format "Thread closed: ~a" err] ]#f]])  
                    [handle-tap in]]]]]
   [thread [thunk [with-handlers ([[thunk* #t] [lambda [err] [displayln [format "Thread closed: ~a" err] ]#f]]) 
                         
                         
                         [my-copy-port [make-buffer] server-readp client-writep  [if filename [open-output-file filename #:exists 'truncate] out] #f]]]]
  [thread [thunk (with-handlers ([[thunk* #t] [thunk* #f]]) 
                   [my-copy-port [make-buffer] client-readp server-writep [if filename [open-output-file [format "~a_client.http" filename] #:exists 'truncate] (open-output-nowhere)] #f])]]]]])]

[define listenloop [lambda [local_port remote_ip remote_port listener] 

  [let-values [[[client-readp client-writep][tcp-accept listener]]]
    [let-values [[[server-readp server-writep] (tcp-connect	 	remote_ip remote_port)]]
    [ll [format "Relaying connection ~a:~a:~a" local_port remote_ip remote_port]]
    [relay [if capture_traffic [format "~aconnection_" log_dir ] #f] server-readp server-writep client-readp client-writep]
    [listenloop local_port remote_ip remote_port listener]
  ]]]]
  
[define [relay-port local_port remote_ip remote_port ]
  [listenloop local_port remote_ip remote_port  (tcp-listen	 	local_port	 	 	 	 	 	1	 	 	 	 #t	 #f	 	 	 )]
  [debug "Finished listening"]]
  
[define crlf (format "~a~a" #\return #\newline)]


[define [build-request data]
  
  [let [[request [format "~a ~a ~a~a~a~a" [third data] [if proxy-server [first data][jrl-path [first data]]] [second data] crlf
                     [string-join
              [map [lambda [e] [format "~a: ~a~a" [car e][cdr e] crlf]] [fourth data] ]
              ""]
                     
                     crlf]]]
[l "Built request: ~s" request]
    request]]

[define [build-response data]
  
  [let [[request [format "~a ~a ~a~a~a~a" [third data] [first data] [second data] crlf
                     [string-join
              [map [lambda [e] [format "~a: ~a~a" [car e][cdr e] crlf]] [fourth data] ]
              ""]
                     
                     crlf]]]
[l "Built response: ~s" request]
    request]]

[define make-filename [lambda [request]
                        [letrec [[url [first request]]
                 [docid [regexp-match    "docid=(.+?)\\&" url]]
                 [range [regexp-match    "range=(.+?)-(.+?)\\&" url]]
                 [id [regexp-match       "id=(.+?)\\&" url]]
                 [resource [regexp-match "/([^/]+)\\?" url]]
                 [mimetype [regexp-match "mime=([^/%]+)" url]]
                 
                 ]
                        [if [regexp-match "googlevideo" [jrl-server [first request]]]
                            [format "~a.mp4" [sanitise-filename [format "Youtube_video, ~a, ~a"    [if mimetype [second mimetype] "_"]possible-title ]]]
                            [sanitise-filename [format "~a:~a" [jrl-server [first request]] [jrl-path [first request]] ]]]
                        ]]]

[define [handle-new-connection local_port client-readp client-writep]
  [with-handlers ([[thunk* #t] [lambda [err] 
                                 [close-input-port client-readp]
                                 [close-output-port client-writep]
                                 [displayln [format "Error in handling client, connection abandoned: ~s" err] ]
                                 #f]])
    [l "Accepted connection, reading header"]
    [letrec [[raw-request [read-response client-readp #f]]
             [request [list [first raw-request][second raw-request][third raw-request][filter [lambda [pair] [not[equal? "Cache-Control" [car pair]]]] [fourth raw-request]]]]]
      [if [not [banned  [first request]]]
          [begin
            [if [equal? [third request] "CONNECT"]
                [begin
                  [ll [format "No connects for j00: ~a" [first request]]]
                  [display [build-response `[  "503" "Fuck off"  "HTTP/1.1" [,[cons "Proxy-agent" "HURFDURF"  ],[cons "Content-Type" "application/tunnel"],[cons "Connection" "close"]]]] client-writep]
                  ;[handle-new-connection local_port client-readp client-writep]
                  ;[close-input-port client-readp]
                  ;[close-output-port client-writep]   
                  [ll "Connect to ~a requested" [first request] ]
                  ;[ll "~a" request]
                  ;            [begin 
                  ;            [let-values [[[server-readp server-writep] (tcp-connect  [jrl-server [first request]] [jrl-port [first request]])]]
                  ;              [display [build-request `[  "200 Connection established" "" "HTTP/1.1" [,[cons "Proxy-agent" "HURFDURF"  ],[cons "Content-Type" "application/tunnel"]]]] client-writep]
                  ;              [write [build-request `[  "200 Connection established" "" "HTTP/1.1"  [,[cons "Proxy-agent" "HURFDURF"  ],[cons "Content-Type" "application/tunnel"]]]] ]
                  ;              [flush-output server-writep]
                  ;            [relay [if capture_traffic [format "~aconnection_~a" log_dir [get_num ]] #f] server-readp server-writep client-readp client-writep]]
                  ;              ]
                  ] 
                [begin
                  [letrec [[url [first request]]
                           [docid [regexp-match    "docid=(.+?)\\&" url]]
                           [range [regexp-match    "range=(.+?)-(.+?)\\&" url]]
                           [id [regexp-match       "id=(.+?)\\&" url]]
                           [resource [regexp-match "/([^/]+)\\?" url]]
                           [mimetype [regexp-match "mime=([^/%]+)" url]]
                           
                           ]
                    
                    
                    [l "Opening connection to ~a" [jrl-server [first request]]]
                    [let-values [[[server-readp server-writep] (tcp-connect  [if proxy-server [first proxy-server] [jrl-server [first request]]] [if proxy-server [cdr proxy-server][jrl-port [first request]]] )]]
                      
                      [ll "Relaying connection ~a:~a:~a (~a)" local_port [jrl-server [first request]] [jrl-port [first request]][first request]]
                      [display [build-request request] server-writep]
                      [flush-output server-writep]
                      [l "Sent request: ~s" [build-request request]]
                      [if [start-relay-server-to-client url
                           [if capture_traffic 
                               [format "~a\\~a" 
                                       log_dir 
                                       [make-filename request]]  #f] server-readp  client-writep [if range [second range] 0]]
                          [begin
                            [l "Finished handling request, closing server connection and recycling client ports"]
                            [close-input-port server-readp]
                            ;[flush-output server-writep]
                            [close-output-port server-writep]
                            [ll "Server ports closed"]
                            [handle-new-connection local_port client-readp client-writep]]
                          [begin
                            [l "Terminating connection"]
                            
                            ]
                          ]]]]
                
                ]]
          [begin
            [ll "Rejected connection to ~a" [first request]]
            [display [build-response `[  "503" "Fuck off"  "HTTP/1.1" [,[cons "Proxy-agent" "HURFDURF"  ],[cons "Content-Type" "application/tunnel"],[cons "Connection" "close"]]]] client-writep]
            
            ;[close-input-port client-readp]
            ;[close-output-port client-writep]
            ;[error "ACCESS DENIED"]
            ]]
      [close-input-port client-readp]
      ;[flush-output client-writep]
      [close-output-port client-writep]
      [sleep 3]
      (collect-garbage)
      [sleep 3]
      [ll "Client ports closed"]
      ]]
  ]

[define proxyloop [lambda [local_port listener] 
                    
[l "Listening on port ~a" local_port]
  [let-values [[[client-readp client-writep][tcp-accept listener]]]
    [thread [thunk [handle-new-connection local_port client-readp client-writep]]]
    [proxyloop local_port  listener]
  ]]]

[define [http-proxy local_port ]
  [proxyloop local_port   (tcp-listen	 	local_port	 	 	 	 	 	1	 	 	 	 #t	 #f	 	 	 )]
  [debug "Finished listening"]]
  ;[relay-port 22 "10.95.23.44" 22]
;[build-request ]

;[relay-port 81 "localhost" 8080]
;[build-request (list #f "HTTP/1.1" "GET" (list (cons "Host"  "www.xnxx.com") (cons "User-Agent"  "Mozilla/5.0 (Windows NT 6.3; WOW64; rv:32.0) Gecko/20100101 Firefox/32.0") (cons "Accept"  "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8") (cons "Accept-Language"  "en-US,en;q=0.5") (cons "Accept-Encoding"  "gzip, deflate") (cons "Connection"  "keep-alive")) #"")]
[http-proxy 81]