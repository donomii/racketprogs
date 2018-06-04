(module web-crawler racket
  
  [require srfi/13]
  [require "stop-words.rkt"]
  ;(require (lib "selector.ss" "srfi" "1"))
  ;(require (lib "predicate.ss" "srfi" "1"))
  (require (prefix-in srfi- (lib "1.ss" "srfi")))
  (require (lib "pregexp.ss"))
  (require (planet "htmlprag.ss" ("neil" "htmlprag.plt" 1 3)))
  ;(require (planet "actinic.ss" ("jepri" "actinic.plt" 1 11)))
  (require (prefix-in srfi- (lib "13.ss" "srfi")))
  (require (lib "misc.ss" "swindle"))
  (require "actinic/src/actinic/actinic.ss")
  (require (planet "sqlite.ss" ("jaymccarthy" "sqlite.plt" 5 1)))
  ;(require "hashare/hashare.ss")
  (require (lib "class.ss"))
  (require "markov.scm")
  (require (planet lizorkin/sxml:2:1/sxml))
  (require racket/pretty)
  ;(require (planet dherman/json:3:0))
  [require "json.rkt"]
  (require racket/struct-info)
  [require "spath.rkt"]
  [require "markov.scm"]
  ;(set-debug-level 0)
  (define seen '())
  
  ;(define sqlite (open (build-path "C:\\Documents and Settings\\aarrr\\Application Data\\Mozilla\\Firefox\\Profiles\\zr81kls3.default\\bookmarks_history.sqlite")))
  (define sqlite (open (build-path "c:\\Users\\user\\Desktop\\taxon.sqlite")))
  ;(display (select sqlite "select * from sqlite_master;"))
  ;(display (select sqlite "select url from moz_history;"))
  
  
  
  [define set-transport [lambda args #f]]
  [define hashare-open [lambda args #f]]
  [define upload-data [lambda args #f]]
  ;  [define select [lambda args #f]]
  ;  [define sqlite [lambda args #f]]
  (set-transport 'cgi)
  (define handle (hashare-open "webrip" "password" "http://192.168.0.37/"))
  (define seen? (lambda (a-key)
                  
                  (if (assoc a-key seen)
                      #t
                      (begin
                        (cons (cons a-key  #t) seen)
                        #f))))
  (define CB-cache '())
  (define cache-size 100)
  
  (define add-to-CB-cache
    (lambda ( key value )
      (display (format "adding key ~a~n" key))
      (when (not (assoc key CB-cache))
        (begin
          (set! CB-cache (cons (cons key value) CB-cache))
          (when (> (length CB-cache) cache-size)
            (set! CB-cache (srfi-take CB-cache cache-size)))))
      value))
  
  (define CB-cache-fetch
    (lambda ( key)
      (if (assoc key CB-cache)
          (cdr (assoc key CB-cache))
          #f)))
  ;(actinic-run-tests)
  ;(exit)
  
  ; urlise string or url -> url
  ; turns a string into a url (urls are a type) or passes a url stright through without modification
  ; Useful when I don't know or care whether a function returns a url or string
  
  
  (define shtml-get (lambda ( a-url ) 
                      (display (format "Getting ~a~n" a-url))
                      
                      (let ((result (if (CB-cache-fetch a-url)
                                        (CB-cache-fetch a-url)
                                        (add-to-CB-cache a-url (simple-get a-url)))))
                        (when result (html->shtml (bytes->string/utf-8 (let-values (((a b c) (bytes-convert (bytes-open-converter "UTF-8-permissive" "UTF-8") result))) a)))))))
  
  
  (define text->shtml (lambda ( a-text ) 
                        [if [equal? a-text '[]] ""
                            [if [string? a-text]
                                a-text
                                [if [bytes? a-text]                    
                                    (html->shtml (bytes->string/utf-8 (let-values (((a b c) (bytes-convert (bytes-open-converter "UTF-8-permissive" "UTF-8") a-text))) a)))
                                    a-text]]]))
  (define extract-url (lambda ( a-list)
                        ;(display (format "Working on: ~a~n" a-list))
                        ;(display (format "~s~n" (caar (cdr (car (cdr a-list))))))
                        ;(if (equal? 'href (caar (cdr (car (cdr a-list)))))                
                        ;(list  (cadar (cdr (car (cdr a-list)))))
                        ;'()       )
                        (if (> (length (cdr a-list)) 0)
                            (if (and
                                 (assoc 'href (cdr (car (cdr a-list))))
                                 (< 1 (length (assoc 'href (cdr (car (cdr a-list)))))))
                                (list  (cadr (assoc 'href (cdr (car (cdr a-list))))))
                                '()       )
                            '())
                        ))
  
  (define extract-img (lambda ( a-list)
                        ;(display (format "Searching for images in: ~a~n" a-list))
                        ;(display (format "Image: ~s~n"  (cadr (assoc 'src (cdr (car (cdr a-list)))))))
                        (if (and
                             (assoc 'src (cdr (car (cdr a-list))))
                             (< 1 (length (assoc 'src (cdr (car (cdr a-list)))))))
                            (list  (cadr (assoc 'src (cdr (car (cdr a-list))))))
                            '()       )))
  
  (define grab-urls
    (lambda (a-tree)
      ;(display a-tree)
      ; (filter-map (lambda (i) i)
      (if (srfi-proper-list? a-tree)
          (case (car a-tree)
            ((a) (extract-url a-tree))
            (else (srfi-append-map (lambda (a-thing) (grab-urls a-thing)) a-tree) ))
          '())))
  
  
  
  (define grab-imgs
    (lambda (a-tree)
      ;(display a-tree)
      ; (filter-map (lambda (i) i)
      (if (srfi-proper-list? a-tree)
          (case (car a-tree)
            ((img) (extract-img a-tree))
            (else (srfi-append-map (lambda (a-thing) (grab-imgs a-thing)) a-tree) ))
          '())))
  
  (define slurp-string (lambda (a-port)
                         (let ((line (read-line a-port 'any)))
                           (if (eof-object? line) 
                               ""
                               (string-append line (format "~n") (slurp-string a-port))))))
  
  (define slurp-bytes (lambda (a-port)
                        (let ((line (read-bytes 9999 a-port)))
                          (if (eof-object? line) 
                              #""
                              (bytes-append line (slurp-bytes a-port))))))
  
  
  (define urls-get (lambda (a-url) (map (make-url-completer (make-base-url a-url))(grab-urls (shtml-get a-url)))))
  (define file-urls-get (lambda (filename) (grab-urls (html->shtml (slurp-string (open-input-file filename))))))
  (define imgs-get (lambda (a-url) (map (make-url-completer (make-base-url a-url))(grab-imgs (shtml-get a-url)))))
  (define grab-text-recurse
    (lambda (a-tree)
      (apply string-append(map (lambda (i) 
                                 (if (srfi-proper-list? i) 
                                     (grab-text i)
                                     ""))
                               a-tree))))
  (define grab-text
    (lambda (a-tree)
      ;(display a-tree)
      ; (filter-map (lambda (i) i)
      (if [and (srfi-proper-list? a-tree) [pair? a-tree]]
          (case (car a-tree)
            ((script head @ *COMMENT*) "")
            ((table td tr font &) (grab-text-recurse a-tree))
            (else (string-append ;(format "~a:" (car a-tree))
                   (apply string-append  (map (lambda (i) (if (srfi-proper-list? i) (grab-text i)
                                                              (if (string? i) i ""))) a-tree) )
                   ;(format "~n")
                   )))
          "")))
  (define make-base-url 
    (lambda (a-url)
      (let* ((end-bit (regexp-replace* ".*/" a-url ""))
             (base-url (regexp-replace (pregexp-quote end-bit) a-url "")))
        base-url)))        
  ;(write (shtml-get "http://www.yahoo.com/"))
  ;(map grab-text
  ;     (map shtml-get
  ;          (map url->string
  ;(map (lambda (i) (combine-url/relative (string->url "http://yahoo.com/") (cadr (cadr (cadr i))))) (grab-urls (shtml-get "http://www.yahoo.com/"))))))
  
  ;(http-get "http://www.w3c.com/")
  
  (define download-file (lambda (x)
                          ;(current-directory "C:\\Documents and Settings\\aarrr\\My Documents\\stuff")
                          ;(let ((fname  (pregexp-replace* ".*/|\\r" x "")))
                          (display (format "saving ~a" x))
                          ;(with-handlers ([exn:fail? (lambda (exn) (display (format "File ~a-~a already exists, won't save over it~n" (jrl-server x) fname)))])
                          (let ((content  (simple-get x)))
                            (when (> (bytes-length content) 40000)
                              (begin
                                (upload-data (list "Top Level" "saved" ) x content handle)
                                #t
                                )))))
  ;(with-output-to-file (format "~a-~a" (jrl-server x) fname)
  ;  (lambda ()
  ;  (display content)))))))
  
  
  (define download-images (lambda (a-url)
                            (display (format "downloading images for ~a~n" a-url))                          
                            
                            (map 
                             download-file (imgs-get a-url))))
  
  (define text-get
    (lambda (a-url)
      ;(pregexp-replace* "\\n+" 
      (grab-text (shtml-get a-url))
      ;(format "~n"))
      ))
  (define complete-url (lambda (base-url a-url)
                         (if (pregexp-match "://" a-url)
                             a-url
                             (build-jrl base-url "/" a-url))))
  (define make-url-completer (lambda ( base-url )
                               (lambda (a-url) (complete-url base-url a-url))))
  
  ;(define text-page (text-get "http://www.adventureclassicgaming.com/index.php/site/interviews/198/"))
  ;(define text-list (regexp-split  " +|\r\n|\r|\n" text-page))
  
  ;(send markov insert-list text-list)
  
  (define markov1 (new markov%))
  (define markov2 (new markov%))
  (define markov3 (new markov%))
  (define markov4 (new markov%))
  
  ;(send markov1 insert-text (text-get "http://hotair.com/archives/top-picks/2006/07/29/report-mel-gibson-erupts-with-jew-hate-after-dwi-arrest/"))
  ;(send markov2 insert-text (text-get "http://www.outsidethebeltway.com/archives/2006/07/the_passion_of_the_drunken_gibson_jew_hating/"))
  ;(send markov3 insert-list (regexp-split  " +|\r\n|\r|\n" (text-get "http://news.yahoo.com/s/ap/20060730/ap_on_re_mi_ea/iraq")))
  ;(send markov4 insert-list (regexp-split  " +|\r\n|\r|\n" (text-get "http://www.bloomberg.com/apps/news?pid=20601085&sid=aC4g_XrRiUp4&refer=europe")))
  
  
  ;(dotimes (x 100) (display (format "Mel -> ~a~n" (send markov1 next-link "Mel"))))
  ;(send markov1 popular-link "Mel")
  ;(display (format "First diff: ~a~n" (exact->inexact (send markov1 normalised-similarity markov2))))
  ;(display (format "Second diff: ~a~n" (send markov1 similarity markov3)))
  ;(display (format "Third diff: ~a~n" (send markov4 similarity markov3)))
  ;(display (format "fourth diff: ~a~n" (send markov4 similarity markov4)))
  ;(send markov1 deserialise (send markov1 serialise))
  ;(send markov1 serialise)
  ;(exit)
  
  
  
  
  ;(map
  ; (lambda (a-url)
  ;   (let (( markov (new markov%)))
  ;   ;(with-handlers ([exn:fail? (lambda (exn) (display (format "Could not download ~a~n" a-url)))])
  ;(send markov insert-list  (regexp-split " +|\r\n|\r|\n" (text-get a-url)))
  ;     markov))
  ;(urls-get "http://news.google.com/?ncl=http://www.theaustralian.news.com.au/common/story_page/0,5744,19965491%25255E31477,00.html&hl=en"))
  
  ;(display (text-get "http://babylon.alphacomplex.org"))
  ;(display (text-get "http://www.penny-arcade.com"))
  ;(display (text-get "http://www.icir.org/vern/papers/cdc-usenix-sec02/"))
  ;(display (urls-get "http://reddit.com/"))
  ;(display (text-get "http://www.penny-arcade.com"))
  ;(display (urls-get "http://reddit.com/"))
  ;(make-base-url "http://www.nsgalleries.com/hosted1/ns/gals/violet/index.php?id=101989")
  ;(download-images "http://www.nsgalleries.com/hosted1/ns/gals/violet/index.php?id=101989")
  ;(simple-get "http://clitlickinlesbians.com/ps_19465_I_1")
  ;(download-images "http://clitlickinlesbians.com/ps_19465_I_1")
  ;(download-images "http://www.18fu.com/02a16girlgir005/lustylezzies.htm")
  ;(exit)
  
  
  (define-syntax threaded-map
    (syntax-rules ()
      ((threaded-map a-func a-list)
       (begin
         (display "Entering threaded map")
         (let ((cr-list (map (lambda (x) 
                               (let ((c (make-channel )))
                                 (thread  (lambda ( ) (channel-put c (a-func x))))
                                 c))   a-list)))
           
           
           (let keep-going ()
             (let ((result (map  channel-get cr-list)))
               ;(db 0 (format "Results map: ~s~n" res))
               ;(display ".")
               (if (andmap (lambda (x) x) result)
                   (begin
                     ;(collect-garbage)
                     result)
                   (begin
                     (sleep 1)
                     (keep-going))))))))))
  
  
  
  (define download-links (lambda (a-url)   
                           
                           (map (lambda (x)
                                  (if (or 
                                       (regexp-match "jpg" x )
                                       (regexp-match ".png" x )
                                       (regexp-match "gif" x )
                                       (regexp-match "wmv" x )
                                       (regexp-match "mpg" x ))
                                      (begin
                                        (display (format "Downloading ~s~n" x))
                                        (download-file x))
                                      (display (format "Rejecting ~s~n" x))
                                      ))
                                (urls-get a-url))))
  
  ;(download-links "http://www.nsgalleries.com/hosted1/ns/gals/violet/index.php?id=101989")
  ;(simple-get "http://gallery.infemdom.com/?403/0/4/17/754")
  ;(download-links "http://gallery.infemdom.com/?403/0/4/17/754")
  ;(download-links "http://www.damseldiary.com/free/bo/madison/1/428")
  ;(download-links "http://free.lesbian-strapon.com/lesbian/strapon-domination2/sex/strapgip/")
  ;(download-links "http://www.lesbiangirls.ws/z0199h/freesixlistvideos.html")
  ;(download-links "http://tgp.lezdom.com/01/CE_Morrigan_Delilah_Again_4/NTAwNDA6Mjo5/")
  ;(download-links "http://sisterseduction.be/out.php?t=1.0.73.2180&url=http%3A%2F%2Ffree.straponall.com%2Fstrapon%2Ffemdom%2Fact%2Fclan%2F&link=Main_2")
  ;(simple-get "http://sisterseduction.be/out.php?t=1.0.73.2180&url=http%3A%2F%2Ffree.straponall.com%2Fstrapon%2Ffemdom%2Fact%2Fclan%2F&link=Main_2")
  
  
  
  (define rip-page (lambda (a-url maxdepth depth)
                     (when (not (< maxdepth depth))
                       (begin
                         (when (not (seen? a-url))
                           (begin
                             (display (format "Ripping page ~s~n" a-url))
                             
                             (with-handlers ([exn:fail? (lambda (exn) (display (format "Could not download images for ~a: ~a~n" a-url (exn-message exn))))])
                               ;First download images from the page
                               (download-images a-url))
                             (with-handlers ([exn:fail? (lambda (exn) (display (format "Could not download linked goodies for ~a: ~a~n" a-url (exn-message exn))))])
                               ;Then any image linked from the page
                               (download-links a-url))
                             
                             (with-handlers ([exn:fail? (lambda (exn) (display (format "Could not recurse past ~a~n" a-url)))])
                               
                               ;curry rip page for map
                               (let ((next-page (lambda (page) (rip-page page maxdepth (+ 1 depth)))))
                                 
                                 ;Then finally rip any linked pages
                                 (map next-page
                                      (urls-get a-url))))))))))
  
  
  
  
  
  (define history-read
    (lambda (fname)
      ;    (srfi-filter-map (lambda (a) (if (regexp-match "lesb" a) a #f))
      (map (lambda (x) x)
           (map (lambda (a) (vector-ref a 0)) (cdr (select sqlite "select url from moz_history;"))))))
  
  (define history-rip
    (lambda (filename maxdepth depth)
      (let ((next-page (lambda (page) (rip-page page maxdepth (+ 1 depth)))))
        
        ;Then finally rip any linked pages
        (let ((links        (history-read filename )))
          ;(write "links:")
          ;(write links)
          (thread (lambda () (map next-page (srfi-take  links (quotient (length links) 2)))))
          (thread (lambda () (map next-page (srfi-drop  links (quotient (length links) 2)))))))))
  ;(thread (lambda () (rip-page "http://fusker.usanurse.org/index.php?method=random&17129" 1 0)))
  ;(thread (lambda () (history-rip "C:\\Documents and Settings\\aarrr\\Application Data\\Mozilla\\Firefox\\Profiles\\zr81kls3.default\\history.dat" 1 0)))
  ;(rip-page "http://dir.yahoo.com/Arts/Visual_Arts/Computer_Generated/Graphics/" 2 0)
  ;(rip-page "http://reddit.com/" 2 0)
  ;(rip-page "http://commons.wikimedia.org/w/index.php?title=Category:PD_Old" 2 0)
  ;(display (rip-page "http://commons.wikimedia.org/w/index.php?title=Category:PD_Old" 2 0))
  ;(display (rip-page "http://www.fark.com/" 1 0))
  
  ;[display [shtml-get "http://www.reddit.com/r/gaming/comments/jv0hi/modernday_assassins_creed/"]]
  ;[pretty-write  [map [sxpath "//div/div/../../.."] [srfi-take  ((sxpath "//div/div[@class='noncollapsed']/form[@class='usertext']/..") [shtml-get "http://www.reddit.com/r/gaming/comments/jv0hi/modernday_assassins_creed/"]) 10]]]
  ;[pretty-write  [filter [lambda [x] ] ((sxpath "//a") [shtml-get "http://www.reddit.com/r/gaming/comments/jv0hi/modernday_assassins_creed/"]) 10]]]
  
  [define find-root-comments [lambda [alist]
                               [filter [lambda [x] [equal? #f [cadr x]]] alist]
                               ]]
  [define find-children [lambda [parent alist]
                          [filter [lambda [x] [equal?[car parent] [cadr x]]] alist]
                          ]]
  [define sxpath-extract-hrefs [sxpath "//@href"]]
  [define sxpath-extract-comment-divs [sxpath "//form/div/div"]]
  [define sxpath-extract-anchors [sxpath "//a"]]
  ;Given a sxml chunk of a comment thread from reddit, will extract the comment, comment id, and parent id
  [define extract-parent-perma-links [lambda [atree]
                                       [let [[links [filter 
                                                     [lambda [y] [or [equal? "parent" [caddr y]] [equal? "permalink" [caddr y]]]] 
                                                     [filter 
                                                      [lambda [x] [> [length x] 2]] 
                                                      [srfi-concatenate  
                                                       [map  sxpath-extract-anchors 
                                                             atree]]]]]
                                             [parent #f]
                                             [id #f]
                                             [comment [sxpath-extract-comment-divs atree]]]
                                         [map [lambda [x] [when [equal? "parent" [caddr x]] [set! parent [regexp-replace "#" [cadar [sxpath-extract-hrefs x]] ""]]]
                                                [when [equal? "permalink" [caddr x]] [set! id [string-reverse [cadr [regexp-match "^(.*?)/" [string-reverse [cadar [[sxpath "//@href"] x]]]]]]]]] links]
                                         [list id parent comment]
                                         ]]]
  
  ;  [define print-comment [lambda [indent  data]
  ;                          [display [make-string indent #\+]]
  ;                               [display [grab-text [caddr data]]]
  ;                          [newline]]]
  [define print-comment [lambda [indent  data]
                          #t]]
  [define print-comment-tree [lambda [acomment indent alist ]
                               [letrec [[parent [cadr acomment]]
                                        [children [find-children acomment alist]]]
                                 [print-comment indent acomment]
                                 [when [< 0 [length children]]
                                   [map[lambda [x] [print-comment-tree x [add1 indent]  alist]] children]]
                                 
                                 ]]]
  ;[pretty-write [extract-parent-perma-links [srfi-take  ((sxpath "//div/div[@class='noncollapsed']/form[@class='usertext']/..") [shtml-get "http://www.reddit.com/r/gaming/comments/jv0hi/modernday_assassins_creed/"]) 10]]]
  
  [define extract-words-from-text [lambda [a-text] 
                                    [regexp-split "[,!? :\n.)(/\"]+" a-text]
                                    ]]
  [define extract-words-from-comment [lambda [a-comment] 
                                       [extract-words-from-text [grab-text [caddr a-comment]]]
                                       ]]
  [define extract-words-from-comments [lambda [comments]
                                        [srfi-concatenate [map extract-words-from-comment comments]]
                                        ]]
  [define sxpath-extract-comments (sxpath "//div/div[@class='noncollapsed']/form[@class='usertext']/..") ]
  [define rip-comments-page [lambda [a-page]
                              ;                              [let [[comments [ map 
                              ;                                                extract-parent-perma-links  
                              ;                                                ((sxpath "//div/div[@class='noncollapsed']/form[@class='usertext']/..") a-page) ]]]
                              ;                                
                              ;                                [map [lambda [x] [print-comment-tree x 0 comments]]   [find-root-comments comments] ]
                              ;                                comments]
                              [ map extract-parent-perma-links (sxpath-extract-comments a-page) ]]]
  
  [define cache-get [lambda [a-href]
                      [letrec  [[a-page[select sqlite "select data from page_cache where url=?;" a-href]]]
                        [if [equal? '[] a-page] 
                            [begin [display [format "Not in cache, downloading ~a~n" a-href]]
                                   [simple-get a-href]]
                            [begin [display [format "Found in cache,  ~a~n" a-href]]
                                   [car [vector->list [cadr a-page]]]]]]
                      ]]
  [define shtml-cache-get [lambda [a-href] 
                            [letrec  [[a-page [select sqlite "select data from page_cache where url=?;" a-href]]]
                              ;[display [format "Got soemthing from cache: ~a~n" a-page]]
                              [if [equal? '[] a-page] 
                                  [begin [display [format "Not in cache, downloading ~a~n" a-href]]
                                         ;[display [simple-get a-href]]
                                         [text->shtml [simple-get a-href]]]
                                  [begin 
                                    ;[write [car [vector->list [cadr a-page]]]]
                                    [display [format "Found in cache,  ~a~n" a-href]]
                                    [text->shtml [car [vector->list [cadr a-page]]]]]]]]]
  
  [define mastercount [make-hash]]
  [define tags-to-hrefs [make-hash]]
  
  [define text-to-tags [lambda [a-text]
                         [map 
                          string-downcase 
                          ;[extract-words-from-comments [rip-comments-page a-page]]
                          [extract-words-from-text a-text]
                          ]]]
  [define insert-and-return-tag-id [lambda [a-tag]
                                     (with-handlers ([exn? (lambda (e) 
                                                             ;[display [format "Already stored, instead retrieving ~a~n" a-tag]]
                                                             
                                                             [car [vector->list [cadr [select sqlite "select rowid from tags where tag=?;" [format "~a" a-tag]]]]])])
                                       [do-sql "INSERT INTO tags VALUES  (?);"
                                        [format "~a" a-tag]
                                         ]
                                       (last-insert-rowid sqlite))
                                     ]]
  [define ingest [lambda [a-href a-shtml a-href-id]  
                   [exec/ignore  sqlite  update-page-title-sql [grab-text ((sxpath "//a[@class='title ']") [shtml-cache-get [symbol->string a-href]])] a-href-id]
                   ;[reset update-page-title-sql]
                   (with-transaction (sqlite fail)
                                     [map [lambda [x] 
                                            ;[display x]
                                            ;[hash-update! mastercount x [lambda [y] [add1 y]] 0]
                                            ;[hash-update! tags-to-hrefs x [lambda [y] [hash-set! y a-href-symbol 1] y] make-hash]
                                            
                                            (with-handlers ([exn? (lambda (e) 
                                                                    
                                                                    "dup")])
                                              
                                              [exec/ignore sqlite insert-tag-for-url-sql a-href-id [insert-and-return-tag-id x]]
                                              ;[reset insert-tag-for-url-sql]
                                              )
                                            #f][text-to-tags  [grab-text a-shtml]]]
                                     
                                     [exec/ignore sqlite update-page-processing-complete-sql [format "~a" a-href]])
                   
                   "ingested"]]
  [define ingest-from-cache-href [lambda [a-href a-href-id]  
                                   
                                   [ingest [string->symbol a-href ][shtml-cache-get a-href] a-href-id]]
    
    ]
  
  ;[ingest-href "http://www.reddit.com/r/gaming/comments/jv0hi/modernday_assassins_creed/"]
  
  
  
  ;Returns a list of strings that are hrefs to reddit comments
  [define get-comments-links [lambda [a-href]
                               [map cadar 
                                    [map [sxpath "//@href"] 
                                         ((sxpath "//a[@class='comments']") 
                                          [shtml-cache-get a-href])]]]]
  
  [define get-next-page-href [lambda [a-href]
                               (with-handlers ([exn? (lambda (e) #f)])
                                 [cadar [[sxpath "//@href"] ((sxpath "//a[@rel='nofollow next']") [shtml-get a-href])]])]]
  
  ; [map rip-comments-page [take  [get-comments-links "http://www.reddit.com/"] 1]]
  [define insert-page-sql "INSERT INTO page_cache (url, data) VALUES  (?, ?);"]
  [define update-page-sql "UPDATE page_cache SET data=?, processed='false' WHERE url=?;"]
  [define update-page-processing-complete-sql "UPDATE page_cache SET processed='true' WHERE url=?;"]
  [define update-page-title-sql  "UPDATE page_cache SET title=? WHERE rowid=?;"]
  [define insert-tag-for-url-sql  "INSERT INTO tags_to_pages (url, tag) VALUES (?,?)"]
  [define insert-trigram-sql  "INSERT INTO trigrams (gram, count) VALUES (?,1)"]
  [define increment-trigram-sql  "UPDATE trigrams SET count = count + 1 WHERE gram=?;"]
  [define insert-quadgram-sql "INSERT INTO quadgrams (gram, count) VALUES (?,1)"]
  [define increment-quadgram-sql "UPDATE quadgrams SET count = count + 1 WHERE gram=?;"]
  [define delete-cached-url-sql  "DELETE from page_cache WHERE url=?;"]
  ;[define urls-for-tag-sql [prepare sqlite "select page_cache.url from page_cache,tags_to_pages,tags where page_cache.rowid=tags_to_pages.url and tags_to_pages.tag=tags.rowid and tags.tag=?;"]]
  ;
  [define download-and-cache [lambda [the-href recurse-count] 
                               
                               [when [and  [> recurse-count 0] the-href]
                                 [map [lambda [href]
                                        
                                        [sleep 2]
                                        [let [[a-href [string-append href "abc1010.json"]]]
                                          [display [format "Fetching ~a~n" a-href]]
                                          [let [[a-page [simple-get a-href]]]
                                            (with-handlers ([exn? (lambda (e) 
                                                                    ;[display [format "Already stored, instead updating ~a~n" a-href]]
                                                                    [exec/ignore sqlite  update-page-sql  a-page a-href])])
                                              [exec/ignore sqlite  insert-page-sql a-href a-page])]]]
                                      [get-comments-links the-href] ]
                                 [download-and-cache [get-next-page-href the-href] [sub1 recurse-count]]
                                 ]
                               "downloaed-and-cached"]]
  ;[pretty-write [get-comments-links "http://www.reddit.com/"]] 
  [define suck [lambda []
                 [download-and-cache "http://www.reddit.com/" 30]
                 [download-and-cache "http://www.reddit.com/r/new" 30]
                 [download-and-cache "http://www.reddit.com/r/pics/" 30]
                 [download-and-cache "http://www.reddit.com/r/funny/" 30]
                 [download-and-cache "http://www.reddit.com/r/IAmA/" 30]
                 [download-and-cache "http://www.reddit.com/r/reddit.com/" 30]
                 [download-and-cache "http://www.reddit.com/r/gaming/" 30]
                 [download-and-cache "http://www.reddit.com/r/worldnews/" 30]
                 [download-and-cache "http://www.reddit.com/r/politics/" 30]
                 [download-and-cache "http://www.reddit.com/r/AskReddit/" 30]
                 [download-and-cache "http://www.reddit.com/r/todayilearned/" 30]
                 [download-and-cache "http://www.reddit.com/r/news/" 30]
                 [download-and-cache "http://www.reddit.com/r/atheism/" 30]
                 [download-and-cache "http://www.reddit.com/r/circlejerk/" 30]
                 [download-and-cache "http://www.reddit.com/r/science/" 30]
                 [download-and-cache "http://www.reddit.com/r/answers/" 30]
                 
                 [download-and-cache "http://www.reddit.com/r/PoliticalDiscussion+Progressive+Democrats+Democracy+Republicans+Republican+Worldpolitics+Worldnews+Worldevents+StateoftheUnion+News+Media+USPolitics+2012Elections+Campaigns+Socialism+AntiWar+Demsocialist+Libertarian+RonPaul+Liberty+LibertarianLeft+Liberal+NeoProgs+Anarchism+AnarchistNews+FirstAmendment+Environment+Green+Obama+Politicalhumor+Conservative+rpac+Electionreform+Wikileaks+Greenparty+Anarcho_Capitalism+Centrist+ModeratePolitics+Peoplesparty+Labor+NewRight+IHateFoxNews+AlltheLeft+communism+Economics+Bad_Cop_No_Donut+RvBdebates+OccupyWallStreet+Leninism" 30]
                 [download-and-cache "http://www.reddit.com/r/maths/" 30]
                 [download-and-cache "http://www.reddit.com/r/math/" 30]
                 [download-and-cache "http://www.reddit.com/r/askscience/" 30]
                                  [download-and-cache "http://www.reddit.com/r/TrueReddit/" 30]
                                  [download-and-cache "http://www.reddit.com/r/learnprogramming/" 30]
                                  [download-and-cache "http://www.reddit.com/r/buddhism/" 30]
                                  [download-and-cache "http://www.reddit.com/r/diy/" 30]
                 [download-and-cache "http://www.reddit.com/r/seduction/" 30]
                 [download-and-cache "http://www.reddit.com/r/libertarian/" 30]
                 [download-and-cache "http://www.reddit.com/r/askreddit/" 30]
                 [download-and-cache "http://www.reddit.com/r/mensrights/" 30]
                 [download-and-cache "http://www.reddit.com/r/shitredditsays/" 30]
                 [download-and-cache "http://www.reddit.com/r/twoxchromosomes/" 30]
                 [download-and-cache "http://www.reddit.com/r/conspiracy/" 30]
                 [download-and-cache "http://www.reddit.com/r/all/" 30]
                 [download-and-cache "http://www.reddit.com/r/bestof/" 30]
                 [download-and-cache "http://www.reddit.com/r/worstof/" 30]
                 [download-and-cache "http://www.reddit.com/r/Pareidolia/" 30]
                 [download-and-cache "http://www.reddit.com/r/feminsisms/" 30]
                 [download-and-cache "http://www.reddit.com/r/collapse/" 30]
                 [download-and-cache "http://www.reddit.com/r/cogsci/" 30]
                 [download-and-cache "http://www.reddit.com/r/depthhub/" 30]
                 [download-and-cache "http://www.reddit.com/r/philosophy/" 30]
                 [download-and-cache "http://www.reddit.com/r/nihilism/" 30]
                 [download-and-cache "http://www.reddit.com/r/datasets/" 30]
                 [download-and-cache "http://www.reddit.com/r/fifthworldproblems/" 30]
                 ]]
  
  ;[sxpath-extract-comment-divs [shtml-cache-get "http://www.reddit.com/r/reddit.com/comments/jxdp5/voltaire_when_asked_on_his_deathbed_to_renounce/"]]
  
   ;[exit]
  ;[bytes->string/utf-8[simple-get "http://www.reddit.com/comments/70ehq/obama_to_palindont_mock_the_constitution_dont/.json"]]
  [define [genexample a-func . in-list] [format "(~a ~a) -> ~s" [object-name a-func] [string-concatenate [map [lambda [x] [format "~s" x]] in-list]] [apply a-func in-list]]]
  [define [genexample-l a-func a-list] [apply genexample [cons a-func a-list]]]
  [define [genexamples a-func  example-list] [map [lambda [x] [genexample-l a-func x]] example-list]]
  [map [lambda [x] [display [format "~a~n" x]]] [genexamples json  '[["3.14159e+23"] ["[1, 2, 3 , 4,5]"] ["[0,{\"1\":{\"2\":{\"3\":{\"4\":[5,{\"6\":7}]}}}}]"]]]]
  
  ;[exit]
  [define cdrassoc [lambda [v l] 
                     [with-handlers [[exn:fail? [lambda [e] [display [format "Could not find ~a in ~a~n" v l ]] #f]]]
                       [cdr [assoc v l]]]]]
  [define cadrassoc [lambda [v l] [cdr [assoc v l]]]]
  
  [define extract-postdata [lambda [a-jsexpr]  [cdrassoc "data" [car [cadrassoc "children" [cdrassoc "data" [car a-jsexpr]]]]]]]
  
  [define extract-children [lambda [a-jsexpr]   [cadrassoc "children" [cdrassoc "data" a-jsexpr]]]]
  [define insert-trigrams-rec [lambda [a b c word-list]
                                [let [[trigram [format "~a ~a ~a" a b c]]]
                                  (with-handlers ([exn? (lambda (e) [exec/ignore sqlite increment-trigram-sql   trigram] )])
                                    [exec/ignore sqlite insert-trigram-sql   trigram] )
                                  ]
                                [when [> [length word-list] 0]
                                  [insert-trigrams-rec b c [car word-list] [cdr word-list]]]
                                ]]
  [define insert-trigrams [lambda [ word-list] 
                            [when [> [length word-list] 2] [insert-trigrams-rec [car word-list] [second word-list] [third word-list] [cdddr word-list]]]]]
  [define do-sql [lambda args [let [[sql-query [prepare sqlite [car args]]]]
                                [apply run [cons sql-query [cdr args]]]
                                [finalize sql-query]]]]
  [define insert-quadgrams-rec [lambda [a b c d word-list]
                                [let [[quadgram [format "~a ~a ~a ~a" a b c d]]]
                                  (with-handlers ([exn? (lambda (e) [exec/ignore sqlite increment-quadgram-sql   quadgram] )])
                                    [exec/ignore sqlite insert-quadgram-sql   quadgram] )
                                  ]
                                [when [> [length word-list] 0]
                                  [insert-quadgrams-rec b c  d[car word-list] [cdr word-list]]]
                                ]]
  [define insert-quadgrams [lambda [ word-list] 
                            [when [> [length word-list] 3] [insert-quadgrams-rec [car word-list] [second word-list] [third word-list] [fourth word-list] [cddddr word-list]]]]]
  [define markov [new markov%]]
  [send markov load-from-file "C:/Users/user/Desktop/knowledge-abse-markov.txt"]
  [define [add-to-markov word-list]
    [when [< 1 [length word-list]]
      [map [λ [word] [send markov add [car word-list] word]] [cdr word-list]]
      [add-to-markov [cdr word-list]]]]
    
    
  [define process-comments [lambda [c]
                             [let [[d [cdrassoc "data" c]]]
                               ;[display [format "Inserting comment ~a~n" [cdrassoc "name" d]]]
                               [when [cdrassoc "body" d]
                                 [with-handlers [[exn? [lambda [e] #f]]]
                                   [display [format "Inserting comment: ~a~n" [cdrassoc "body" d]]]
                                   [do-sql "INSERT INTO comments (body, author, downs, ups, id, name, 
parent_id,link_id) VALUES (?,?,?,?,?,?,?,?);"
                                        
                                        [cdrassoc "body" d][cdrassoc "author" d][cdrassoc "downs" d][cdrassoc "ups" d][cdrassoc "id" d]
                                        [cdrassoc "name" d][cdrassoc "parent_id" d][cdrassoc "link_id" d]
                                        ]]
                                 
                                 (with-transaction (sqlite fail)
                                                   [map [lambda [x]
                                                          (with-handlers ([exn? (lambda (e)  "dup")])
                                                            [exec/ignore sqlite insert-tag-for-url-sql [cdrassoc "link_id" d] [insert-and-return-tag-id x]] )
                                                          #f] [text-to-tags  [cdrassoc "body" d]]]
                                                   [add-to-markov [text-to-tags  [cdrassoc "body" d]] ]
                                                  ; [with-handlers [[exn:fail? [λ args #f]]]]
                                                     ;[delete-file "knowledge-abse.bak"]
                                                   ;(rename-file-or-directory	 	"knowledge-abse-markov.txt" "knowledge-abse.bak")
                                                            
                                                   [insert-trigrams [text-to-tags  [cdrassoc "body" d]]]
                                                   [insert-quadgrams [text-to-tags  [cdrassoc "body" d]]]
                                                   )
                                 
                                 [let [[replies [cdrassoc "replies" d]]]
                                   [when [not [equal? "" replies]]
                                     [map process-comments [extract-children [cdr replies] ]]
                                      ]]
                                 [cdrassoc "body" d]
                                 ]]]]
 ;[simple-get "http://www.reddit.com/r/IAmA/comments/jzfgc/iama_male_who_met_his_fiancée_on_runescape_ama/abc1010.json"] 
  ;[exit]
  [define process-url [lambda [a-url]
                        [let [[ url-text [cache-get a-url]]]
                          
                          [display [format "Parsing and extracting postdata:~n"]]
                          [let [[jsexpr (with-handlers ([exn? (lambda (e) [display [format "Failed to parse ~a~n" a-url]]#f)]) [json [bytes->string/utf-8 url-text]])]]
                            [if [not jsexpr]
                                [exec/ignore sqlite delete-cached-url-sql a-url]
                              [let [  [d [extract-postdata jsexpr]]]
                                [display [format "Done~n"]]
                                [with-handlers [[exn? [lambda [e] #f]]]
                                  [do-sql  "INSERT INTO posts (domain, subreddit, selftext, id, title, over_18, 
subreddit_id,is_self,permalink,name,url,downs,ups) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?);"
                                  
                                       [cdrassoc "domain" d][cdrassoc "subreddit" d][cdrassoc "selftext" d][cdrassoc "id" d][cdrassoc "title" d]
                                       [cdrassoc "over_18" d][cdrassoc "subreddit_id" d][cdrassoc "is_self" d][cdrassoc "permalink" d][cdrassoc "name" d]
                                       [cdrassoc "url" d][cdrassoc "downs" d][cdrassoc "ups" d]]
                                    ]
                                [display [format "Inserted postdata into database~n"]]
                                [display [format "Inserting comments into database~n"]]
                                [map [lambda [x] [display "."] [process-comments x]] [extract-children [cadr jsexpr]]]
                                [display "~nComments inserted~n"]
                                [call-with-output-file "C:/Users/user/Desktop/knowledge-abse-markov.txt" [λ [out-port] [write [send markov serialise] out-port]] #:exists 'replace]
                                         [send markov serialise-to-file "C:/Users/user/Desktop/knowledge-base-1.bak"]
                                
                                [exec/ignore sqlite update-page-processing-complete-sql [format "~a" a-url]]
                                [display [format "Marked ~a as complete~n" a-url]]
                                ]]]]]]
  ;[process-url "http://www.reddit.com/r/gaming/comments/k6ohd/nice_valve_thanks_for_the_suggestion/.json"]
  ;[exit][json->jsexpr  [bytes->string/utf-8 [simple-get "http://www.reddit.com/comments/70ehq/obama_to_palindont_mock_the_constitution_dont/.json"]]]
  
  ;[pretty-write [shtml-cache-get "http://www.reddit.com/"]]
  ;[map ingest-from-cache-href  [get-comments-links "http://www.reddit.com/"] ]
  
  [define process-data [lambda [] [begin 
                                    ;[define togo [length [select sqlite "select url,rowid from page_cache where processed='false';" ]]]
                                    [define current 1]
                                    [map [lambda [x] 
                                           [display [format "~a" current]] [set! current [add1 current]]
                                           ;[ingest-from-cache-href [car [vector->list  x]] [cadr [vector->list  x]]]] 
                                           [process-url [car [vector->list  x]]]]
                                         [cdr   [select sqlite "select url, rowid from page_cache where processed='false' limit 100;" ]]]
                                    ;[map ingest-from-cache-href  [get-comments-links [get-next-page-href "http://www.reddit.com/"]] ]
                                    ;[set! tags-to-hrefs [hash-remove tags-to-hrefs ""]]
                                    ;[set! mastercount [hash-remove mastercount ""]]
                                    ;    [map [lambda[x]
                                    ;           [set! tags-to-hrefs [hash-remove tags-to-hrefs x]]
                                    ;           [set! mastercount [hash-remove mastercount x]]
                                    ;           ]
                                    ;         all-stop-words]
                                    ;    [map 
                                    ;     [lambda [x] [display [format "tag:~a~n~a~n~n"  [car x] [hash-ref tags-to-hrefs [car x] ""]]]] 
                                    ;     [take [drop [sort 
                                    ;                  [hash->list mastercount] 
                                    ;                  [lambda [a b] [> [cdr a] [cdr b]]]] 1000] 1000]]
                                    
                                    #f]]]
  ;[simple-get "http://www.reddit.com/r/gaming/comments/k6ohd/nice_valve_thanks_for_the_suggestion/abc1010.json"]
  ;[suck]
  [process-data]
  ;[hash->list tags-to-hrefs] 
  ;[pretty-write ((sxpath "//p[@class='title']/..") [shtml-get "http://www.reddit.com/"])]
  
  ;[display ((sxpath "//a") [shtml-get "http://www.reddit.com/"])]
  ;(history-rip "ASfas" 1 0)
  ;curry rip page for map
  (define file-rip
    (lambda (filename maxdepth depth)
      (let ((next-page (lambda (page) (rip-page page maxdepth (+ 1 depth)))))
        
        ;Then finally rip any linked pages
        (map next-page
             (file-urls-get filename)))))
  ;    (thread (file-rip "C:\\Documents and Settings\\aarrr\\Application Data\\Mozilla\\Firefox\\Profiles\\zr81kls3.default\\bookmarks.html" 1 0))
  
  ;(display (simple-trace "http://reddit.com/"))
  ;(display (simple-trace "http://alphacomplex.org/"))
  ;(display 
  
  ; (threaded-map download-links
  ;               
  ;               (append-map 
  ;                (lambda (x)
  ;                  ;(display (format "Completing ~a~n" x))
  ;                  (map (make-url-completer x)
  ;                  (urls-get x)))
  ;               (map (make-url-completer "http://reddit.com")
  ;                    
  ;                            (urls-get "http://reddit.com")))))
  ;(exit)
  ;
  #f
  )