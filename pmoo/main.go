package main

import (
	"../xsh"
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path"
	"runtime/debug"
	"strings"
	"time"

	"github.com/chzyer/readline"
	"github.com/donomii/goof"

	//. "github.com/donomii/pmoo"
	"../autoparser"
	. "./pmoolib"
	pmoo "./pmoolib"
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
			//fmt.Printf("Examining input: %s\n", text[:2])
			if text[:2] == "x " {
				fmt.Println(xshRun(text[2:]))
			} else {
				fmt.Printf("ConsoleInputHandler: %s\n", text)
				//Console is always the wizard, at least for now
				InputMsg("2", "7", "input", text)
			}
		}
	}
}

func listVerbs(player string) func(string) []string {
	return func(s string) []string {
		vs := VerbList(player)
		//fmt.Println("Found verbs:", vs)
		return vs
	}
}

func xshRun(text string) string {
	//fmt.Printf("Evalling xsh %v\n", text)
	state := xsh.New()
	xsh.UsePterm = false
	state.UserData = "7"
	state.ExtraBuiltins = xshBuiltins
	xsh.Eval(state, xsh.Stdlib_str, "stdlib")
	res := xsh.Eval(state, text, "pmoo")
	//fmt.Printf("Result: %+v\n", res)
	l := []autoparser.Node{res}
	resstr := xsh.TreeToTcl(l)
	//fmt.Printf("Result: %+v\n", resstr)
	return resstr
}
func ReadLineInputHandler(queue chan *Message, player string) {

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
	for {
		completer = readline.NewPrefixCompleter(
			readline.PcItemDynamic(listVerbs(player)))
		fmt.Print("\033[31m»\033[0m ")
		text, err := l.Readline()
		if batch {
			fmt.Print(text)
		}
		if batch {
			for len(queue) > 0 {
				log.Println("Waiting on queue", len(queue), "/", cap(queue))
				time.Sleep(18 * time.Millisecond)
			}
		}

		if err != nil {
			log.Println("Readline error:", err, "Exiting once queue is empty")
			QuitOnEmptyQueue = true
		}
		text = strings.TrimSuffix(text, "\r\n")
		text = strings.TrimSuffix(text, "\n")
		if text == "exit" {
			os.Exit(0)
		}
		if text != "" {
			//fmt.Printf("Examining input: '%s'\n", text[:2])
			if text[:2] == "x " {
				fmt.Println(xshRun(text[2:]))
			} else {
				//Console is always the wizard, at least for now
				InputMsg("2", "7", "input", text)
			}
		}
	}
	l.Close()
}

var Affinity string
var QuitOnEmptyQueue bool
var batch bool

