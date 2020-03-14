#lang racket
(require parsack)

(define $whitespace  (many (or $space $newline $tab $eol)))
(define $set-statement(parser-compose
                   $whitespace
                   (var <-(manyTill $alphaNum $space))
                   (char #\=)
                   (<any> $whitespace)
                   (expression <-(manyTill $anyChar $eol))
                   (return (list "set" var expression))))
(define $return-statement(parser-compose
                   $whitespace
                   (string "return")
                   $whitespace
                   (expression <-(manyTill $anyChar $eol))
                   (return (list "return"  expression))))
(define $if-statement (parser-compose
                       $whitespace
(string "if")
$whitespace
                       (condition <- (manyTill $anyChar (string "then")))
                       $whitespace
                   (trues <- (manyTill $statements (string "else")))
                   $whitespace
                   (falses <- (manyTill $statements (string "end")))
                   $whitespace
                   (return (list "if" condition trues falses))))
(define $statements (manyTill (<any>   (try $set-statement) (try $return-statement)) (string "end")))
 (define $arg (parser-compose
             (manyTill $alphaNum (string ":"))
             (<any> $whitespace)
             (manyTill $alphaNum (string ")"))))
 (define $decl (parser-compose
                  $whitespace
                  (name <- (manyTill $alphaNum (string ":")))
                  $whitespace
                  (type <- (between (string "*") (string "*") (many $alphaNum)))
                  (init <- (manyTill $anyChar $eol))
                  (return (list name type init))))
(parse-result
   (parser-compose
    (try $whitespace)
    (string "fu")
                   (many $space)
                   (name <- (manyTill $letter (char #\()))
                  (arg <- $arg)
                   
                   (many $space)
                   (string "->")
                   (many $space)
                   (returnType <-(manyTill $letter $whitespace))
                   (decl <- (manyTill (<or>  $decl $whitespace) (string "in") ))
                   
                   
                   (try $whitespace)
                   (s <- (<any> $statements))
                   (string " function")
                   (return (list name returnType decl s )))
  
"
fu doStringList(l: xist) -> list
    runTests: *bool* false
runTests: *bool* false
in
      newlist = cons(boxSymbol(\"boxString\"), cons(first(l), newlist))
      ret = cons(cons(boxSymbol(\"cons\"), cons(newlist, doStringList(cdr(l)))), nil)
      return ret
end function")