#lang racket
(require (prefix-in fuckwits: pfds/queue/bankers))
(require srfi/13)
(require srfi/1)
(define q (fuckwits:queue))
(define current-command "")



(define (make-command)
  
  
  (let ((new-char (read-line)))
    
    ;(when (or (equal? 32 (char->integer (car (string->list new-char))))(string=? "" new-char) (string=? " " new-char))
    ;    (begin
    ;      (set! q (fuckwits:enqueue current-command q))
    ;      (set! current-command ""))
    ;    (begin
    
    (set! current-command (string-concatenate (list current-command new-char)))
    ;(printf "new char: ~a\n" (char->integer (car (string->list new-char))))
    
    
    (printf "command length: ~a\n" (string-length current-command))
    (printf "current command: ~a\n" current-command)
    (when (equal? 2 (string-length current-command))
        (begin
          
          (set! q (fuckwits:enqueue current-command q))
          (set! current-command ""))
        
        )
    ;))

    
    (make-command)))

(define (do-menu options)
  ;(displayln "menu")
  ;(displayln options)
  (map (lambda(o index) (display (format "~a ~a ~n" (+ 10 index) (first o) ))) options (iota (length options)))
  (lambda (choice)
    (let ((opt (list-ref options choice)))
      (displayln opt)
      ((second opt))))
  )
(print "starting input watcher\n")

(thread make-command)

(define (display-files)

  (map (lambda (x y) (printf "~a ~a\n" y x)) (directory-list) (iota (length (directory-list)))))


(define (get-command)
  (if (not (fuckwits:empty? q))
      (let ((command (fuckwits:head q)))
        (set! q (fuckwits:tail q))
        command)
      (get-command))
  )

(define (convert-num inStr)
  (- (string->number inStr) 10)
  )

(print "starting command thread")
(define (act-on menu)
  ;(with-handlers ([(lambda (v) #t) (lambda (v) (display v))])
  (begin
    (let ((do-action (do-menu menu)))
  
      (let ((command (get-command)))
    
        (printf "Acting on command: ~a\n" command)
        (if (> (string->number command) 0)

            (begin
          
              ;(display "Found number")
              ;(display (convert-num command))
              (do-action (convert-num command))
                   
              )
        
            (case command
              [("Open") (display-files)])
    
            ))))
  (act-on menu)
  )
  

(define default-menu  `(
                        ("Load File" ,(lambda ()
                                        (act-on (dyna-menu (directory-list)))
                                        ))
                        ("Quit" ,(lambda ()
                                   (exit 0)
                                   ))
                        ))


(define (dump-file a-name)
  (displayln (file->string a-name))
  (act-on default-menu))

(define (dyna-menu a-list)
  ;(displayln "starting dyna-menu for")
  ;(displayln a-list)
  (map (lambda (e) `(,e ,(lambda () (dump-file e)))) a-list))


(define (start)
  (with-handlers ([(lambda (v) #t) (lambda (v) (display v))])
    (act-on default-menu)
    )
  (start)
  )


(start)


