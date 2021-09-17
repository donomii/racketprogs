// Copyright 2018 The Mangos Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use file except in compliance with the License.
// You may obtain a copy of the license at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// pubsub implements a publish/subscribe example.  server is a listening
// pub socket, and clients are dialing sub sockets.
//
// To use:
//
//   $ go build .
//   $ url=tcp://127.0.0.1:40899
//   $ ./pubsub server $url server & server=$! && sleep 1
//   $ ./pubsub client $url client0 & client0=$!
//   $ ./pubsub client $url client1 & client1=$!
//   $ ./pubsub client $url client2 & client2=$!
//   $ sleep 5
//   $ kill $server $client0 $client1 $client2
//
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/donomii/pmoo"
	"nanomsg.org/go-mangos"
	"nanomsg.org/go-mangos/protocol/pub"
	"nanomsg.org/go-mangos/protocol/sub"
	"nanomsg.org/go-mangos/transport/ipc"
	"nanomsg.org/go-mangos/transport/tcp"
)

var QueueServer string = "tcp://127.0.0.1:40899"

func die(format string, v ...interface{}) {
	fmt.Fprintln(os.Stderr, fmt.Sprintf(format, v...))
	os.Exit(1)
}

func date() string {
	return time.Now().Format(time.ANSIC)
}

var NetQsock mangos.Socket

func server(url string) {
	var sock mangos.Socket
	var err error
	if sock, err = pub.NewSocket(); err != nil {
		die("can't get new pub socket: %s", err)
	}
	NetQsock = sock
	log.Println("PubSub server started")
	sock.AddTransport(ipc.NewTransport())
	sock.AddTransport(tcp.NewTransport())
	if err = sock.Listen(url); err != nil {
		die("can't listen on pub socket: %s", err.Error())
	}

}
func panicErr(err error) {
	if err != nil {
		panic(err)
	}
}

func SendNetQ(m pmoo.Message) {
	txt, err := json.Marshal(m)
	panicErr(err)

	// Could also use sock.RecvMsg to get header
	if err = NetQsock.Send([]byte(txt)); err != nil {
		die("Failed publishing: %s", err.Error())
	}

}

func client(url string, name string) {
	var sock mangos.Socket
	var err error
	var msg []byte

	if sock, err = sub.NewSocket(); err != nil {
		die("can't get new sub socket: %s", err.Error())
	}
	sock.AddTransport(ipc.NewTransport())
	sock.AddTransport(tcp.NewTransport())
	if err = sock.Dial(url); err != nil {
		die("can't dial on sub socket: %s", err.Error())
	}
	// Empty byte array effectively subscribes to everything
	err = sock.SetOption(mangos.OptionSubscribe, []byte(""))
	if err != nil {
		die("cannot subscribe: %s", err.Error())
	}
	for {
		if msg, err = sock.Recv(); err != nil {
			die("Cannot recv: %s", err.Error())
		}

		if len(msg) > 0 {
			fmt.Printf("CLIENT(%s): RECEIVED %s\n", name, string(msg))

			data := pmoo.Message{}
			panicErr(json.Unmarshal([]byte(msg), &data))

			pmoo.RawMsg(data)
			msg = []byte{}
		}
	}
}

func startNetworkQ() {

	url := QueueServer
	go server("tcp://0.0.0.0:40899")

	go client(url, "client")

}
