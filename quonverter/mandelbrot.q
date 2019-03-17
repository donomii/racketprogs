[
          [includes mandelbrot.qon]
       [types
           [Box
            [struct
              [lis struct Box* ]
              [str string ]
              [i int ]
              [typ string ]
              [voi bool ]
              [boo bool]
              [lengt int ]
              [car struct Box* ]
              [cdr struct Box* ]
              ]]
           [box Box*]
           [Pair Box]
           [pair Box*]
           [list Box*]
           ]

          [functions


           [int add [int a int b] [declare]
                [body [return [sub a [sub 0 b]]]]]

           [float addf [float a float b] [declare]
                  [body [return [subf a [subf 0 b]]]]]

           [int sub1 [int a] [declare]
                [body [return [sub a 1]]]]

           ]

[int start [] [declare]
     [body
[mandelPic]
       ]]

          ]