func main() {
	etcdServer := ""
	var init bool
	var RawTerm bool
	var inQ chan *Message = make(chan *Message, 100)
	player := "2"
	cmdProg := path.Base(os.Args[0])
	debug := false

	flag.BoolVar(&debug, "debug", false, "Print log messages")
	flag.BoolVar(&init, "init", false, "Create basic objects.  Overwrites existing")
	flag.BoolVar(&batch, "batch", false, "Batch mode.  Wait for each command to finish before starting next.")
	flag.BoolVar(&Cluster, "cluster", false, "Run in cluster mode.  See instructions in README.")
	flag.BoolVar(&ClusterQueue, "clusterQ", false, "Run messages in cluster mode.  See instructions in README.")
	//flag.StringVar(&queueServer, "queue", "127.0.0.1:2888", "Location of queue server.")
	flag.StringVar(&QueueServer, "queue", "http://127.0.0.1:8080", "Location of queue server.")
	flag.StringVar(&Affinity, "affinity", "7", "Will process all messages with this affinity id.")
	flag.BoolVar(&RawTerm, "raw", false, "Batch mode.  No shell enhancements, read directly from STDIN.  Works with rlwrap.")

	flag.Parse()

	if !debug {
		log.SetOutput(ioutil.Discard)
	}

	SetQ(inQ)

	if cmdProg == "p" {

		//fmt.Println("Single command mode")
		dataDir := goof.HomeDirectory() + "/.pmoo/objects"
		os.MkdirAll(dataDir, 0600)
		SetDataDir(dataDir)
		log.Println("Using MOO in", pmoo.DataDir)
		QuitOnEmptyQueue = true
		args := append(flag.Args(), "", "", "")
		RawMsg(Message{Player: player, This: "7", Verb: "%commandline", Args: args, Ticks: DefaultTicks})
	} else {

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
			log.Println("Using MOO in cluster", QueueServer)
		} else {
			if !goof.Exists(pmoo.DataDir) {
				dataDir := goof.HomeDirectory() + "/.pmoo/objects"
				os.MkdirAll(dataDir, 0600)
				SetDataDir(dataDir)
			}
			log.Println("Using MOO in", pmoo.DataDir)
		}

		if init {
			initDB()
			os.Exit(0)
		}

		if RawTerm {
			go ConsoleInputHandler(inQ)
		} else {
			go ReadLineInputHandler(inQ, player)
		}
	}

	MOOloop(inQ, player)
}
func MOOloop(inQ chan *Message, player string) {
	for {
		log.Println("Waiting on Q")
		if QuitOnEmptyQueue && len(inQ) == 0 {
			log.Println("queue empty, exiting")
			os.Exit(0)
		}
		m := <-inQ
		log.Println("Q:", m)
		if m.Ticks < 1 {
			log.Println("Audit: Dropped message because it timed out:", m)
		}
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

		text := m.Data
		var args []string
		var verb, dobjstr, prepstr, iobjstr string
		if m.Verb == "%commandline" {
			args = m.Args
			verb, dobjstr, prepstr, iobjstr = m.Args[0], m.Args[1], m.Args[2], m.Args[3]
		} else {
			log.Println("Handling input - Breaking sentence")
			args, _ = LexLine(text)
			if len(args) > 0 {
				args = args[1:]
			}
			verb, dobjstr, prepstr, iobjstr = BreakSentence(text)
		}

		log.Println(strings.Join([]string{verb, dobjstr, prepstr, iobjstr}, ":"))
		dobj, dpropstr := ParseDirectObject(dobjstr, player)
		iobj, ipropstr := ParseDirectObject(iobjstr, player)

		thisObj, _ := VerbSearch(LoadObject(player), verb)

		if thisObj == nil {
			msg := fmt.Sprintf("Verb '%v' not found!\n", verb)
			RawMsg(Message{From: "7", Player: player, Verb: "notify", Dobjstr: msg, Ticks: m.Ticks - 100})

		} else {
			this := ToStr(thisObj.Id)
			affin := thisObj.Properties["affinity"].Value
			log.Println("Props", thisObj.Properties)
			log.Println("Found affinity:", affin)

			if ClusterQueue {
				log.Println("Handling input - Queueing direct message")
				//SendNetMessage(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Affinity: this.affin})
				MyQMessage(QueueServer, Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Affinity: affin, Args: args, Ticks: m.Ticks})
				//time.Sleep(1 * time.Second) //FIXME
			} else {
				RawMsg(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Args: args, Ticks: m.Ticks - 100})
			}

		}

	}
}

