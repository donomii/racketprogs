(module actinic-test mzscheme
(require "actinic.ss"
  	   (planet "test.ss" ("schematics" "schemeunit.plt" 2)))
(require (planet "text-ui.ss" ("schematics" "schemeunit.plt" 2)))

(define file-tests
    (test-suite
     "Tests for actinic.ss"
     
     
     (test-equal? "Full url" 
                  (break-jrl "http://username:password@somehost.com:090832/path/to/soewhere/a.cgi?key=val")
                  '( "http" "username" "password" "somehost.com" "090832" "/path/to/soewhere/a.cgi?key=val"))
       (test-equal? "Url, no password" 
                    (break-jrl "http://username@somehost.com:090832/path/to/soewhere/a.cgi?key=val")
                    '( "http" "username" #f "somehost.com" "090832" "/path/to/soewhere/a.cgi?key=val"))
       (test-equal? "Url, no login details" 
                    (break-jrl "http://somehost.com:090832/path/to/soewhere/a.cgi?key=val")
                    '( "http" #f #f "somehost.com" "090832" "/path/to/soewhere/a.cgi?key=val"))
       (test-equal? "Url, just the server" 
                    (break-jrl "http://somehost.com")
                    '( "http" #f #f "somehost.com" #f "/"))
       
       (test-equal? "Url, just the server and port" 
              (break-jrl "http://somehost.com:98343")
              '( "http" #f #f "somehost.com" "98343" "/"))
       
       (test-equal? "Full url, dotted quad" 
                    (break-jrl "http://username:password@192.168.0.3:090832/path/to/soewhere/a.cgi?key=val")
                    '( "http" "username" "password" "192.168.0.3" "090832" "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Full url, dotted quad, no password" 
                    (break-jrl "http://username@192.168.0.3:090832/path/to/soewhere/a.cgi?key=val")
                    '( "http" "username" #f "192.168.0.3" "090832" "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Full url, dotted quad, no login details" 
                    (break-jrl "http://192.168.0.3:090832/path/to/soewhere/a.cgi?key=val")
                    '( "http" #f #f "192.168.0.3" "090832" "/path/to/soewhere/a.cgi?key=val"))
                      
                      
       (test-equal? "Full url, dotted quad, just the server" 
                      (break-jrl "http://192.168.0.3")
                    '( "http" #f #f "192.168.0.3" #f "/"))
       
       (test-equal? "Full url, dotted quad, just the server and port" 
                      (break-jrl "http://192.168.0.3:98343")
                    '( "http" #f #f "192.168.0.3" "98343" "/"))
                    
       (test-equal? "Full url, dotted quad, just the server and path" 
                      (break-jrl "http://192.168.0.3/path/to/soewhere/a.cgi?key=val")
                    '( "http" #f #f "192.168.0.3" #f "/path/to/soewhere/a.cgi?key=val"))
                      
       (test-equal? "Full url, FQDN" 
       (break-jrl "http://username:password@www.somehost.com.:090832/path/to/soewhere/a.cgi?key=val")
       '( "http" "username" "password" "www.somehost.com." "090832" "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Full url, FQDN, no password" 
       (break-jrl "http://username@www.somehost.com.:090832/path/to/soewhere/a.cgi?key=val")
       '( "http" "username" #f "www.somehost.com." "090832" "/path/to/soewhere/a.cgi?key=val"))
       (test-equal? "Full url, FQDN, no login" 
       (break-jrl "http://www.somehost.com.:090832/path/to/soewhere/a.cgi?key=val")
       '( "http" #f #f "www.somehost.com." "090832" "/path/to/soewhere/a.cgi?key=val"))
       (test-equal? "Full url, FQDN, server and path" 
       (break-jrl "http://www.somehost.com./path/to/soewhere/a.cgi?key=val")
       '( "http" #f #f "www.somehost.com." #f "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Full url, FQDN, no port" 
       (break-jrl "http://username:password@www.somehost.com./path/to/soewhere/a.cgi?key=val")
       '( "http" "username" "password" "www.somehost.com." #f "/path/to/soewhere/a.cgi?key=val"))
       (test-equal? "Full url, FQDN, no pass or port" 
       (break-jrl "http://username@www.somehost.com./path/to/soewhere/a.cgi?key=val")
       '( "http" "username" #f "www.somehost.com." #f "/path/to/soewhere/a.cgi?key=val"))
       (test-equal? "Full url, FQDN, server path and port" 
       (break-jrl "http://www.somehost.com.:090832/path/to/soewhere/a.cgi?key=val")
       '( "http" #f #f "www.somehost.com." "090832" "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Mangled url - empty username" 
       (break-jrl "http://:password@somehost.com:090832/path/to/soewhere/a.cgi?key=val")
       '( "http" "" "password" "somehost.com" "090832" "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Mangled url - no servername" 
       (break-jrl "http://username@:090832/path/to/soewhere/a.cgi?key=val")
       '( "http" "username" #f #f "090832" "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Mangled url - port and path"       
       (break-jrl "http://:090832/path/to/soewhere/a.cgi?key=val")
       '( "http" #f #f #f "090832" "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Mangled url - file url with triple slash"       
       (break-jrl "file:///path/to/soewhere/a.cgi?key=val")
       '( "file" #f #f #f #f "/path/to/soewhere/a.cgi?key=val"))
       
       (test-equal? "Mangled url"
       (jrl-scheme "file:///path/to/soewhere/a.cgi?key=val")
       "file")
       (test-equal? "Simple head plt-scheme.org"
              (simple-head "http://www.plt-scheme.org/")
              #t)
       
       ;plt-scheme.org does not support OPTIONS!
       (test-equal? "Simple options apache.org"
       (simple-options "http://www.apache.org/")
       '(#"GET" #"HEAD" #"POST" #"OPTIONS" #"TRACE"))
       
       (test-equal? "Simple get plt-scheme.org"
       (simple-get "http://www.plt-scheme.org/")
       #"<html><head><title>PLT Scheme</title><meta name=\"generator\" content=\"PLT Scheme\" /><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><link rel=\"icon\" href=\"http://www.plt-scheme.org/plticon.ico\" type=\"image/ico\" /><link rel=\"shortcut icon\" href=\"http://www.plt-scheme.org/plticon.ico\" /><style type=\"text/css\">\n.sansa { font-family: Arial, Helvetica, sans-serif; }\n.sansa a:link    { color: #3a652b; text-decoration: none; background-color: transparent; }\n.sansa a:visited { color: #3a652b; text-decoration: none; background-color: transparent; }\n.sansa a:active  { color: #3a652b; text-decoration: none; background-color: #97d881; }\n.sansa a:hover   { color: #3a652b; text-decoration: none; background-color: #97d881; }\n</style></head><body bgcolor=\"white\"><table height=\"100%\" width=\"100%\" align=\"center\" border=\"0\" cellspacing=\"0\" cellpadding=\"30\"><tr valign=\"top\"><td height=\"100%\" width=\"50%\" align=\"center\" valign=\"top\" bgcolor=\"#74ca56\"><table align=\"center\" class=\"sansa\" border=\"0\" cellpadding=\"0\" cellspacing=\"4\"><tr><td align=\"center\"><img src=\"http://www.plt-scheme.org/plt-green.jpg\" width=\"266\" height=\"256\" alt=\"[icon]\" /></td></tr><tr><td><table><tr><td align=\"center\"><big><big><b>PLT Scheme</b></big></big></td></tr><tr><td align=\"center\">&nbsp;</td></tr><tr><td align=\"center\"><a href=\"http://download.plt-scheme.org/\">Download</a></td></tr><tr><td align=\"center\"><a href=\"http://www.plt-scheme.org/docs.html\">Documentation</a></td></tr><tr><td align=\"center\"><a href=\"http://www.plt-scheme.org/support.html\">Support</a></td></tr><tr><td align=\"center\"><a href=\"http://www.plt-scheme.org/learning.html\">Learning</a></td></tr><tr><td align=\"center\"><a href=\"http://www.plt-scheme.org/publications.html\">Publications</a></td></tr><tr><td align=\"center\">&nbsp;</td></tr><tr><td align=\"center\"><small><small><a href=\"http://www.plt-scheme.org/map.html\">Site Map</a></small></small></td></tr><tr><td align=\"center\"><hr noshade=\"1\" size=\"2\" color=\"#3a652b\" /></td></tr><tr><td align=\"center\"><nobr><small class=\"sansa\">PLT&nbsp;|&nbsp;<a href=\"http://www.plt-scheme.org/software/drscheme/\">DrScheme</a>&nbsp;|&nbsp;<a href=\"http://www.teach-scheme.org/\">TeachScheme!</a>&nbsp;|&nbsp;<a href=\"http://www.htdp.org/\">HtDP</a>&nbsp;|&nbsp;<a href=\"http://planet.plt-scheme.org/\">PLaneT</a>&nbsp;</small></nobr></td></tr></table></td></tr></table></td><td height=\"100%\" width=\"50%\" align=\"left\" valign=\"top\"><table width=\"80%\" align=\"center\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td><small><small>&nbsp;</small></small></td></tr><tr><td><p><strong>PLT Scheme</strong> is an umbrella name for a family of\n<a href=\"http://www.plt-scheme.org/software/\">implementations</a> of the\n<a href=\"http://www.schemers.org/\">Scheme</a> programming language.</p><br /><p><strong>PLT</strong> is the <a href=\"http://www.plt-scheme.org/who/\">group of people</a> who produce\nPLT Scheme.   We welcome applications from students interested in\n<a href=\"http://www.plt-scheme.org/who/common-plt-app.html\">graduate study</a>.</p><p><a href=\"http://www.plt-scheme.org/software/drscheme/\">DrScheme</a> is the primary PLT Scheme implementation.</p><p><a href=\"http://www.teach-scheme.org/\">TeachScheme!</a> is a PLT project to turn Computing and\nProgramming into an indispensable part of the liberal arts curriculum.</p><p><a href=\"http://www.htdp.org/\"><i>How to Design Programs</i></a> (<i>HtDP</i>) is a textbook for introductory programming\nthat was written by several PLT members.</p><p><a href=\"http://planet.plt-scheme.org\">PLaneT</a> is PLT's centralized package distribution system.\nVisit for a list of user-contributed packages.</p><p><a href=\"http://www.htus.org/\"><i>How to Use Scheme</i></a> (<i>HtUS</i>) is a book about using PLT Scheme for\neveryday programming tasts.  (Still a work in progress.)</p><p><a href=\"http://www.plt-scheme.org/software/mzscheme/\">MzScheme</a> is the lightweight, embeddable, scripting-friendly\nPLT Scheme implementation.</p></td></tr></table></td></tr></table></body></html>\n")

;     ...
     ))

(test/text-ui file-tests)
  )