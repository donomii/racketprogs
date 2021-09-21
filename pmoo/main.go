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

	"github.com/chzyer/readline"
	. "github.com/donomii/pmoo"
	"github.com/donomii/throfflib"
	"github.com/traefik/yaegi/interp"
)

func ConsoleInputHandler(queue chan *Message) {
	reader := bufio.NewReader(os.Stdin)

	for {
		//fmt.Print("Enter text: ")
		text, _ := reader.ReadString('\n')
		text = strings.TrimSuffix(text, "\r\n")
		text = strings.TrimSuffix(text, "\n")
		if text != "" {
			//Console is always the wizard, at least for now
			InputMsg("2", "7", "input", text)
		}
	}
}

func listVerbs(player string) func(string) []string {
	return func(s string) []string {
		vs := VerbList(player)
		fmt.Println("Found verbs:", vs)
		return vs
	}
}

func ReadLineInputHandler(queue chan *Message, player string) {

	for {
		var completer = readline.NewPrefixCompleter(
			readline.PcItemDynamic(listVerbs(player)))

		l, err := readline.NewEx(&readline.Config{
			Prompt:          "",
			HistoryFile:     "/tmp/readline.tmp",
			AutoComplete:    completer,
			InterruptPrompt: "^C",
			EOFPrompt:       "exit",

			HistorySearchFold: true,
		})
		if err != nil {
			panic(err)
		}
		//fmt.Print ("\033[31m»\033[0m ")
		text, _ := l.Readline()
		text = strings.TrimSuffix(text, "\r\n")
		text = strings.TrimSuffix(text, "\n")
		if text != "" {
			//Console is always the wizard, at least for now
			InputMsg("2", "7", "input", text)
		}
		l.Close()
	}

}

var Affinity string

func main() {
	etcdServer := ""
	var init bool
	flag.BoolVar(&init, "init", false, "Create basic objects.  Overwrites existing")
	flag.BoolVar(&Cluster, "cluster", false, "Run in cluster mode.  See instructions.")
	flag.BoolVar(&ClusterQueue, "clusterQ", false, "Run messages in cluster mode.  See instructions.")
	//flag.StringVar(&queueServer, "queue", "127.0.0.1:2888", "Location of queue server.")
	flag.StringVar(&QueueServer, "queue", "http://127.0.0.1:8080", "Location of queue server.")
	flag.StringVar(&Affinity, "affinity", "7", "Will process all messages with this affinity id.")

	flag.Parse()

	SetEtcdServers([]string{etcdServer})
	if Cluster {
		//okdb.Connect("192.168.178.22:7778")

	}
	if ClusterQueue {
		//go StartClient(QueueServer)
		SetQueueServer(QueueServer)
		go Receiver(QueueServer, func(b []byte) {
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

	//go ConsoleInputHandler(inQ)

	player := "2"

	go ReadLineInputHandler(inQ, player)
	MOOloop(inQ, player)
}
func MOOloop(inQ chan *Message, player string) {
	for {
		log.Println("Waiting on Q")
		m := <-inQ
		log.Println("Q:", m)
		if m.Affinity != "" && m.Affinity != Affinity && ClusterQueue && Affinity != "" {
			//Put this message back in the queue so the right server can get it
			//FIXME add queues for each server so we can send it directly to the right machine
			MyQMessage(QueueServer, m)
			continue
		}
		if m.This != "7" {
			log.Println("Handling direct message")

			if m.This != "" && m.Player != "" && m.Verb != "" { //Skip broken messages
				log.Printf("Invoking direct message %+v", m)
				invoke(m.Player, m.This, m.Verb, m.Dobj, m.Dpropstr, m.Prepstr, m.Iobj, m.Ipropstr, m.Dobjstr, m.Iobjstr, *m)
			}
			continue

		}

		log.Println("Handling input - Breaking sentence")

		text := m.Data
		args, _ := LexLine(text)
		if len(args) > 0 {
			args = args[1:]
		}
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
			affin := thisObj.Properties["affinity"].Value
			log.Println("Props", thisObj.Properties)
			log.Println("Found affinity:", affin)

			if ClusterQueue {
				log.Println("Handling input - Queueing direct message")
				//SendNetMessage(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Affinity: this.affin})
				MyQMessage(QueueServer, Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Affinity: affin, Args: args})
				//time.Sleep(1 * time.Second) //FIXME
			} else {
				RawMsg(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Args: args})
			}

		}

	}
}

//Actually evaluate the verb
func invoke(player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr string, m Message) {
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
			args := throfflib.StringsToArray(m.Args)
			code = verbStruct.Value
			log.Println("Throff program: ", code)
			//code = code + "  PRINTLN A[ ^player: player ]A PRINTLN A[ ^this: this ]A PRINTLN  A[ ^verb: verb ]A PRINTLN   A[ ^dobjstr: dobjstr ]A PRINTLN A[ ^dpropstr: dpropstr ]A PRINTLN  A[ ^prepstr: prepstr ]A  PRINTLN A[ ^iobjstr: iobjstr ]A   PRINTLN A[ ^ipropstr: ipropstr ]A PRINTLN [ ]  "
			code = code + " ARG args TOK ARG player TOK   ARG  this TOK   ARG verb TOK   ARG  dobj TOK   ARG dpropstr TOK   ARG prepstr TOK  ARG iobj TOK   ARG ipropstr TOK   ARG dobjstr TOK   ARG iobjstr TOK SAFETYON "
			t = throfflib.PushData(t, args)
			t.CallArgs(code, player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr)
		} else {
			log.Println("Goscript program: ", code)
			var goScript *interp.Interpreter
			goScript = NewInterpreter()
			goScript.Eval(`
			import . "github.com/donomii/pmoo"
			import "os"
			import . "fmt"`)
			code = BuildDefinitions(player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr)
			code = code + verbStruct.Value
			Eval(goScript, code)
		}
	}
}
