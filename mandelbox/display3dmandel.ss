#lang scheme
[require [file "mandlebox.ss"]]


(require mzlib/defmacro)
(require mred
         mzlib/class
         mzlib/math
         sgl
         sgl/gl-vectors
         )
(require sgl/gl)


(define topwin (new (class frame%
                      (augment* [on-close (lambda () (exit))])
                      (super-new))
                    [label "test"]
                    [style '(metal)]))

;(define f win)
(define pic (make-object bitmap%  10 10 ))

[display [format "Pic dimensions: ~a ~a~n" [send pic get-width][send pic get-height]]]
;[set! pic-width [sub1 [send pic get-width]]]
;[set! pic-height [sub1 [send pic get-height]]]
(define bdc (new bitmap-dc% [bitmap pic]))

(define showpic (lambda (c a-dc) (send a-dc draw-bitmap pic 0 0   )))








(define _texel_offset 0)
(define best-texture #f)
(define reset-texel-offset (lambda () (set! _texel_offset 0)))
(define current-texel-offset (lambda () (/ _texel_offset 1024)))
[define inc-texel-offset (lambda () (let ((new-index (add1 _texel_offset)))
                                      (if (> new-index 1024)
                                          (set! _texel_offset 0)
                                          (set! _texel_offset new-index))))]
[define texel-slice (/ 3 1024)]


(glEnable GL_TEXTURE_2D )
(glDisable GL_TEXTURE_2D )
(glPixelStorei GL_UNPACK_ALIGNMENT 1)






(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_LINEAR)   ; filtrage lineaire
(glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_LINEAR)
(glTexParameterf GL_TEXTURE_2D GL_TEXTURE_WRAP_S GL_REPEAT );
(glTexParameterf GL_TEXTURE_2D GL_TEXTURE_WRAP_T GL_REPEAT );

(begin 
  ;[map (lambda (x) (cvector-set! *texture* x 
  ;                (random (expt 2 31))
  ;                                     ;(if (odd? x) (random (expt 2 31)) 0)
  ;               )) (cdr (build-list 10000 values))]
  #t)




(define controls? #t)




;(send dc show)
;(define best-gl #f)


(define (do-paint )
  (gl-clear-color 0.0 0.0 0.0 0.0)
  (gl-clear 'color-buffer-bit 'depth-buffer-bit)
  ;(write new-genome)
  
  
  
  (gl-push-matrix)
  
  
  
  
  [gl-polygon-mode 'front-and-back 'fill]
  [picture ]
  
  (gl-pop-matrix)
  
  )

[defmacro trans [ xx y z thunk ]
  ;[lambda []
  `[ begin
      [gl-push-matrix]
      (gl-translate ,xx ,y ,z)
      [,thunk]
      [gl-pop-matrix]
      ; ]
      [lambda [] "trans"]] ]  
[defmacro left  [thunk] `[trans -1 0 0 ,thunk]]
[defmacro right [thunk] `[trans 1 0 0  ,thunk]]
[defmacro above [thunk] `[trans 0 1 0  ,thunk]]
[defmacro below [thunk] `[trans 0 -1 0 ,thunk]]
[defmacro forwards [thunk] `[trans 0 0 1 ,thunk]]
[defmacro backwards [thunk] `[trans 0 0 -1 ,thunk]]
[define tri [lambda []
              (glBegin GL_TRIANGLES)
              (glVertex3i 0 1 0)				
              (glVertex3i -1 -1  0)			
              (glVertex3i 1 -1  0)
              (glEnd)]]
[defmacro rot [x y z o]
  `[begin
     [gl-push-matrix]
     (glRotated ,x 1 0 0)
     (glRotated ,y 0 1 0)
     (glRotated ,z 0 0 1)
     [,o]
     
     [gl-pop-matrix]
     [lambda [] "rot macro"]]]
[defmacro  push-pop-matrix  [a-thunk]
  `(begin
     [gl-push-matrix]
     ,a-thunk
     [gl-pop-matrix]
     [lambda () "pushpop"])]
[define square [lambda []
                 [one-sided-square]
                 [rot 0 180 0 one-sided-square]]]
[define one-sided-square [lambda []
                           ;[lambda []
                           ; [gl-push-matrix]
                           ;[gl-scale 0.5 0.5 0.5]
                           
                           
                           (glBegin GL_TRIANGLES)
                           ; glVertex2d(0.0,0.0);
                           ; glVertex2d(1.0,0.0);
                           ; glVertex2d(1.0,1.0);
                           ; glVertex2d(0.0,1.0);
                           (let ([o (current-texel-offset)])
                             (inc-texel-offset)
                             (glTexCoord2d (+ o 0.0) 0.0)                           
                             (glVertex3i -1 1  0)
                             (glTexCoord2d (+ o texel-slice) 0.0)
                             (glVertex3i -1 -1  0)
                             (glTexCoord2d (+ o 0.0) 1.0)
                             (glVertex3i 1 -1 0)	
                             
                             (glTexCoord2d (+ o 0.0) 1.0)     
                             (glVertex3i -1 1  0)
                             (glTexCoord2d (+ o texel-slice) 1.0)
                             (glVertex3i 1 -1  0)              
                             (glTexCoord2d (+ o texel-slice) 0.0)
                             (glVertex3i 1 1  0)
                             )    
                           (glEnd)
                           ;[gl-pop-matrix]
                           [lambda []   "double run on square()" ]
                           
                           ]
  ; ]
  ]
[defmacro mybox []
  `[begin
     [gl-push-matrix]
     [gl-scale 0.5 0.5 0.5]
     [gl-color 1 0 0]
     [right [rot 0 90 0  [one-sided-square]]]
     [left [rot 0 -90 0  [one-sided-square]]]
     [gl-color 0 1 0]
     [above [rot -90 0 0  [one-sided-square]]]
     [below [rot 90 0 0 [one-sided-square]]]
     [gl-color 0 0 1]
     [backwards [rot 180 0 0 [one-sided-square]]]
     [forwards [one-sided-square]]
     [gl-pop-matrix]
     [lambda [] #f]]]
[define make-fracdata [lambda [n scale ]
           [letrec [[half [round [/ n 2]]]]
    [apply append [map [lambda [z]
                         [apply append [map [lambda [x] 
                                              [filter  [lambda [x]x] [map [lambda [y]
                                                     [if 
                                                      [in-mandlebox? [/ [- x half] scale]  [/ [ - y half] scale] [/ [ - z half] scale] 5 100]
                                                         
                                                         [list [- x half]  [- y half] [- z half]]
                                                         #f]]
                                                   [build-list n values]]]
                                              ]
                                            [build-list n values]]]]
                       [build-list n values]]]]]]
[define fracdata [make-fracdata 72 480]]
;[define fracdata [make-fracdata 180 120]]
[define screen-scale 0.1]
[define plot [lambda [] 
               [map [lambda [coords]
                      [when coords [begin
                                     (gl-push-matrix)
                                     [gl-scale screen-scale screen-scale screen-scale]
                                     [trans [first coords]
                                            [second coords]
                                            [third coords]
                                            [mybox]]
                                     (gl-pop-matrix)]]]
                    fracdata]]]
[define [test] [trans 1 0 0 [mybox]]]

[define glist #f]
[define [picture]  
  [gl-enable 'color-material]
  [if glist
                       [begin 
                                     (gl-push-matrix)
                                     [gl-scale screen-scale screen-scale screen-scale]
                         [display "Redrawing"][newline] (gl-call-list glist)
                         (gl-pop-matrix)]
                       [begin

[set! glist [gl-gen-lists 1]]
[gl-new-list glist 'compile]
[plot]
[gl-end-list]
[display "Finished  creating display list"][display glist][newline]
[picture]]
                       ]]

(define gears-canvas%
  (class* canvas% ()
    
    (inherit refresh with-gl-context swap-gl-buffers get-parent)
    [init best-display?]
    [define is-best-display best-display?]
    (define rotation 0.0)
    
    (define view-rotx 0.0)
    (define view-roty 0.0)
    (define view-rotz 0.0)
    
    (define gear1 #f)
    (define gear2 #f)
    (define gear3 #f)
    
    (define step? #f)
    
    (define/public (run)
      (set! step? #t)
      (refresh))
    
    (define/public (move-left)
      (set! view-roty (+ view-roty 5.0))
      (refresh))
    
    (define/public (move-right)
      (set! view-roty (- view-roty 5.0))
      (refresh))
    
    (define/public (move-up)
      (set! view-rotx (+ view-rotx 5.0))
      (refresh))
    
    (define/public (move-down)
      (set! view-rotx (- view-rotx 5.0))
      (refresh))
    
    (define/public (slide-left)
      (set! view-roty (+ view-roty 5.0))
      (refresh))
    
    (define/public (slide-right)
      (set! view-roty (- view-roty 5.0))
      (refresh))
    
    (define/public (slide-up)
      (set! view-rotx (+ view-rotx 5.0))
      (refresh))
    
    (define/public (slide-down)
      (set! view-rotx (- view-rotx 5.0))
      (refresh))
    
    
    
    (define/override (on-size width height)
      (with-gl-context
       (lambda ()
         
         ;(unless gear1
         ; (printf "  RENDERER:   ~A\n" (gl-get-string 'renderer))
         ; (printf "  VERSION:    ~A\n" (gl-get-string 'version))
         ; (printf "  VENDOR:     ~A\n" (gl-get-string 'vendor))
         ; (printf "  EXTENSIONS: ~A\n" (gl-get-string 'extensions))
         ; )
         
         (gl-viewport 0 0 width height)
         (gl-matrix-mode 'projection)
         (gl-load-identity)
         (let ((h (/ height width)))
           (gl-frustum -1.0 1.0 (- h) h 5.0 60.0))
         (gl-matrix-mode 'modelview)
         (gl-load-identity)
         (gl-translate 0.0 0.0 -40.0)
         
         (gl-light-v 'light0 'position (vector->gl-float-vector
                                        (vector 5.0 5.0 10.0 0.0)))
         (gl-enable 'cull-face)
         (gl-enable 'lighting)
         ;(gl-disable 'lighting)
         (gl-enable 'light0)
         (gl-enable 'depth-test)
         
         (unless gear1
           
           (set! gear1 (gl-gen-lists 1))
           (gl-new-list gear1 'compile)
           (gl-material-v 'front
                          'ambient-and-diffuse
                          (vector->gl-float-vector (vector 0.8 0.1 0.0 1.0)))
           ;(build-gear 1.0 4.0 1.0 20 0.7)
           (gl-end-list)
           
           (set! gear2 (gl-gen-lists 1))
           (gl-new-list gear2 'compile)
           (gl-material-v 'front
                          'ambient-and-diffuse
                          (vector->gl-float-vector (vector 0.0 0.8 0.2 1.0)))
           ;(build-gear 0.5 2.0 2.0 10 0.7)
           (gl-end-list)
           
           (set! gear3 (gl-gen-lists 1))
           (gl-new-list gear3 'compile)
           (gl-material-v 'front
                          'ambient-and-diffuse
                          (vector->gl-float-vector (vector 0.2 0.2 1.0 1.0)))
           ;(build-gear 1.3 2.0 0.5 10 0.7)
           (gl-end-list)
           
           (gl-enable 'normalize))))
      (refresh))
    
    (define sec (current-seconds))
    (define frames 0)
    
    (define/override (on-paint)
      [with-gl-context [lambda []
                         (gl-push-matrix)
                         (gl-rotate view-rotx 1.0 0.0 0.0)
                         (gl-rotate view-roty 0.0 1.0 0.0)
                         (gl-rotate view-rotz 0.0 0.0 1.0)
                         
                         
                         [do-paint ]
                         (gl-pop-matrix)
                         (swap-gl-buffers)
                         (gl-flush)
                         ;(glFinish)
                         ; (sleep 1)
                         [when [not is-best-display] 
                           
                           
                           
                           ;[write new-score][newline]
                           [display "tick"][newline]
                           
                           
                           ]]]
      (when step?
        (set! step? #f)
        (queue-callback (lambda x (send this run)) #f ))
      )
    
    (super-instantiate () (style '(gl no-autoclear)))))

(define (gl-frame)
  (let* ((f (make-object frame% "gears.ss" #f))
         (c (new gears-canvas% (parent topwin) [best-display? #f] (min-width 400) (min-height 400) (stretchable-width #f) (stretchable-height #f) ))
         
         )
    (send f create-status-line)
    (when controls?
      (let ((h (instantiate horizontal-panel% (topwin)
                 (alignment '(center center)) (stretchable-height #f))))
        (instantiate button%
          ("Start" h (lambda (b e) (send b enable #f) (send c run)))
          (stretchable-width #t) (stretchable-height #t))
        
        
        (let ((h (instantiate horizontal-panel% (h)
                   (alignment '(center center)))))
          (instantiate button% ("Left" h (lambda x (send c move-left)))
            (stretchable-width #t))
          (let ((v (instantiate vertical-panel% (h)
                     (alignment '(center center)) (stretchable-width #f))))
            (instantiate button% ("Up" v (lambda x (send c move-up) ))
              (stretchable-width #t))
            (instantiate button% ("Down" v (lambda x (send c move-down)))
              (stretchable-width #t)))
          
          (instantiate button% ("Right" h (lambda x (send c move-right)))
            (stretchable-width #t))
          
          )
        
        (let ((h (instantiate horizontal-panel% (h)
                   (alignment '(center center)))))
          (instantiate button% ("Left" h (lambda x (send c slide-left)))
            (stretchable-width #t))
          (let ((v (instantiate vertical-panel% (h)
                     (alignment '(center center)) (stretchable-width #f))))
            (instantiate button% ("In" v (lambda x [begin (set! screen-scale [* screen-scale 2])(send c refresh)] ))
              (stretchable-width #t))
            (instantiate button% ("Out" v (lambda x [begin (set! screen-scale [* screen-scale 0.5])(send c refresh)]))
              (stretchable-width #t)))
          
          (instantiate button% ("Right" h (lambda x (send c slide-right)))
            (stretchable-width #t))
          
          )
        
        ))
    
    (send topwin show #t) ))

(gl-frame)
(send topwin show #t)