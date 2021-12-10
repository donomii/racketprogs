[module support racket
[provide command-output get-word zap-word]

[define command-output [lambda [a-command] [letrec [[pipes [process a-command]]
                                                    [stdout [car pipes]]]
                                             [[fifth pipes] 'wait]
                                             [read-string 99999 stdout]]]]

  [define [eval-string str] (eval (call-with-input-string str read))]

  ;Given a gui text widget, extract the word currently under the cursor, or the highlighted text
[define get-word [lambda [a-text]  [letrec [
                                            [highlight-start [send a-text get-start-position]]
                                            [hightlight-end [send a-text get-end-position]]]
                                     [if [not [eq? highlight-start hightlight-end]]
                                         [send a-text get-text highlight-start hightlight-end]
                                         [letrec [[startbox [box highlight-start]] 
                                                  [endbox [box hightlight-end]]  
                                                  [start (send a-text find-wordbreak startbox #f 'selection)]
                                                  [end (send a-text find-wordbreak #f endbox  'selection)]]
                                           [send a-text get-text [unbox startbox] [unbox endbox]]]]]]]


;Delete currently selected word/hightlighted text
[define zap-word [lambda [a-text]  [letrec [[startbox [box [send a-text get-start-position]]] 
                                            [endbox [box [send a-text get-start-position]]] 
                                            [start (send a-text find-wordbreak startbox #f 'selection)]
                                            [end (send a-text find-wordbreak #f endbox  'selection)]]
                                     [send a-text kill 0 [unbox startbox] [unbox endbox]]]]]

  ]