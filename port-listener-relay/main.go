package main

import (
	"fmt"
	"net"
	"os"
)

const (
	CONN_HOST = "localhost"
	CONN_PORT = "3333"
	CONN_TYPE = "tcp"
)

func main() {

	fmt.Println("Listening on 1000,1001")
	A, B := make(chan []byte, 10), make(chan []byte, 10)

	go WaitForConn("1000", handleRequest, A, B)
	WaitForConn("1001", handleRequest, B, A)
}

func WaitForConn(port string, f func(conn net.Conn, A, B chan []byte), A, B chan []byte) {
	// Listen for incoming connections.
	l, err := net.Listen("tcp", "0.0.0.0:"+port)
	if err != nil {
		fmt.Println("Error listening:", err.Error())
		os.Exit(1)
	}
	// Close the listener when the application closes.
	defer l.Close()
	// Listen for an incoming connection.
	conn, err := l.Accept()
	if err != nil {
		fmt.Println("Error accepting: ", err.Error())
		os.Exit(1)
	}
	// Handle connections in a new goroutine.
	f(conn, A, B)
}

// Handles incoming requests.
func handleRequest(conn net.Conn, A, B chan []byte) {
	go func() {
		for {
			// Make a buffer to hold incoming data.
			buf := make([]byte, 1024)
			// Read the incoming connection into the buffer.
			reqLen, err := conn.Read(buf)
			if err != nil {
				fmt.Println("Error reading:", err.Error())
			}
			A <- buf[:reqLen]
		}
	}()

	for data := range B {
		conn.Write(data)

	}
	// Send a response back to person contacting us.

	// Close the connection when you're done with it.
	conn.Close()
}
