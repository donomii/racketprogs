;=head1 NAME
;
;Actinic - a library of http convenience
;
;=head1 SYNOPSIS
;
;This is a HTTP client library.  It gives you the choice of quick and dirty calls using simple 
;defaults, or more complicated calls that let you control every part of the request.
;It does not support HTTP pipelining, but it does cache connections (sometimes known as keep-alives) to speed up later
;requests to the same server.  This cache is thread safe, so multiple threads benefit from the speedup.
;
;Download the microsoft webpage:
;s
; e.g. (simple-get "http://www.microsoft.com")  ; Returns the webpage as a byte-string or #f if anything went wrong
;
;Download the microsoft webpage, setting the referrer and user-agent fields:
;
; e.g. (http-get "http://microsoft.com" '(("referrer" "http://linux.org") ("user-agent" "my-browser(v1.1)" ) ) )
;
;The return value is a list containing '( response-code english-code http-version '(response headers) #"body of response")
;
; e.g. ( 200 "OK" "HTTP/1.1" '(( "content-type" "blah" )  ( "language" "blahblahblah" ) ) #"welcome to my webpage!....")
;
;=head1 DESCRIPTION
;
;=over


(module actinic mzscheme
  (provide
   
   http-get
   http-post
   
   post-encode
   url-encode
   
   simple-get
   simple-post
   simple-head
   simple-put
   simple-options
   simple-trace
   
   break-jrl
   build-jrl
   jrl-scheme
   jrl-username
   jrl-password
   jrl-server
   jrl-port
   jrl-path
   jrl-server/proxy
   jrl-port/proxy
   jrl-path/proxy
   
   read-response
   read-header
   ;actinic-run-tests
   )
  
  (require (lib "string.ss"))
  (require (lib "string.ss" "srfi" "13"))
  (require (lib "selector.ss" "srfi" "1"))
  (require (lib "list.ss" "srfi" "1"))
  (require (lib "mzssl.ss" "openssl"))
  (require (lib "class.ss"))
  (require "actinic-connection-cache.ss")
  
  ;(define proxy "http://localhost:8888/")
  (define proxy #f)
  (define socket-cache (new hash-cache% [name "Socket cache"]))
  (define sem (make-semaphore 10))
  [define use-keep-alive #f]
  ;  (define socketcount 0)
  (define stringify
    (lambda ( a-thing )
      ;(db 2 (format "Stringifying ~s ~n" a-thing))
      (if (path? a-thing)
          (path->string a-thing)
          (if (symbol? a-thing)
              (symbol->string a-thing)
              ;(if (url? a-thing)
              ;   (url->string a-thing)
              (if (equal? #f a-thing)
                  #f
                  (if (string? a-thing)
                      a-thing
                      (bytes->string/utf-8 a-thing)))))))
  (define second-or-#f (lambda (a-list)
                         (if (< 1 (length a-list))
                             (cadr a-list)
                             #f)))
  
  (define build-jrl (lambda args
                      (regexp-replace ":/"
                                      (regexp-replace* "//"
                                                       (regexp-replace* "//"
                                                                        (string-concatenate args)
                                                                        "/")
                                                       "/")
                                      "://")))
  
  (define http-success? (lambda (result) (and (> (car result) 199) (< (car result) 300))))
                          
                          
  (define break-jrl
    (lambda ( input-url )
      [let [[probably-a-url [if [regexp-match "://" input-url] input-url [format "http://~a" input-url]]]]
      (let ((a-url (stringify probably-a-url)))
        ;      (display (format "break-url - working on ~a~n" a-url))
        (let ((scheme-and-rest (regexp-split "://" a-url)))
          (let ((slash-chunks (regexp-split "/" (cadr scheme-and-rest))))
            (let ((scheme (car scheme-and-rest))
                  (user-server-port (car slash-chunks))
                  (path (string-join (cons "" (cdr slash-chunks)) "/")))
              (let ((host-and-user (reverse (regexp-split "@" user-server-port))))
                (let* ((user-pass (if (second-or-#f host-and-user) (regexp-split ":" (second-or-#f host-and-user)) #f))
                       (server-port (regexp-split ":" (car host-and-user))))
                  (let* ((user (if user-pass (car user-pass) #f))
                         (pass (if user-pass (second-or-#f user-pass) #f)))
                    (let* ((server (car server-port))
                           (port    (second-or-#f server-port)))
                      ;(db 2 (format "break-url - scheme: ~a server/port: ~a path: ~a~n" scheme server-and-port path))
                      (list scheme user pass (if (equal? server "") #f server) port (if (equal? path "") "/" path))))))))))]))
  
  ;=item (winnow-alist assoc-list)
  ;
  ;Removes duplicate keys from an association list. The first key in the list is kept, any duplicate keys after that are thrown out.
  (define winnow-alist (lambda (alist)
                         (let ((new-list (list)))
                           (map 
                            (lambda (x) (if (pair? x) 
                                            (if (not (assoc (car x) new-list)) 
                                                (begin
                                                  (set! new-list (cons x new-list))))))
                            alist)
                           new-list)))
  ;=back
  ;
  ;=head2 JRLs - urls, actinic style
  ;
  ;Actually, they're just called jrls because net.ss claimed "urls" first, and there's a good chance you'll use both these modules at some point in time.  All jrl functions always take a text url e.g. "http://fred:fredspass@a.server.com:9843/some/file.html"
  ;
  ;These functions pick out useful bits of the url for you to use.
  ;
  ;=over
  ;
  ;=item (jrl-scheme url) - Gets the url scheme e.g. http ftp telnet file
  ;
  ; e.g. (jrl-scheme "http://user:pass@a.server.com:9843/some/file.html" ) -> "http"
  (define (jrl-scheme jrl)   (first (break-jrl jrl)))
  
  ;=item (jrl-username url) - Gets the url username : http://THIS:pass@server.com/
  ;
  ; e.g. (jrl-username "http://fred:fredspass@a.server.com:9843/some/file.html" ) -> "fred"
  (define (jrl-username jrl) (second (break-jrl jrl)))
  
  ;=item (jrl-password url) - Gets the url password : http://fred:THIS@a.server.com:9843/some/file.html 
  ;
  ; e.g. (jrl-password "http://fred:fredspass@a.server.com:9843/some/file.html" ) -> "fredspass"
  (define (jrl-password jrl) (third (break-jrl jrl)))
  
  ;=item (jrl-server url) - Gets the url server or 'host' : http://fred:fredspass@THIS.PART.HERE:9843/some/file.html
  ;
  ; e.g. (jrl-server "http://fred:fredspass@a.server.com:9843/some/file.html" ) -> "a.server.com"
  (define (jrl-server jrl)   (fourth (break-jrl jrl)))
  
  ;=item (jrl-server/proxy url)
  ;
  ;Gets the url server.  However if you have told actinic to use a proxy, you'll get the proxy instead.  
  ;If actinic isn't using a proxy, it will behave identically to jrl-server
  ;
  ; e.g. (jrl-server/proxy "http://fred:fredspass@a.server.com:9843/some/file.html" ) -> "a.proxy.server.com"
  (define (jrl-server/proxy jrl)   (jrl-server (if proxy proxy jrl)))
  
  ;=item (jrl-port/proxy url)
  ;
  ;Gets the url port.  However if you have told actinic to use a proxy, you'll get the proxy's port instead
  ;If you actinic isn't using a proxy, it will behave identically to jrl-port
  ;
  ; e.g. (jrl-port/proxy "http://fred:fredspass@a.server.com:9843/some/file.html" ) -> "8080"
  
  (define (jrl-port/proxy jrl)     (if proxy
                                       (if (fifth (break-jrl jrl))
                                           (string->number (fifth (break-jrl proxy )))  
                                           (cond 
                                             ((equal? (jrl-scheme jrl) "http") 80)
                                             ((equal? (jrl-scheme jrl) "https") 443)
                                             ((equal? (jrl-scheme jrl) "ftp") 23)
                                             ((equal? (jrl-scheme jrl) "file") (error "Cannot call jrl-port on a url with a file:// scheme"))
                                             (else (error (format "No port specifiec in the url and I can't recognise the scheme to guess a port: ~a" jrl)))))
                                       (jrl-port jrl)))
  
  ;=item (jrl-port url) - Gets the url port : http://fred:fredspass@a.server.com:THIS/some/file.html
  ;
  ;If the url does not include a port, jrl-port will try to look at the scheme and guess the correct port.  If it can't do that, it throws an error.
  ;
  ; e.g. (jrl-port "http://fred:fredspass@a.server.com:9843/some/file.html" ) -> "9843"
  (define (jrl-port jrl)     (if (fifth (break-jrl jrl)) 
                                 (string->number (fifth (break-jrl jrl)))
                                 (cond 
                                   ((equal? (jrl-scheme jrl) "http") 80)
                                   ((equal? (jrl-scheme jrl) "https") 443)
                                   ((equal? (jrl-scheme jrl) "ftp") 23)
                                   ((equal? (jrl-scheme jrl) "file") (error "Cannot call jrl-port on a url with a file:// scheme"))
                                   (else (error (format "No port specified in the url and I can't recognise the scheme to guess a port: ~a" jrl))))))
  
  ;=item (jrl-path url) - Gets the url path : http://fred:fredspass@a.server.com:9843THIS/PART/HERE
  ;
  ; e.g. (jrl-path "http://fred:fredspass@a.server.com:9843/some/file.html" ) -> "/some/file.html"
  (define (jrl-path jrl)     (if (equal? "" (sixth (break-jrl jrl)))
                                 "/"
                                 (sixth (break-jrl jrl))))
  
  ;=item (jrl-path/proxy url) - Gets the url path : http://fred:fredspass@a.server.com:9843THIS/PART/HERE
  ;
  ;If actinic is using a proxy, it will return an appropriate string for the path request part of the header.
  ;
  ; e.g. (jrl-path/proxy "http://fred:fredspass@a.server.com:9843/some/file.html" ) -> "http://fred:fredspass@a.server.com:9843/some/file.html"
  ;
  ;Note to self:  this function is correct.  Stop trying to 'fix' it
  (define (jrl-path/proxy jrl)     (if proxy jrl (jrl-path jrl)))
  
  ;=item (create-request-line method url version)
  ;
  ;Creates the correct first two lines for a http request
  ;
  ;method: a string, one of "HEAD" "GET" "PUT" "POST" "OPTIONS" or any other http method you feel like faking up 
  ;
  ;url: a string like  "http://www.a.site.com"
  ;
  ;version:  a string indicating which version of the http protocol you want to use.  We recommend "1.1", but you can use "1.0" or even "0.9"
  (define create-request-line (lambda (http-method a-url http-version)
                                ;[display (format "~a ~a HTTP/~a~a~aHost: ~a~a~a~a" http-method  [url-encode (jrl-path/proxy a-url)]  http-version #\return #\linefeed (jrl-server a-url) (if proxy (format ":~a" (jrl-port a-url)) "") #\return #\linefeed) ][newline]
                                (format "~a ~a HTTP/~a~a~aHost: ~a~a~a~a" http-method  [url-encode (jrl-path/proxy a-url)]  http-version #\return #\linefeed (jrl-server a-url) (if proxy (format ":~a" (jrl-port a-url)) "") #\return #\linefeed)))
  
  (define bytes-join (lambda (a-list glue-bytes)
                       (if (equal? a-list ())
                           #""
                           (if (equal? (cdr a-list) ())
                               (car a-list)   
                               (bytes-append (car a-list) glue-bytes (bytes-join (cdr a-list) glue-bytes))))))
  ;=item (process-header lines)
  ;
  ;Takes a list of byte strings and breaks them up into an assoc list
  ;
  ;lines: expects a list of lines from the http response (bytes)
  ;
  ;Each line should have the trailing CRLF already removed, and should be in byte format.
  ;
  ;Returns an assoc list that holds the header parameters:
  ;
  ; e.g. ((Date .  Mon, 12 Jun 2006 03:11:11 GMT) (Server .  Apache/2.0.54 (Debian GNU/Linux) DAV/2 SVN/1.1.4 PHP/5.0.4 mod_ssl/2.0.54 OpenSSL/0.9.7e) (X-Powered-By .  PHP/5.0.4) (Connection .  close) (Content-Type .  text/html))
  (define process-header (lambda (header-lines)
                           (filter-map (lambda (a-line)
                                  (if (> (string-length a-line) 3)
                                  (let ((pieces (regexp-split ":( |\t)+" a-line)))
                                    ;[displayln [format "Header line: ~a" a-line]]
                                    (cons (car pieces) (string-join (cdr pieces) ":")))
                                  #f)
                                  )
                                header-lines)))
  ;=item (slurp-port port) - read all bytes from a port
  ;
  ;reads bytes from a port until it gets an eof, then returns all the bytes read in one byte string
  ;
  ;port: an input port
  ;
  ;Returns a byte string of all the bytes read from the port
  (define slurp-port (lambda (a-port)
                       (let ((bytes (read-bytes 9999 a-port)))
                         (if (eof-object? bytes) 
                             #""
                             (bytes-append bytes (slurp-port a-port))))))
  
  (define process-chunks
    (lambda (a-port)
      ;(display "Starting process-chunks")
      
        (let ([length-line (read-line a-port 'return-linefeed)])
          ;(display (format "~nChunk length line ~a~n" length-line))
        (let ([chunk-length (string->number   ( string-trim-both length-line) 16)])
          (if (equal? chunk-length 0)
            (begin
              (read-header a-port)
              #"")
          (let ([chunk (read-bytes chunk-length a-port)])
            (read-line a-port 'return-linefeed)
            ;(display (format "Read: ~a~n" chunk))
            
            (bytes-append chunk (process-chunks a-port))))))))
  ;=item (break-result result) - takes a HTTP response and turns it into an easy-to-access data structure
  ;
  ;result: a byte string containing a raw http response
  ;
  ;returns a rather complicated structure containing the response status, the header lines and the body of the response in the form: list of ( status-code english-code '(assoc list of header settings) body)
  ;
  ; the returned list looks like ( 200 OK HTTP/1.1 '((Date .  Mon, 12 Jun 2006 03:11:11 GMT) (Server .  Apache/2.0.54 (Debian GNU/Linux) DAV/2 SVN/1.1.4 PHP/5.0.4 mod_ssl/2.0.54 OpenSSL/0.9.7e) (X-Powered-By .  PHP/5.0.4) (Connection .  close) (Content-Type .  text/html)) #"welcome to my webpage.....")
  (define break-result (lambda (result)
                         ;(display (format "Processing ~s~n" result))
                         (if result
                             (if (regexp-match "^HTTP" result)
                                 (let* ((split-pos (regexp-match-positions #"\r\n\r\n" result))
                                        (header (subbytes result 0 (car (car split-pos))))
                                        (body (subbytes result (cdr (car split-pos))))
                                        (lines (regexp-split (format "~a~a" #\return #\linefeed) header))
                                        (top-line (regexp-split " +" (car lines)))
                                        (keyval (process-header (cdr lines)))
                                        (status (list 
                                                 (string->number (bytes->string/utf-8 (second top-line))) 
                                                 (third top-line) 
                                                 (first top-line) 
                                                 (if (and 
                                                      (assoc #"Transfer-Encoding" keyval) 
                                                      (equal? (cdr (assoc #"Transfer-Encoding" keyval)) #"chunked"))
                                                     (append (first (process-chunks body)) keyval)
                                                     keyval)
                                                 (if (and 
                                                      (assoc #"Transfer-Encoding" keyval) 
                                                      (equal? (cdr (assoc #"Transfer-Encoding" keyval)) #"chunked"))
                                                     (second (process-chunks body))
                                                 body))))
                                   ;                                   (display (format "returning ~s~n" status))
                                   ;(display (format "Keyval: ~s~n" keyval)) 
                                   status)
                                 (list 
                                  0 
                                  "Not a proper HTTP response" 
                                  "Not a proper HTTP response" 
                                  result
                                  result))
                             (list 
                              0 
                              "Failed to get any kind of response" 
                              "Failed to get any kind of response" 
                              ""
                              ""))))
  
  
  (define build-header (lambda (request-line an-alist)
                         ;                         (display (format "building header ~s~n" an-alist))
                         (format "~a~a~a~a"  request-line (string-concatenate (map (lambda (a-pair) (format "~a: ~a~a~a" (car a-pair) (cdr a-pair)  #\return #\linefeed )) (winnow-alist an-alist))) #\return #\linefeed)))
  
  
  (define send-request (lambda (header payload a-port)
                 ;        (display header)
                         (display header a-port)
                         ;(display (format "Sending header ~s~n" header))
                         (when payload (display payload a-port))
                         ;(display (format "Sending payload ~s~n" payload))
                         ;(display (format "~a~a" #\return #\linefeed))
                         (flush-output a-port)
                         ;(close-output-port a-port)
                         ))
  
  (define read-header
    (case-lambda 
      [(a-port) (read-header a-port (read-line a-port 'return-linefeed))]
      [(a-port a-line) 
       (when (eof-object? a-line)
          (error (format "Got eof while reading http header")))
       ;(write (format "Read line: ~a" a-line))
       ;[newline]
       ;[write (string-length a-line)]
       ;[newline]
       (if (equal? 0 (string-length a-line) )
           [begin 
             ;[displayln "Header complete"]
             (list)]
           (cons a-line (read-header a-port)))]))
  
  (define read-body (lambda (a-port expected-length)
                      (read-bytes expected-length a-port)))
  

      (define dump-cache (lambda ()
                           ;(display "Dumping socket cache") (newline)
                           
                           (let ([oldcache socket-cache])
                                            (set! socket-cache (new hash-cache% [name "Socket cache"]))
                                             (send oldcache keymap (lambda (k v) 
                                                                     
                                                         (close-input-port (car v))
                                                         (close-output-port (cdr v)))))))
  (define read-response
    (lambda (a-port head-hack?)
      ;(with-handlers (((lambda (exn) #t) (lambda (exn) 
      ;                 (display (format "Error reading response: ~a~n" (exn-message exn)))
      ;                                     (dump-cache)
      ;                                     (raise exn))))
      (let ([header-lines (read-header a-port)])
      ;(write header-lines)
      (let* (        [top-line (if (> (string-length (car header-lines)) 3)
                                   (regexp-split " +" (car header-lines))
                                   (error (format "Bad read on header ~a" header-lines)))]
              [header-fields (process-header (cdr header-lines))]
              [body-length (assoc "Content-Length" header-fields)]
              [body (if head-hack? #"" (if body-length (read-body a-port (string->number (cdr body-length))) 
                                           (if [and (assoc "Transfer-Encoding" header-fields) (equal? "chunked" (cdr (assoc "Transfer-Encoding" header-fields)))]
                                               (begin
                                                 
                                                 (let ([res (process-chunks a-port)])
                                                   ;(dump-cache)
                                                   res))
                                               #"" )))])
        ;(write header-fields)
        ;(write body)
        ;(newline)
        (let ([res 
        (list
        (second top-line)
                                                 (third top-line) 
                                                 (first top-line) 
                                                 header-fields
                                                 body)])
         ;(display res)
          res)))))
        ;(display (break-result result))
        ;(close-input-port a-port)
        
        ;(when (equal? #"" result) (error "Server closed connection before data could be transmitted for request"))        
        
        
      ;  result
  
  (define make-socket-cache-key (lambda (a-url) (format "~a://~a" (jrl-server a-url) (jrl-port a-url))))
  (define open-server (lambda (a-url)
                        ;(set! socketcount (add1 socketcount))
                        ;(print socketcount)(newline)
                        (let ([ports (send socket-cache fetch  (make-socket-cache-key a-url)
                                           (lambda ()
                                             (let-values ([(in out)
                                                           (begin
                                                             ;(display (format "Could not find an open socket for ~a, opening a new one~n" (make-socket-cache-key a-url)))
                                                           ((if  (equal? (jrl-scheme a-url) "http")
                              tcp-connect
                              ssl-connect)
                         (jrl-server/proxy a-url) (jrl-port/proxy a-url)))])
                                               (cons in out))))])
                          (values (car ports) (cdr ports)))))
  
  
  (define generic-one-shot (case-lambda 
                             [(a-url header payload) (generic-one-shot a-url header payload #f)]
                             [(a-url header payload head-hack?) (generic-one-shot a-url header payload head-hack? 3)]
                             [(a-url header payload head-hack? retries)
                                                         (with-handlers (((lambda (exn) #t) 
                                                                          (lambda (exn)
                                                                          (if (> retries 0)
                                                                              (begin
                                                                                (dump-cache)
                                                                              (generic-one-shot a-url header payload head-hack? (- retries 1)))
                                                                              (raise exn)))))
                             ;(display (format "Sending ~a ~a ~n" header payload))
                              (call-with-semaphore sem 
                             (lambda () (call-with-values (lambda () (open-server a-url))
                                               (lambda (inp outp)
                                                 (send-request header payload outp)
                                                 
                                                 (let ([res (read-response inp head-hack?)])
                                                   (if (assoc "Connection" (fourth res))
                                                       (begin
                                                         ;(display "Closing connection at request of server")
                                                         (close-input-port inp)
                                                         (close-output-port outp)
                                                         
                                                       (send socket-cache delete (make-socket-cache-key a-url)))
                                                       )
                                                   res))))
                             ))]))
  
  (define default-headers (lambda () `(
                                       ("User-Agent" . "GenericHTTPclient")
                                       ;("Connection" . "close")
                                       ("Accept" . "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, */*")
                                       ("Accept-Charset" . "utf-8,us-ascii;q=0.7,*;q=0.7")
                                       ;("Accept-Encoding" . "gzip, deflate")
                                       ("Accept-Language" . "en-au")
                                       ("Content-Length" . "0"))))
  
  (define simple-query
    (case-lambda 
      [(a-method a-url a-header-list a-body) (simple-query a-method a-url a-header-list a-body 'head-hack)]
      [(a-method a-url a-header-list a-body head-hack?)
      (generic-one-shot a-url (build-header (create-request-line a-method  a-url "1.1") (winnow-alist (cons a-header-list (default-headers)))) a-body head-hack?)]))
  ;=back
  ;
  ;=head2 Simple Calls
  ;
  ;The simple-query calls are designed for situations like command line work, or programs where it really doesn't matter how or why a call fails, just that the call goes off and doesn't take much mental effort to prepare.  All the simple calls here return #f on failure, but the success result depends on which call you are using.  Exceptions are passed straight through so be ready to deal with exn:network:fails.
  ;
  ;All the simple calls use the same default header options, and they all send a connection: close to turn off pipelining and keep alives.  They do not follow redirects.
  ;  
  ;=over
  ;
  ;=item (simple-head "http://www.myserver.com/") - sends a simplistic HEAD request with actinic defaults
  ; 
  ;A head request works exactly like a get request, but without the data sent in the body.
  ;It lets you see what would happen if you did a GET request but without shifting (potentially) a lot of data from the server.
  ;
  ;Returns #t if the server responds with a 200, #f otherwise
  ;
  ;If you need better control over the request, or you want to see the response, try the corresponding http-head call, listed below.
  (define http-head  
    (case-lambda 
      (( a-url ) (let ((result (http-head a-url '() #f)))(http-success? result)))
      (( a-url headers ) (http-head a-url headers #f))
      (( a-url headers params ) (simple-query "HEAD"  a-url headers params 'head-hack))))
  
  (define simple-head http-head)
  
  ;=item (simple-delete "http://www.myserver.com/a/file.txt") - sends a simplistic DELETE request with actinic defaults
  ;
  ;I've never seen a server actually implement the DELETE method, but in the event it ever happens, you can use this call.
  ;
  ;Returns #t if the server responds with a 200, #f otherwise
  ;
  ;If you need better control over the request, or you want to see the response, try the corresponding http-delete call, listed below.
  (define http-delete
    (case-lambda
      (( a-url ) (let ((result (http-delete a-url '() #f)))(http-success? result)))
      (( a-url headers) (http-delete headers #f))
      (( a-url headers params)  (simple-query "DELETE"  a-url headers params))))
  (define simple-delete http-delete)
  ;
  ;=item (simple-trace "http://www.myserver.com/") - sends a simplistic TRACE request with actinic defaults
  ;
  ;The TRACE method causes the server to echo back your request exactly as it was received.  It's quite handy for seeing if a proxy has mangled your call or if something weird is going on with the request builder.
  ;
  ;Returns #t - unlike the other simple calls, simple-trace returns the raw byte response as a single byte string.
  ;
  ;If you need better control over the request, try the corresponding http-trace call, listed below.
  
  (define http-trace 
    (case-lambda
      ((a-url)                 (http-trace a-url '()))
      ((a-url headers) (simple-query "TRACE"  a-url headers #f))))
  (define simple-trace http-trace)
  
  
  ;=item (simple-get url) - sends a simplistic GET request with actinic defaults
  ;
  ;simple-get requests the contents of the web-page or web-application.  It returns the page as fetched, or #f if anything goes wrong.
  ;
  ; e.g. (simple-get "http://www.myserver.com/a/file.html") -> #"Welcome to my webage...blahblahblah..."
  ;
  ;Returns the webpage or #f if anything goes wrong
  ;
  ;If you need better control over the request, or you want to see the response headers, try the corresponding http-get call, listed below.
  
  (define ( simple-get a-url )  
    (fifth (http-get a-url '() #f)))
  ;       (break-result (simple-query "GET"  a-url '() #f)))))
  
  
  
  ;=item (simple-post url parameters) - sends a simplistic POST request with actinic defaults
  ;
  ;simple-post sends some data to a server.  The POST data format is horribly complicated, prone to misinterpretation and the base of data transport over web.  hooray.
  ;
  ; e.g. (simple-post "http://www.myserver.com/a/form.cgi" '(("name" "myname")("comment" "Hello Timothy, I find you delightfully amusing"))) -> #t
  ;
  ;parameters: an assoc list containing the data you want to send.  The data is post-encoded, hammered into a request string and sent in the body of the request
  ;
  ;Returns #t if the server responds with 200 for success, #f otherwise
  ;
  ;If you need better control over the request, or you want to see the response, try the corresponding http-post call, listed below.
  (define simple-post 
    (lambda (a-url an-alist)
      ;(display (format "Sending ~a~n" an-alist))
      (let* ((payload 
              (if (pair? an-alist)
                  (string->bytes/utf-8 (string-join (map (lambda (a) 
                                                           ;(display (format "Sending ~s~n" (cdr a)))
                                                           (format "~a=~a" (post-encode (car a)) (post-encode (cdr a)))) an-alist) "&"))
                  an-alist))
             (payload-length (bytes-length payload)))
        (let ((result (generic-one-shot a-url (build-header (create-request-line "POST"  a-url
                                                                                 "1.1") 
                                                            (cons 
                                                             
                                                             (if (pair? an-alist) `("Content-Type" . "application/x-www-form-urlencoded") `("Content-Type" . "application/octet-stream"))
                                                             (cons 
                                                              `("Content-Length" . ,(number->string payload-length))
                                                              
                                                              
                                                              (default-headers))))
                                        payload)))
          ;(display result)
          (http-success? result)))))
  
  
  
  
  ;=item (simple-put url contents) - sends a simplistic PUT request with actinic defaults
  ;
  ;simple-put sends some data to a server.  PUT is supposed to be the complement of the GET request, but very few servers support it so everybody uses POST to send data instead.  In theory, the server should store the data from the body of the PUT request at the location in the URL.  
  ;
  ; e.g. (simple-put "http://www.myserver.com/a/file.txt" #"The contents of the file") -> #t
  ;
  ;contents: a byte string containing the contents that you would like to see placed at that url
  ;
  ;Returns #t if the server responds with 200 for success, #f otherwise
  ;
  ;If you need better control over the request, or you want to see the response, try the corresponding http-put call, listed below.
  
  (define simple-put 
    (lambda (a-url a-bytestring)
      (let* ((payload-length (bytes-length a-bytestring)))
        (let ((result (generic-one-shot a-url (build-header (create-request-line "PUT"  a-url
                                                                                 "1.1") 
                                                            (cons `(("Content-Length" . ,(number->string payload-length)))(default-headers)))
                                        a-bytestring )))
          (http-success? result)))))
  
  
  ;=item (simple-options "http://www.myserver.com/") - sends a simplistic OPTIONS request with actinic defaults
  ;
  ;The OPTIONS method gets the list of options that the HTTP server supports.  Following Apache's lead, we only ever do an OPTIONS * HTTP/1.1 request, no matter what url you give, even though in theory the server should return an OPTIONS for any resource we query.  Behaviour subject to change if someone has a better idea on how it should work.
  ;
  ;Returns a list of the options the server supports.
  ;
  ;If you need better control over the request, try the corresponding http-options call, listed below.
  
  (define simple-options
    (lambda ( a-url )
      (let ((result (generic-one-shot a-url (build-header (format "OPTIONS * HTTP/1.1~a~aHost:~a~a~a~a" #\return #\newline (jrl-server a-url) (if proxy (format ":~a" (jrl-port a-url)) "") #\return #\newline) (default-headers)) #f)))
        (regexp-split "," (cdr (assoc #"Allow" (fourth  result)))))))
  
  ;=back
  ;
  ;=head2 http-query calls - customise your calls
  ;
  ;The http-query line of calls offers much more control over your requests than the simple- line.  You can override header options by passing an assoc list as the second argument.  The car (string) is the option part of the header line, and the cdr part (string) is the option value.  All the functions return the same type of list:
  ;
  ; e.g. ( status long-status version ( (header-opt . header-value) ... ) body )
  ;
  ; -> ( 200 OK HTTP/1.1 '((Date .  Mon, 12 Jun 2006 03:11:11 GMT) (Server .  Apache/2.0.54 (Debian GNU/Linux) DAV/2 SVN/1.1.4 PHP/5.0.4 mod_ssl/2.0.54 OpenSSL/0.9.7e) (X-Powered-By .  PHP/5.0.4) (Connection .  close) (Content-Type .  text/html)) #"welcome to my webpage.....")
  ;
  ;	The http-query calls use a shared internal connection cache.  Instead of opening a new socket for every request, actinic will reuse an old socket rather than opening a new one.  This is safe for multiple threads, so you can fire off a thread per request	and actinic will share the same socket between all the threads.  This is handy for writing a web crawler since servers will often get sulk at you if you pound them with thousands of socket-opens per second.  Plus there's a nice speed up since socket opens are sloooow.
  ;
  ;Note that this is not pipelining; each request must fully complete before the next one starts.
  ;
  ;
  ;The connection is always closed after one request, and the connection: close header is sent.
  ;
  ;=over
  ;
  ;=item (http-get url params headers) - sends a GET request
  ;
  ;http-get requests the contents of the page or web-application.  If you want to provide key - value arguments to be built into the url, pass an assoc-list in the params arguement, just like http-post.  The handling of these arguments isn't very sophisticated yet.
  ;
  ; e.g. (http-get "http://www.myserver.com/" '() '()) -> ( 200 OK HTTP/1.1 '((header header-val)) #"Welcome to my webage...blahblahblah...")
  ;
  (define http-get
    (case-lambda 
      ((a-url) (http-get a-url '()))
      ((a-url params) (http-get a-url params '()))
      ((a-url params header-args)
        ;(db 2 (format "http-get - Getting ~s~n" (stringify a-url)))
        (generic-one-shot a-url (build-header (create-request-line "GET"  a-url "1.1")  (cons header-args (default-headers))) #f))))
  
  ;=item (http-post url parameters headers payload) - sends a POST request
  ;
  ;http-post sends data to a server. The data is provided in the parameters list, which is a key - value assoc list.  All paramaters must be strings.  Multi-part posts are NOT supported, and the mime type of the post is "application/x-www-form-urlencoded".
  ;
  ;If you want to arrange your own payload, call with parameters set to #f, and specify your own byte string in the payload.  The mime type will be set to "application/octet-stream".
  ;
  ; e.g. (http-post "http://www.myserver.com/a/form.cgi" '(("name" "myname")("comment" "Hello Timothy, I find you delightfully amusing"))) -> #t
  ;
  ;The parameters are an assoc list containing the data you want to send.  The data is post-encoded, hammered into a request string and sent in the body of the request
  ;
  ;Returns the usual convoluted structure.
  (define http-post 
    (case-lambda 
      ((a-url params) (http-post a-url params #f #f))
      ((a-url params header-opts) (http-post a-url params header-opts #f))                                 
      ((a-url params header-opts payload)
      (if header-opts (set! header-opts (append header-opts (default-headers))) (set! header-opts (default-headers)))
      (let ((real-payload (if payload payload
                              (string->bytes/utf-8 (string-join (map (lambda (a) 
                                                           ;(display (format "Sending ~s~n" (cdr a)))
                                                           (format "~a=~a" (post-encode (car a)) (post-encode (cdr a)))) params) "&")))))
                              
                              
                      (let ((payload-length (bytes-length payload)))
                        (let ([pending-header (build-header (create-request-line "POST"  a-url "1.1") 
                                                            (cons                                                              
                                                             (if (pair? params) `("Content-Type" . "application/x-www-form-urlencoded") `("Content-Type" . "application/octet-stream"))
                                                             (cons 
                                                              `("Content-Length" . ,(number->string payload-length))                                
                                                              header-opts)))])
                          ;(display pending-header)
                        (let ((result (generic-one-shot a-url pending-header (bytes-append payload (string->bytes/utf-8 (format "~a~a" #\return #\newline))))))
                          result)))))))
  
  
  ;=item (http-trace url headers) - sends a TRACE request
  ;
  ;The TRACE method causes the server to echo back your request exactly as it was received.  It's quite handy for seeing if a proxy has mangled your call or if something weird is going on with the request builder.  
  ;
  ; e.g. (http-trace "http://www.myserver.com/" '())
  ;
  ;=item (http-delete url headers) - sends a DELETE request
  ;
  ;I've never seen a server actually implement the DELETE method, but in the event it ever happens, you can use this call.  http-delete asks a server to delete the resource at the given url.
  ;
  ; e.g. (http-delete "http://www.myserver.com/a/file.txt")
  ;
  ;=item (http-head url headers) - sends a HEAD request
  ; 
  ;A head request works exactly like a get request, but without the data sent in the body.  
  ;It lets you see what would happen if you did a GET request but without shifting (potentially) a lot of data.
  ;
  ;  e.g. (http-head "http://www.myserver.com/")
  ;
  
  
  
  [define url-encode (lambda (a-string) 
                       (string-concatenate (map  [lambda [s] 
                                                   [if [or [< 126 [char->integer s]] [> 33 [char->integer s]]] 
                                   [string-concatenate [map [lambda [x] [format "%~x" x]] [bytes->list [string->bytes/utf-8 [format "~a" s]]]]]
                                   [format "~a" s]]]
                                                
                                                (string->list a-string))))]
  
  (define post-encode (lambda (a-string) 
                       (string-concatenate (map encode-char (string->list a-string)))))
  (define encode-char (lambda  (s)
                        
                        (let/ec return
                          
                          (map (lambda (c) 
                                 
                                 (if (equal? (car c) s) (return (cdr c))))
                               (quote (
                                       (#\  .  "%20")
                                       (#\! .  "%21")
                                       (#\" . "%22")
                                       (#\# .  "%23")
                                       (#\$ .  "%24")
                                       (#\% .  "%25")
                                       (#\& .  "%26")
                                       (#\' .  "%27")
                                       (#\( .  "%28")
                                       (#\) .  "%29")
                                       (#\* .  "%2A")
                                       (#\+ .  "%2B")
                                       (#\, .  "%2C")
                                       (#\- .  "%2D")
                                       (#\. .  "%2E")
                                       (#\/ .  "%2F")
                                       
                                       ;(#\: .  "%3A")
                                       (#\; .  "%3B")
                                       ;(#\< .  "%3C")
                                       (#\= .  "%3D")
                                       ;(#\> .  "%3E")
                                       (#\? .  "%3F")
                                       ;(#\@ .  "%40")
                                       
                                       ;(#\[ .  "%5B")
                                       ;(#\\ .  "%5C")
                                       ;(#\] .  "%5D")
                                       ;(#\^ .  "%5E")
                                       ;(#\_ .  "%5F")
                                       ;(#\` .  "%60")
                                       
                                       ;(#\{ .  "%7B")
                                       ;(#\| .  "%7C")
                                       ;(#\} .  "%7D")
                                       ;(#\~ .  "%7E")
                                       )))
                          (list->string (list s)))))
  


  )
;
;=back
;
;=head1 TODO
;
;Add keep-alives and pipelining.
;
;=head1 COPYRIGHT
;
;You may use this module under the same terms as PLT Scheme itself.
;
;=head1 AUTHOR
;
;Donomii@gmail.com

