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

[define [make-pairs lst]
  [if [empty? lst]
      lst
      [cons [take lst 2] [make-pairs [drop lst 2]]]]
  ]



; C output functions

;
;[define [includes tree]
;  [list
;   [map [lambda [x]  [format "#include <~s>~n" x] ] [cons 'stdio.h [cdr [codeof tree]]]]
;   "\n"
;   ]]
;
;[define [arguments tree]
;  [list "("
;        [string-join [map [lambda [x]  [format "~a ~a" [typemap [car x]] [cadr x]]] [make-pairs [codeof tree]]] ", "]
;        ")"
;        ]]
;
;
;[define [statement tree]
;  [displayln  "!!!"]
;  [displayln [codeof tree]]
;  
;  [list
;   [case [car [codeof  tree]]
;     ['set  [format "    ~a=~a;~n" [cadr [codeof tree]] [caddr [codeof tree]]]]
;     [else [list [format "    ~a(" [car [codeof tree]]]
;                 [string-join [map [lambda [x] [format "~s" x]] [cdr [codeof tree]]] ", "]
;                 ");\n"]]]
;   ]]
;
;[define [declaration tree]
;  [match-let [[[list type name value] [codeof tree]]]
;    [format "    ~a ~a = ~s;\n"  [typemap type] name  value]]]
;
;
;
;
;[define [body tree]
;  [displayln tree]
;  ;[exit 0]
;  [list
;   [map statement  tree]
;   "}\n\n"]]
;
;
;
;[define [function tree]  [match-let [[[list type name args decs  bod] [childrenof tree]]]
;    
;                           [list
;                            [format "~a ~a " [typemap [codeof type]] [codeof name]]
;                            [arguments args]
;                            [format " {~n" ]
;                            [declarations decs]
;                            [body bod]]]]
;
;
;[define [typemap type]
;  [case type
;    ['string "char*"]
;    [else type]]]



; Golang output functions

[define [includes tree]
  [list
   "package main\n\nimport \"fmt\"\n\n"
   [map [lambda [x]  [format "import \"~a\"~n" x] ] [cdr [codeof tree]]]
   ]]

[define [arguments tree]
  [list "("
        [string-join [map [lambda [x]  [format "~a ~a" [cadr x] [car x]]] [make-pairs [codeof tree]]] ", "]
        ")"
        ]]


[define [statement tree]
  ;[displayln  "!!!"]
  ;[displayln [codeof tree]]
  [list
   [case [car [codeof  tree]]
     ['set  [format "    ~a=~a~n" [cadr [codeof tree]] [caddr [codeof tree]]]]
     [else [list [format "    ~a(" [funcmap [car [codeof tree]]]]
                 [string-join [map [lambda [x] [format "~s" x]] [cdr [codeof tree]]] ", "]
                 ")\n"]]]]]

[define [declaration tree]
  [match-let [[[list type name value] [codeof tree]]]
    [format "    var ~a ~a = ~s\n"  name type value]]]



[define [main tree]
  [displayln tree]
  [match-let [[[list type name args decs  bod] [childrenof tree]]]
    [list
     "func main() {\n"
     [declarations decs]
     [body bod]
     ]]]

[define [body tree]
  [displayln tree]
  ;[exit 0]
  [list
   [map statement  tree]
   "}\n"]]



[define [function tree]
  [match-let [[[list type name args decs  bod] [childrenof tree]]]
    [if [equal? [codeof name] 'main]
        [main tree]
        [list
         [format "func ~a " [codeof name]]
         [arguments args]
         [format " ~a {~n" [typemap [codeof type]]]
         [declarations decs]
         [body bod]]]]]


[define [typemap type]
  [case type
    ['void ""]
    [else type]]]

[define [funcmap name]
  [case name
    ['printf 'fmt.Printf]
    [else name]]]


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


; Type functions


[define [make-node type code name children]
  [list
   [cons 'types type]
   [cons 'code code]
   [cons 'name name]
   [cons 'children children]
   ]]


[define [default_node codetree name]
  [list
   [cons 'types '[]]
   [cons 'code codetree]
   [cons 'name name]
   [cons 'children '[]]]]

[define [type_includes tree]
  [default_node tree 'includes
    ]]



[define [type_arguments tree]
  ;[displayln tree]
  [make-node   [map [lambda [x]  [cons  [cadr x] [car x]]] [make-pairs tree]]
               tree
               'function_arguments
               '[]]]


[define [type_statement scope tree]
  [make-node scope tree "statement" '[]]]

[define [type_declaration tree]
  [match-let [[[list type name value] tree]]
    [list
     [cons 'types [list [cons name type]]]
     [cons 'code tree]
     ]
    ]]

[define [typesof x]
  ;[displayln x]
  [if [equal? [length x] 1]
      '[]
      [cdr [assoc 'types  x]]]]


[define [codeof x]
  ;[newline]
  ;[displayln x]
  [if [equal? [length x] 1]
      '[]
      [cdr [assoc 'code  x]]
      ]
  ]

[define [nameof x]
  [newline]
  [newline]
  [displayln x]
  [if [equal? [length x] 1]
      '[]
      [cdr [assoc 'name  x]]]]

[define [childrenof x]
  [newline]
  [displayln x]
  [if [equal? [length x] 1]
      '[]
      [cdr [assoc 'children  x]]
      ]
  ]
 

[define [type_body scope tree]
  ;[display scope]
  [displayln [format "fucntion types: ~a" scope]]
  [map [lambda [x] [type_statement scope x]] [cdr tree]]]



[define [type_function tree]
  ;[displayln tree]
  [match-let [[[list type name args decs  bod] tree]]
      
    [letrec [[typeArgs [typesof [type_arguments args]]]
             [allTypes  [make-node [append [typesof  [type_declarations decs]] typeArgs ]
                                   [cons 'code '[]]
                                   "function_types"
                                   '[]]]]
      [make-node '[] '[] 'function
                 [list
                  [make-node type type 'function_type '[]]
                  [default_node name 'function_name]
                  [type_arguments args ]
                  [type_declarations decs ]
                  [type_body [typesof allTypes] bod ]
                  ]
                 ]]]]



[define [type_declarations tree]
  [if [empty? [cdr tree]]
      [default_node '[] 'variable_declarations]
        
      [make-node [map [lambda [x] [car [typesof [type_declaration x]]]] [cdr tree]]
               
                 tree
                 'variable_declarations
                 [map type_declaration [cdr tree]]]]]


[define [type_functions tree]
  [map type_function [cdr tree]]]

[define [type_annotate tree]
  [map type_dispatch tree]]

[define [type_dispatch tree]
  [case [car tree]
    [(functions)   [make-node '[] "" 'functions [type_functions tree]]]
    [(includes)  [type_includes tree]]
    ]]


[define [type_program tree]
  [make-node '[] "" 'program [map type_dispatch tree]]]









;Common funcs

[define [declarations tree]
  [map declaration  [childrenof tree]]]


[define [functions tree]
  [map function [childrenof tree]]]

[define [program tree]
  [string-join [flatten [map dispatch  [childrenof tree]]]]]

[define prog
  '[
    ;[includes stdio.h stdlib.h]
    [includes]
    [functions


     [void test1 [] [declare]
           [body [printf "1.  pass Function call and print work\n"]]]

     [void test2_do [string message] [declare]
           [body [printf "2.  pass Function call with arg works: %s\n" message]]]
           
     [void test2 [] [declare]
           [body [test2_do "This is the argument"]]]

     [void test3_do [int b string c]
           [declare]
           [body 
            [printf "3.1 pass Two arg call, first arg: %d\n" b]
            [printf "3.2 pass Two arg call, second arg: %s\n" c]
            ]]
     
     [void test3 [] [declare]
           [body [test3_do 42 "Fourty-two"]]]
          
     [int main [int argc  char** argv]
          [declare [int a 10] [string b "quonverter"]]
          [body
           [test1]
           [test2]
           [test3]
           [set a 12]
           ;[echo a is a]
           ]]]]]


[define [dispatch tree]
  [newline]
  [newline]
  [displayln tree]
  [case [nameof tree]
    [(functions)   [functions tree]]
    [(includes)  [includes tree]]
    ]]

[let [[nodes [type_program prog]]]
  ;[displayln "nodes"]
  ;[displayln   nodes]
  
  [displayln [program  nodes]]
  [exit 0]]
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
