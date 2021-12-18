(module actinic-connection-cache mzscheme
  (provide hash-cache%)
  (require (lib "class.ss"))
    (define cache<%> (interface () add fetch cache-fill))
  (define hash-cache% 
    (class* object% (cache<%>)
      (init-field  
       (name "unnamed")
       (cache-size 500)
       ;(sem (make-semaphore 2))
       )
      (inherit )
      
      (define cache (make-hash-table 'equal))
      
      (define trim-cache
        (lambda ()
          ;(semaphore-wait sem)
          (if (> (car (cache-fill)) (cadr (cache-fill)))
              (hash-table-map cache (lambda (a-key a-val) (if (< 0 (random 4)) (hash-table-remove! cache a-key)))))
          ;(semaphore-post sem)
          ))
      
      
      (define/public add 
        (lambda (a-key a-val )
          
          ;(semaphore-wait sem)
          (hash-table-put! cache a-key a-val)
          (trim-cache)
          ;(semaphore-post sem)
          a-val))
      (define/public delete 
        (lambda (a-key)
          (hash-table-remove! cache a-key)))
      
      (define/public keymap
        (lambda (a-func)
          (hash-table-map cache a-func)))
      
      (define/public fetch
        (lambda (a-key a-thunk)
          ;(semaphore-wait sem)
          ;(display (format "Searching for ~s in ~s~n" a-key (hash-table-map cache (lambda (k v) k))))
          (let ([res (hash-table-get cache a-key a-thunk)])
            (add a-key res)
            ; (semaphore-post sem)
            res)))
      
      (define/public cache-fill
        (lambda () (list (length (hash-table-map cache (lambda (a b) #t))) cache-size)))
      
      (super-new  )
      )
    
    )
  
  )