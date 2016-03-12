# racket-port-relay
Relay TCP connections from one port to another

    git clone https://github.com/donomii/racket-port-relay.git

or just cut and paste the code, there's only one file.

## Use

Edit the last line to set the connection details.

    [relay-port listen-port target-host target-port]

So to listen on local port 81, and relay every connnection to local port 8080

    [relay-port 81 "localhost" 8080]

If you set the capture_traffic variable to #t, you can dump the contents of each connection to your hard drive.