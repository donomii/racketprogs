package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"runtime/debug"
	"strings"

	. "github.com/donomii/pmoo"
	"github.com/donomii/racketprogs/pmoo/myQ"
	"github.com/donomii/throfflib"
	"github.com/traefik/yaegi/interp"
)

func ConsoleInputHandler(queue chan *Message) {
	reader := bufio.NewReader(os.Stdin)

	for {
		//fmt.Print("Enter text: ")
		text, _ := reader.ReadString('\n')
		text = text[:len(text)-1]
		if text != "" {
			//Console is always the wizard, at least for now
			InputMsg("2", "7", "input", text)
		}
	}
}

var goScript *interp.Interpreter
var Affinity string

func main() {
	etcdServer := ""
	var init bool
	flag.BoolVar(&init, "init", false, "Create basic objects.  Overwrites existing")
	flag.BoolVar(&Cluster, "cluster", false, "Run in cluster mode.  See instructions.")
	flag.BoolVar(&ClusterQueue, "clusterQ", false, "Run messages in cluster mode.  See instructions.")
	flag.StringVar(&etcdServer, "etcd", "localhost:2379", "Location of object database.")
	//flag.StringVar(&queueServer, "queue", "127.0.0.1:2888", "Location of queue server.")
	flag.StringVar(&QueueServer, "queue", "http://127.0.0.1:8080", "Location of queue server.")
	flag.StringVar(&Affinity, "affinity", "7", "Will process all messages with this affinity id.")

	flag.Parse()

	SetEtcdServers([]string{etcdServer})
	//QueueServer = queueServer
	if Cluster {
		//okdb.Connect("192.168.178.22:7778")

	}
	if ClusterQueue {
		//go StartClient(QueueServer)
		SetQueueServer(QueueServer)
		go myQ.Receiver(QueueServer, func(b []byte) {
			var m Message
			json.Unmarshal(b, &m)
			Q <- &m
		})
	}

	if init {
		initDB()
	}
	inQ := make(chan *Message, 100)
	SetQ(inQ)

	go ConsoleInputHandler(inQ)

	goScript = NewInterpreter()
	goScript.Eval(`		
	import . "github.com/donomii/pmoo"
	import "os"
	import . "fmt"`)

	player := "2"
	for {
		log.Println("Waiting on Q")
		m := <-inQ
		log.Println("Q:", m)
		if m.Affinity != "" && m.Affinity != Affinity {
			if ClusterQueue {
				MyQMessage(QueueServer, m)
			} else {
				RawMsg(*m)
			}
		}
		if m.This != "7" {
			log.Println("Handling direct message")
			/*
				player := m.Player
				this := m.Target
				verb := m.Verb
				dobjstr := m.Data

				//dobj, dpropstr := ParseDo(dobjstr, player)

				//var iobjstr, prepstr, iobj, ipropstr string

				//	verbStruct := GetVerbStruct(LoadObject(this), verb, 10)
			*/

			if m.This != "" && m.Player != "" && m.Verb != "" { //Skip broken messages
				log.Printf("Invoking direct message %+v", m)
				invoke(m.Player, m.This, m.Verb, m.Dobj, m.Dpropstr, m.Prepstr, m.Iobj, m.Ipropstr, m.Dobjstr, m.Iobjstr)
			}
			continue

		}

		log.Println("Handling input - Breaking sentence")

		text := m.Data
		verb, dobjstr, prepstr, iobjstr := BreakSentence(text)
		log.Println(strings.Join([]string{verb, dobjstr, prepstr, iobjstr}, ":"))
		dobj, dpropstr := ParseDo(dobjstr, player)
		iobj, ipropstr := ParseDo(iobjstr, player)

		thisObj, _ := VerbSearch(LoadObject(player), verb)

		if thisObj == nil {
			msg := fmt.Sprintf("Verb %v not found!\n", verb)
			Msg("7", player, "notify", msg, "", "")

		} else {
			this := ToStr(thisObj.Id)

			log.Println("Handling input - Queueing direct message")
			if ClusterQueue {
				//SendNetMessage(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace})
				MyQMessage(QueueServer, Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace})
				//time.Sleep(1 * time.Second) //FIXME
			} else {
				RawMsg(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace})
			}

		}

	}
}

//Actually evaluate the verb
func invoke(player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr string) {
	code := ""
	defer func() {
		if r := recover(); r != nil {
			log.Println("Failed to eval:", player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr, "code:", code, r)
			fmt.Println("stacktrace from panic in eval: \n" + string(debug.Stack()))
		}
	}()
	verbStruct := GetVerbStruct(LoadObject(this), verb, 10)
	if verbStruct == nil {
		fmt.Printf("Failed to lookup '%v' on %v\n", verb, this)
	} else {
		if verbStruct.Throff {
			t := throfflib.MakeEngine()
			AddEngineFuncs(t, player, this, "0")
			t = t.RunString(throfflib.BootStrapString(), "Internal Bootstrap")

			code = verbStruct.Value
			log.Println("Throff program: ", code)
			//code = code + "  PRINTLN A[ ^player: player ]A PRINTLN A[ ^this: this ]A PRINTLN  A[ ^verb: verb ]A PRINTLN   A[ ^dobjstr: dobjstr ]A PRINTLN A[ ^dpropstr: dpropstr ]A PRINTLN  A[ ^prepstr: prepstr ]A  PRINTLN A[ ^iobjstr: iobjstr ]A   PRINTLN A[ ^ipropstr: ipropstr ]A PRINTLN [ ]  "
			code = code + " ARG player TOK   ARG  this TOK   ARG verb TOK   ARG  dobj TOK   ARG dpropstr TOK   ARG prepstr TOK  ARG iobj TOK   ARG ipropstr TOK   ARG dobjstr TOK   ARG iobjstr TOK SAFETYON "
			t.CallArgs(code, player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr)
		} else {
			log.Println("Goscript program: ", code)
			code = BuildDefinitions(player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr)
			code = code + verbStruct.Value
			Eval(goScript, code)
		}
	}
}
