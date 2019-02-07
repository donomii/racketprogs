#lang racket
[require srfi/1]
; Support functions
[define [id x] x]
[define [walk tree func]
  ;[displayln tree]
  [if [list? tree]
      [map [lambda [branch] [walk branch func]] [func tree]]
      tree
      ]]



(define (swap-every-2 lst)
  (if (or (null? lst) 
          (null? (cdr lst)))
      lst
      (list* (cadr lst) 
             (car lst) 
             (swap-every-2 (cddr lst)))))

(define (ndelete lst n)
  (let recur ((i 1)
              (rest lst))
    (cond ((null? rest) '())
          ((= i n) (recur 1 (cdr rest)))
          (else (cons (car rest) (recur (+ i 1) (cdr rest)))))))

(define (nth-places n lst [i 0])
  (cond
    [(null? lst) null]
    [(= i 0) (cons (car lst)
                   (nth-places n (cdr lst) (+ i 1)))]
    [(= i n) (nth-places n (cdr lst) 0)]
    [else (nth-places n (cdr lst) (+ i 1))]))


; C output functions

;[define [includes tree]
;  [map [lambda [x] [display [format "#include <~a>;~n" x] ]] [cdr tree]]
;  ]

;[define [arguments tree]
;  [display "("]
;  [map [lambda [x] [display [format "~a " x]]] tree]
;  [display ")"]
;  ]
;
;[define [statement tree]
;[display [format "    ~a(" [car tree]]]
;[display [string-join [map [lambda [x] [format "~s" x]] [cdr tree]] ", "]]
;[displayln ");"]
;                ]
;
;[define [declaration tree]
;[match-let [[[list type name value] tree]]
;  [displayln [format "    ~a ~a = ~a;" type name value]]]]
;
;[define [declarations tree]
;  [displayln " {"]
;  [map [lambda [x] [declaration x]] [cdr tree]]
;  ]
;
;
;[define [body tree]
;  [map [lambda [x] [statement x]] [cdr tree]]
;  [displayln "}"]
;  [displayln ""]
;  ]
;
;[define [function tree]
;[match-let [[[list type name args decs  bod] tree]]
;  [display [format "~a ~a " type name]]
;  [arguments args]
;  [declarations decs]
;  [body bod]]
;  '[]
;  ]





; Golang output functions

[define [includes tree]
  [list
  "package main\n\n"
  [map [lambda [x]  [format "import \"~a\"~n" x] ] [cdr tree]]
  ]]

[define [make-pairs lst]
[if [empty? lst]
    lst
    [cons [take lst 2] [make-pairs [drop lst 2]]]]
  ]

[define [arguments tree]
  [list "("
  [string-join [map [lambda [x]  [format "~a ~a" [cadr x] [car x]]] [make-pairs tree]] ", "]
  ")"
  ]]


[define [statement tree]
  [list
   [case [car tree]
    ['set  [format "    ~a=~a~n" [cadr tree] [caddr tree]]]
     [else [list [format "    ~a(" [car tree]]
   [string-join [map [lambda [x] [format "~s" x]] [cdr tree]] ", "]
  ")\n"]]]
  ]]

[define [declaration tree]
  [match-let [[[list type name value] tree]]
    [format "    var ~a ~a = ~s\n"  name type value]]]



[define [main tree]
[match-let [[[list type name args decs  bod] tree]]
   [list
    [format "func main() {\n"]
    [declarations decs]
    [body bod]
  ]]]

[define [body tree]
  [list
  [map [lambda [x] [statement x]] [cdr tree]]
  "}\n"]]



[define [function tree]
  [match-let [[[list type name args decs  bod] tree]]
    [if [equal? name 'main]
        [main tree]
        [list
    [format "func ~a " name]
    [arguments args]
    [format " ~a {~n" [typemap type]]
    [declarations decs]
    [body bod]]]]]


[define [typemap type]
  [case type
    ['void ""]
    [else type]]]



;
;; BASH output functions
;
;[define [includes tree]
;  [list "#!/bin/bash\n\n"
;        [map [lambda [x]  [format "~n"] ] [cdr tree]]
;        ]]
;
;[define [arguments tree]
;  [list "{\n"
;        [map [lambda [x i] [format "    local ~a=$~a~n" x i]] [nth-places 2 tree -1] [iota [length tree] 1 1]]]]
;
;[define [statement tree]
;  [list
;   [case [car tree]
;     ['set [format "    local ~a=~a~n" [cadr tree] [caddr tree]]]
;     [else [list
;             [format "    ~a " [car tree]]
;             [map [lambda [x]  [format "~s " x]] [cdr tree]]
;             ]]]
;   "\n"]]
;
;[define [declaration tree]
;  [match-let [[[list type name value] tree]]
;    [format "    local ~a=~a~n"  name value]]]
;
;[define [main tree]
;  [match-let [[[list type name args decs  bod] tree]]
;    [list
;     "function " name " {\n" 
;     [declarations decs]
;     [map [lambda [x] [statement x]] [cdr bod]]
;     "}\n"
;     "main"
;     ]]]
;
;[define [body tree]
;  [list
;   [map [lambda [x] [statement x]] [cdr tree]]
;   "}"
;   "\n"
;   ]]
;
;
;
;[define [function tree]
;  [match-let [[[list type name args decs  bod] tree]]
;    [if [equal? name 'main]
;        [main tree]
;        [list
;         [format "function ~a " name]
;         [arguments args]
;         [format " ~a" [typemap type]]
;         [declarations decs]
;         [body bod]
;         ]]]
;  ]
;
;
;[define [typemap type]
;  ""
;  ]
;
;; BAT output functions
;
;[define [includes tree]
;  [list [format "ECHO ON~nSETLOCAL ENABLEEXTENSIONS~nCALL main~nEXIT /B 0~n"]
;  [map [lambda [x] [format "~n"] ] [cdr tree]]]]
;
;[define [arguments tree]
;  [list "\n"
;  [map [lambda [x i] [format "    SET ~a=%~a~n" x i]] [nth-places 2 tree -1] [iota [length tree] 1 1]]]
;
;  ]
;
;[define [statement tree]
;  [list
;  [case [car tree]
;    ['set  [format "    SET ~a=~a~n" [cadr tree] [caddr tree]]]
;  [else [begin [list [format "    ~a " [car tree]]
;   [map [lambda [x] [format "~s " x]] [cdr tree]]]
;   ]]]
;        "\n"]
;  ]
;
;[define [declaration tree]
;  [match-let [[[list type name value] tree]]
;    [format "    SET ~a=~a~n"  name value]]]
;
;
;[define [main tree]
;[match-let [[[list type name args decs  bod] tree]]
;  [list 
;  [format "~n~n:~a~n" name]
;    [declarations decs]
;    [map [lambda [x] [statement x]] [cdr bod]]
;    "EXIT /B 0"]
;  ]]
;
;[define [body tree]
;  [list
;  [map [lambda [x] [statement x]] [cdr tree]]
;  "EXIT /B 0"
;  "\n"]
;  ]
;
;[define [function tree]
;  [match-let [[[list type name args decs  bod] tree]]
;    [if [equal? name 'main]
;        [main tree]
;        [list
;    [format "~n~n:~a " name]
;    [arguments args]
;    [format " ~a" [typemap type]]
;    [declarations decs]
;    [body bod]
;     "EXIT /B 0"
;  ]]]
;  ]
;
;
;[define [typemap type]
;  ]


[define [declarations tree]
  [map [lambda [x] [declaration x]] [cdr tree]]]


[define [functions tree]
  [map function [cdr tree]]]

[define [program tree]
  [string-join [flatten [map dispatch tree]]]]

[define prog
  '[
    ;[includes stdio.h stdlib.h]
    [includes fmt]
    [functions
     [void sayHello [int b string c]
           [declare]
           [body 
            [fmt.Printf "Hello world: %d\n" b]
            [fmt.Printf "Hello world: %s\n" c]
            ;[echo a is b]
            ;[set a 11]
            ]]

     [int main [int argc \, char** argv]
          [declare [int a 10] [string b "quonverter"]]
          [body
           [set a 12]
           [sayHello a b]
           ;[echo a is a]
           ]]]]]


[define [dispatch tree]
  [case [car tree]
    [(functions)   [functions tree]]
    [(includes)  [includes tree]]
    ]]

[display-to-file [program prog] "testprog.go" #:exists 'replace]
;[displayln [walk prog [lambda [x]
;  [dispatch x]
;    x]]]


;Prune all empty leafs from the tree
[define [noEmpty tree]
  [walk tree [lambda [l] [id [filter [lambda [x] [not [void? x]]] [filter id  [filter [lambda [x] [not [empty? x]]] l]]]]]]
  ]

[define nofollow '[ thing1 thing2]]
;Don't recurse through these nodes
[define [noFollow tree]
  [walk tree [lambda [l] [id [filter [lambda [x] [not [member   [first tree] nofollow streq?]]] l]]]]]

[define skipList '[thing3 thing4]]
;Skip over these child nodes
[define [skip tree]
  [walk tree [lambda [l] [id [filter [lambda [x] [not [member   [first tree] skipList streq?]]] l]]]]]


[define [streq? a b] [equal? [format "~a" a] [format "~a" b]]]


[define [traverse tree]

  [if [list? tree]
      
      [begin
  
        [when [not [empty? tree]]
          [if [not [member   [first tree] nofollow streq?]]
              [filter id [map [lambda [branch]
                                [if  [member branch skipList streq?] false
                                     [traverse branch]]] tree]]
              false
              ]
          ]]
      tree
      ]]
