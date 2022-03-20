#lang scribble/doc
@(require scribble/manual)
@title{Actinic}
@section{SYNOPSIS}
    This library makes HTTP calls to servers. It gives you the choice of
    quick and dirty calls using simple defaults, or more complicated calls
    that let you control every part of the request. It does not support 
	HTTP pipelining, but it does cache connections (sometimes known as keep-alives) 
	to speed up later requests to the same server.  This cache is thread safe, so 
	multiple threads benefit from the speedup.


    Download the microsoft webpage:

    @schemeblock[(simple-get "http://www.microsoft.com")]
	Returns the webpage as a byte-string or #f if anything went wrong

    Download the microsoft webpage, setting the referrer and user-agent
    fields:

     @schemeblock[(http-get "http://microsoft.com" '(("referrer" "http://linux.org") ("user-agent" "my-browser(v1.1)" ) ) )]

    The return value is a list containing 
	@schemeblock['( code english-code http-version '(response headers) #"body of response")]

     @schemeblock[( 200 "OK" "HTTP/1.1" '(( "content-type" "blah" )  ( "language" "blahblahblah" ) ) #"welcome to my webpage!....")]

@section{DESCRIPTION}

@subsection{Simple Calls}
    The simple-query calls are designed for situations like command line
    work, or programs where it really doesn't matter how or why a call
    fails, just that the call goes off and doesn't take much mental effort
    to prepare. All the simple calls here return #f on failure, but the
    success result depends on which call you are using. Exceptions are
    passed straight through so be ready to deal with exn:network:fails.

    All the simple calls use the same default header options, and they all
    send a connection: close to turn off pipelining and keep alives. They do
    not follow redirects.

@subsubsection{simple-get}
	sends a simplistic GET request with actinic defaults
        simple-get requests the contents of the web-page or web-application.
        It returns the page as fetched, or #f if anything goes wrong.

         example
		 @schemeblock[(simple-get "http://www.myserver.com/a/file.html")]
		 
		-> #"Welcome to my webage...blahblahblah..."

        Returns the webpage or #f if anything goes wrong

        If you need better control over the request, or you want to see the
        response headers, try the corresponding http-get call, listed below.


    @subsubsection{simple-head}
	 sends a simplistic HEAD
    request with actinic defaults.
        A head request works exactly like a get request, but without the
        data sent in the body. It lets you see what would happen if you did
        a GET request but without shifting (potentially) a lot of data from
        the server.

        Returns #t if the server responds with a 200, #f otherwise

        If you need better control over the request, or you want to see the
        response, try the corresponding http-head call, listed below.

		example
		@schemeblock[(simple-head "http://www.myserver.com/")]

    @subsubsection{simple-delete}
	sends a
    simplistic DELETE request with actinic defaults.
        I've never seen a server actually implement the DELETE method, but
        in the event it ever happens, you can use this call.

        Returns #t if the server responds with a 200, #f otherwise

        If you need better control over the request, or you want to see the
        response, try the corresponding http-delete call, listed below.

		example
		@schemeblock[(simple-delete "http://www.myserver.com/a/file.txt")]

    @subsubsection{simple-trace}
	sends a simplistic TRACE
    request with actinic defaults.
        The TRACE method causes the server to echo back your request exactly
        as it was received. It's quite handy for seeing if a proxy has
        mangled your call or if something weird is going on with the request
        builder.

        Returns #t - unlike the other simple calls, simple-trace returns the
        raw byte response as a single byte string.

        If you need better control over the request, try the corresponding
        http-trace call, listed below.

		example
		@schemeblock[(simple-trace "http://www.myserver.com/")]

    
    @subsubsection{simple-post}
	sends a simplistic POST request with
    actinic defaults
        simple-post sends some data to a server. The POST data format is
        horribly complicated, prone to misinterpretation and the base of
        data transport over web. hooray.

         example
		 @schemeblock[(simple-post "http://www.myserver.com/a/form.cgi" '(("name" "myname")("comment" "Hello Timothy, I find you delightfully amusing")))]
		 -> #t

		(simple-post url parameters)

        parameters: an assoc list containing the data you want to send. The
        data is uri-encoded, hammered into a request string and sent in the
        body of the request

        Returns #t if the server responds with 200 for success, #f otherwise

        If you need better control over the request, or you want to see the
        response, try the corresponding http-post call, listed below.

    @subsubsection{simple-url}
	sends a simplistic PUT request with actinic
    defaults.
        simple-put sends some data to a server. PUT is supposed to be the
        complement of the GET request, but very few servers support it so
        every uses POST to send data to a CGI script that handles the
        storage instead. In theory, the server should store the data from
        the body of the PUT request at the location in the URL.

         @schemeblock[ (simple-put "http://www.myserver.com/a/file.txt" #"The contents of the file")]
		 -> #t

		(simple-put url contents)

        contents: a byte string containing the contents that you would like
        to see placed at that url

        Returns #t if the server responds with 200 for success, #f otherwise

        If you need better control over the request, or you want to see the
        response, try the corresponding http-put call, listed below.

    @subsubsection{simple-options}
	 sends a simplistic
    OPTIONS request with actinic defaults.
        The OPTIONS method gets the list of options that the HTTP server
        supports. Following Apache's lead, we only ever do an OPTIONS *
        HTTP/1.1 request, no matter what url you give, even though in theory
        the server should return an OPTIONS for any resource we query.
        Behaviour subject to change if someone has a better idea on how it
        should work.

        Returns a list of the options the server supports.

        If you need better control over the request, try the corresponding
        http-options call, listed below.

		example
		@schemeblock[(simple-options "http://www.myserver.com/")]

  @subsection{http-query} 
    The http-query line of calls offers much more control over your requests
    than the simple- line. You can override header options by passing an
    assoc list as the second argument. The car (string) is the option part
    of the header line, and the cdr part (string) is the option value. All
    the functions return the same type of list:

     @schemeblock[ ( status long-status version ( (header-opt . header-value) ... ) body )]

     @schemeblock[ ( 200 OK "HTTP/1.1" '(("Date"   "Mon, 12 Jun 2006 03:11:11 GMT") ("Server"   "Apache/2.0.54 (Debian GNU/Linux) DAV/2 SVN/1.1.4 PHP/5.0.4 mod_ssl/2.0.54 OpenSSL/0.9.7e") ("X-Powered-By"   "PHP/5.0.4") ("Connection"   "close") ("Content-Type"   "text/html")) #"welcome to my webpage.....")]

	The http-query calls use a shared internal connection cache.  Instead of opening
	a new socket for every request, actinic will reuse an old socket rather than opening
	a new one.  This is safe for multiple threads, so you can fire off a thread per request
	and actinic will share the same socket between all the threads.  This is handy for writing a web
	crawler since servers will often get sulk at you if you pound them with thousands
	of socket-opens per second.  Plus there's a nice speed up since socket opens are sloooow.

  Note that this is not pipelining; each request must fully complete before the next one starts.

    @subsubsection{http-get}
	 sends a GET request.
        http-get requests the contents of the page or web-application. If
        you want to provide key - value arguments to be built into the url,
        pass an assoc-list in the params arguement, just like http-post. The
        handling of these arguments isn't very sophisticated yet.

         example (http-head url headers params)
		 @schemeblock[(http-get "http://www.myserver.com/" '() #f)]
		 -> #"Welcome to my webage...blahblahblah..."

    @subsubsection{http-post}
	sends a POST request.
        http-post sends data to a server. The data is provided in the
        parameters list, which is a key - value assoc list. All paramaters
        must be strings. Multi-part posts are NOT supported, and the mime
        type of the post is "application/x-www-form-urlencoded".

        If you want to arrange your own payload, call with parameters set to
        #f, and specify your own byte string in the payload. The mime type
        will be set to "application/octet-stream".

         example
		 @schemeblock[(http-post "http://www.myserver.com/a/form.cgi" '(("name" "myname")("comment" "Hello Timothy, I find you delightfully amusing")))]
		 -> #t

		

(http-post url parameters headers payload)

        The parameters are an assoc list containing the data you want to
        send. The data is uri-encoded, hammered into a request string and
        sent in the body of the request

        Returns #t if the server responds with 200 for success, #f otherwise

    @subsubsection{http-trace}
	sends a TRACE request.
        The TRACE method causes the server to echo back your request exactly
        as it was received. It's quite handy for seeing if a proxy has
        mangled your call or if something weird is going on with the request
        builder.

		(http-trace url headers)

         example
		 @schemeblock[(http-trace "http://www.myserver.com/" '())]


    @subsubsection{http-delete}
	sends a DELETE request
        I've never seen a server actually implement the DELETE method, but
        in the event it ever happens, you can use this call. http-delete
        asks a server to delete the resource at the given url.

		(http-delete url headers)

         @schemeblock[(http-delete "http://www.myserver.com/a/file.txt")]

    @subsubsection{http-head}
	sends a HEAD request
        A head request works exactly like a get request, but without the
        data sent in the body. It lets you see what would happen if you did
        a GET request but without shifting (potentially) a lot of data.
		
		(http-head url headers)

         @schemeblock[(http-head "http://www.myserver.com/")]

    >(winnow-alist assoc-list)
        Removes duplicate keys from an association list. The first key in
        the list is kept, any duplicate keys after that are thrown out.

  @subsection{JRLs - urls, actinic style}
    Actually, they're just called jrls because net.ss claimed "urls" first,
    and there's a good chance you'll use both these modules at some point in
    time. All jrl functions always take a text url e.g.
    "http://fred:fredspass@"@"a.server.com:9843/some/file.html"

    These functions pick out useful bits of the url for you to use.

    >(jrl-scheme url) - Gets the url scheme e.g. http ftp telnet file
         e.g. (jrl-scheme "http://user:pass@"@"a.server.com:9843/some/file.html" ) -> "http"

    >(jrl-username url) - Gets the url username :
    http://THIS:pass@"@"server.com/
         e.g. (jrl-username "http://fred:fredspass@"@"a.server.com:9843/some/file.html" ) -> "fred"

    >(jrl-password url) - Gets the url password :
    http://fred:THIS@"@"a.server.com:9843/some/file.html
         e.g. (jrl-password "http://fred:fredspass@"@"a.server.com:9843/some/file.html" ) -> "fredspass"

    >(jrl-server url) - Gets the url server or 'host' :
    http://fred:fredspass@"@"THIS.PART.HERE:9843/some/file.html
         e.g. (jrl-server "http://fred:fredspass@"@"a.server.com:9843/some/file.html" ) -> "a.server.com"

    >(jrl-server/proxy url)
        Gets the url server. However if you have told actinic to use a
        proxy, you'll get the proxy instead. If actinic isn't using a proxy,
        it will behave identically to jrl-server

         e.g. (jrl-server/proxy "http://fred:fredspass@"@"a.server.com:9843/some/file.html" ) -> "a.proxy.server.com"

    >(jrl-port/proxy url)
        Gets the url port. However if you have told actinic to use a proxy,
        you'll get the proxy's port instead If you actinic isn't using a
        proxy, it will behave identically to jrl-port

         e.g. (jrl-port/proxy "http://fred:fredspass@"@"a.server.com:9843/some/file.html" ) -> "8080"

    >(jrl-port url) - Gets the url port :
    http://fred:fredspass@"@"a.server.com:THIS/some/file.html
        If the url does not include a port, jrl-port will try to look at the
        scheme and guess the correct port. If it can't do that, it throws an
        error.

         e.g. (jrl-port "http://fred:fredspass@"@"a.server.com:9843/some/file.html" ) -> "9843"

    >(jrl-path url) - Gets the url path :
    http://fred:fredspass@"@"a.server.com:9843THIS/PART/HERE
         e.g. (jrl-path "http://fred:fredspass@"@"a.server.com:9843/some/file.html" ) -> "/some/file.html"

    >(jrl-path/proxy url) - Gets the url path :
    http://fred:fredspass@"@"a.server.com:9843THIS/PART/HERE
        If actinic is using a proxy, it will return an appropriate string
        for the path request part of the header.

         e.g. (jrl-path/proxy "http://fred:fredspass@"@"a.server.com:9843/some/file.html" ) -> "http://fred:fredspass@"@"a.server.com:9843/some/file.html"

        Note to self: this function is correct. Stop trying to 'fix' it

    >(create-request-line method url version)
        Creates the correct first two lines for a http request

        method: a string, one of "HEAD" "GET" "PUT" "POST" "OPTIONS" or any
        other http method you feel like faking up

        url: a string like "http://www.a.site.com"

        version: a string indicating which version of the http protocol you
        want to use. We recommend "1.1", but you can use "1.0" or even "0.9"

    >(process-header lines)
        Takes a list of byte strings and breaks them up into an assoc list

        lines: expects a list of lines from the http response (bytes)

        Each line should have the trailing CRLF already removed, and should
        be in byte format.

        Returns an assoc list that holds the header parameters:

         e.g. ((Date .  Mon, 12 Jun 2006 03:11:11 GMT) (Server .  Apache/2.0.54 (Debian GNU/Linux) DAV/2 SVN/1.1.4 PHP/5.0.4 mod_ssl/2.0.54 OpenSSL/0.9.7e) (X-Powered-By .  PHP/5.0.4) (Connection .  close) (Content-Type .  text/html))

    >(slurp-port port) - read all bytes from a port
        reads bytes from a port until it gets an eof, then returns all the
        bytes read in one byte string

        port: an input port

        Returns a byte string of all the bytes read from the port

    >(break-result result) - takes a HTTP response and turns it into an
    easy-to-access data structure
        result: a byte string containing a raw http response

        returns a rather complicated structure containing the response
        status, the header lines and the body of the response in the form:
        list of ( status-code english-code '(assoc list of header settings)
        body)

         the returned list looks like ( 200 OK HTTP/1.1 '((Date .  Mon, 12 Jun 2006 03:11:11 GMT) (Server .  Apache/2.0.54 (Debian GNU/Linux) DAV/2 SVN/1.1.4 PHP/5.0.4 mod_ssl/2.0.54 OpenSSL/0.9.7e) (X-Powered-By .  PHP/5.0.4) (Connection .  close) (Content-Type .  text/html)) #"welcome to my webpage.....")



@subsection{COPYRIGHT}
    You may use this module under the same terms as PLT Scheme itself.

@subsection{AUTHOR}
    Jepri, jepri@"@"alphacomplex.org