func xshBuiltins(s xsh.State, command []autoparser.Node, parent *autoparser.Node, level int) (autoparser.Node, bool) {
	player := s.UserData.(string)
	if len(command) > 0 {
		c, err := xsh.ListToStrings(command)
		if err != nil {
			log.Println("Error converting command to string:", err)
		} else {
			//fmt.Printf("Running custom handler for command %v\n", c)
			switch c[0] {
			case "setprop":
				SetProp(c[1], c[2], c[3])
				return command[3], true
			case "allobjects":
				return xsh.StringsToList(AllObjects()), true
			case "findobject":
				FindObjectByName(player, c[1]) //FIXME
			case "getprop":
				return xsh.N(GetProp(c[1], c[2])), true
			case "clone":
				return xsh.N(Clone(c[1])), true
			case "formatobject":
				return xsh.N(FormatObject(c[1])), true
			case "msg":
				from := c[1]
				target := c[2]
				verb := c[3]
				dobj := c[4]
				prep := c[5]
				iobj := c[6]

				thisObj := LoadObject(target)
				affin := thisObj.Properties["affinity"].Value
				//log.Printf("From: %v, Target: %v, Verb: %v, Dobj: %v, Prep: %v, Iobj: %v\n", from.GetString(), target.GetString(), verb.GetString(), dobj.GetString(), prep.GetString(), iobj.GetString())

				if ClusterQueue {
					//SendNetMessage(Message{From: from.GetString(), Player: player, This: target.GetString(), Verb: verb.GetString(), Dobj: dobj.GetString(), Prepstr: prep.GetString(), Iobj: iobj.GetString(), Trace: traceId})
					MyQMessage(QueueServer, Message{From: from, Player: player, This: target, Verb: verb, Dobj: dobj, Prepstr: prep, Iobj: iobj, Trace: "FIXME", Affinity: affin, Ticks: DefaultTicks})
				} else {
					RawMsg(Message{From: player, Player: player, This: target, Verb: verb, Dobj: dobj, Prepstr: prep, Iobj: iobj, Trace: "FIXME", Ticks: DefaultTicks})
				}
			}
		}
	}
	return autoparser.Node{}, false

}

//Actually evaluate the verb
func invoke(player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr string, m Message) {
	code := ""
	defer func() {
		if r := recover(); r != nil {
			log.Println("Paniced:", r)
			log.Println("Failed to eval:", player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr, "code:", code, r)
			log.Println("stacktrace from panic in eval: \n" + string(debug.Stack()))
		}
	}()
	verbStruct := GetVerbStruct(LoadObject(this), verb, 10)
	if verbStruct == nil {
		fmt.Printf("Failed to lookup '%v' on %v\n", verb, this)
	} else {
		log.Printf("Starting %+v\n", verbStruct)

		switch verbStruct.Interpreter {
		case "":
			fallthrough
		case "throff":
			t := throfflib.MakeEngine()
			AddEngineFuncs(t, player, this, "0")
			t = t.RunString(throfflib.BootStrapString(), "Internal Bootstrap")
			args := throfflib.StringsToArray(m.Args)
			code = code + verbStruct.Value
			log.Println("Throff program: ", code)
			//code = code + "  PRINTLN A[ ^player: player ]A PRINTLN A[ ^this: this ]A PRINTLN  A[ ^verb: verb ]A PRINTLN   A[ ^dobjstr: dobjstr ]A PRINTLN A[ ^dpropstr: dpropstr ]A PRINTLN  A[ ^prepstr: prepstr ]A  PRINTLN A[ ^iobjstr: iobjstr ]A   PRINTLN A[ ^ipropstr: ipropstr ]A PRINTLN [ ]  "
			code = code + " ARG args TOK ARG player TOK   ARG  this TOK   ARG verb TOK   ARG  dobj TOK   ARG dpropstr TOK   ARG prepstr TOK  ARG iobj TOK   ARG ipropstr TOK   ARG dobjstr TOK   ARG iobjstr TOK SAFETYON "
			t = throfflib.PushData(t, args)
			t.CallArgs(code, player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr)
		case "yaegi":
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
		case "xsh":
			log.Println("xsh program: ", code)
			state := xsh.New()
			state.UserData = player
			code = BuildXshCode(verbStruct.Value, player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr)
			state.ExtraBuiltins = xshBuiltins
			xsh.Eval(state, xsh.Stdlib_str, "stdlib")
			xsh.Eval(state, code, "pmoo")

		default:
			log.Println("Unknown interpreter: ", verbStruct.Interpreter)
		}
	}
}
