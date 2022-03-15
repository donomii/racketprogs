package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"path"
	"regexp"
	"runtime/debug"
	"strings"
	"time"

	"../xsh"

	"github.com/chzyer/readline"
	"github.com/donomii/goof"

	//. "github.com/donomii/pmoo"
	"../autoparser"
	. "../pmoolib"
	pmoo "../pmoolib"
	"github.com/donomii/throfflib"
	"github.com/traefik/yaegi/interp"
)

var DefaultPlayerId = "2"
var DefaultSystemCore = "7"

func ConsoleInputHandler(queue chan *Message, player string) {
	reader := bufio.NewReader(os.Stdin)

	for {
		//fmt.Print("Enter text: ")
		text, err := reader.ReadString('\n')
		if err != nil {

			if batch {
				log.Println("Waiting for commands to finish...")
				time.Sleep(time.Millisecond * 5000)
			}
			if err == io.EOF {
				log.Println("Input complete")
				os.Exit(0)
			} else {
				log.Println("Readline error:", err)
				os.Exit(1)
			}
		}
		text = strings.TrimSuffix(text, "\r\n")
		text = strings.TrimSuffix(text, "\n")
		if text != "" {
			//fmt.Printf("Examining input: %s\n", text[:2])
			if text[:2] == "x " {
				fmt.Println(xshRun(text[2:], player))
			} else {
				fmt.Printf("ConsoleInputHandler: %s\n", text)
				//Console is always the wizard, at least for now
				InputMsg(player, DefaultSystemCore, "input", text)
			}
		}
		time.Sleep(time.Millisecond * 2000)

	}

}

func listVerbs(player string) func(string) []string {
	return func(s string) []string {
		vs := VerbList(player)
		//fmt.Println("Found verbs:", vs)
		return vs
	}
}

func xshRun(text, player string) string {
	//fmt.Printf("Evalling xsh %v\n", text)
	xsh.WantDebug = false
	state := xsh.New()
	addPmooTypes(state)
	xsh.UsePterm = false
	state.UserData = player
	state.ExtraBuiltins = xshBuiltins
	//xsh.Eval(state, xsh.Stdlib_str, "stdlib")
	//res := xsh.Eval(state, text, "pmoo")
	//fmt.Printf("Result: %+v\n", res)
	//l := []autoparser.Node{res}
	//resstr := xsh.TreeToXsh(l)
	//fmt.Printf("Result: %+v\n", resstr)
	std := xsh.Parse(xsh.Stdlib_str, "stdlib")
	xsh.Run(state, std)
	xsh.WantDebug = pmooDebug

	tr := xsh.Parse(text, "pmoo")
	//fmt.Printf("Substituting pmoo vars\n")
	tr = subsitutePmooVars(tr)
	res := xsh.Run(state, tr)
	l := []autoparser.Node{res}
	resstr := xsh.TreeToXsh(l)

	return resstr
}

func keys(m map[string][]string) []string {
	out := []string{}
	for k, _ := range m {
		out = append(out, k)
	}
	return out
}

func listFuncs(xshEngine xsh.State) func(string) []string {
	return func(string) []string {
		return keys(xshEngine.TypeSigs)
	}
}
func ReadLineInputHandler(queue chan *Message, player string) {
	xsh.WantDebug = false
	xshEngine := xsh.New()
	addPmooTypes(xshEngine)
	xshEngine.ExtraBuiltins = xshBuiltins
	xsh.WantDebug = pmooDebug

	var completer = readline.NewPrefixCompleter(
		readline.PcItemDynamic(listVerbs(player)),
		readline.PcItem("x", readline.PcItemDynamic(listFuncs(xshEngine))))

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
			readline.PcItemDynamic(listVerbs(player)),
			readline.PcItem("x", readline.PcItemDynamic(listFuncs(xshEngine))))
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
			log.Println("Readline error:", err, "Exiting...")

			os.Exit(1)
		}
		text = strings.TrimSuffix(text, "\r\n")
		text = strings.TrimSuffix(text, "\n")
		if text == "exit" {
			fmt.Println("Exiting...")
			os.Exit(0)
		}
		if text != "" {
			if len(text) < 3 {
				fmt.Println("Too short")
				continue
			}
			//fmt.Printf("Examining input: '%s'\n", text[:2])
			if text[:2] == "x " {
				fmt.Println(xshRun(text[2:], player))
			} else {
				//Console is always the wizard, at least for now
				InputMsg(DefaultPlayerId, DefaultSystemCore, "input", text)
			}
		}
	}
	l.Close()
}

var Affinity string
var batch bool
var pmooDebug bool

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	etcdServer := ""
	var init bool
	var RawTerm bool
	var inQ chan *Message = make(chan *Message, 100)
	player := DefaultPlayerId
	cmdProg := path.Base(os.Args[0])
	pmooDebug = false

	flag.BoolVar(&pmooDebug, "debug", false, "Print log messages")
	flag.BoolVar(&init, "init", false, "Create basic objects.  Overwrites existing")
	flag.BoolVar(&batch, "batch", false, "Batch mode.  Wait for each command to finish before starting next.")
	flag.BoolVar(&Cluster, "cluster", false, "Run in cluster mode.  See instructions in README.")
	flag.BoolVar(&ClusterQueue, "clusterQ", false, "Run messages in cluster mode.  See instructions in README.")
	//flag.StringVar(&queueServer, "queue", "127.0.0.1:2888", "Location of queue server.")
	flag.StringVar(&QueueServer, "queue", "http://127.0.0.1:8080", "Location of queue server.")
	flag.StringVar(&Affinity, "affinity", DefaultSystemCore, "Will process all messages with this affinity id.")
	flag.BoolVar(&RawTerm, "raw", false, "Batch mode.  No shell enhancements, read directly from STDIN.  Works with rlwrap.")

	flag.Parse()

	if pmooDebug {
		xsh.WantDebug = true
	} else {
		log.SetOutput(ioutil.Discard)
	}

	SetQ(inQ)

	if cmdProg == "p" {
		//fmt.Println("Single command mode")
		dataDir := goof.HomeDirectory() + "/.pmoo/objects"
		os.MkdirAll(dataDir, 0600)
		SetDataDir(dataDir)
		log.Println("Using MOO in", pmoo.DataDir)
		args := append(flag.Args(), "", "", "")
		RawMsg(Message{Player: player, This: DefaultSystemCore, Verb: "%commandline", Args: args, Ticks: DefaultTicks})
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
			fmt.Println("Initialised database, exiting\n")
			os.Exit(0)
		}

		if RawTerm {
			go ConsoleInputHandler(inQ, player)
		} else {
			go ReadLineInputHandler(inQ, player)
		}
	}

	MOOloop(inQ, player)
}
func MOOloop(inQ chan *Message, player string) {
	for {
		log.Println("Waiting on queue", len(inQ), "/", cap(inQ))

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
		if m.This != DefaultSystemCore {
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

		thisObj, _ := VerbSearch(player, verb)

		if thisObj == nil {
			msg := fmt.Sprintf("Verb '%v' not found!\n", verb)
			RawMsg(Message{From: DefaultSystemCore, Player: player, Verb: "notify", Dobjstr: msg, Ticks: m.Ticks - 100})

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

func addPmooTypes(s xsh.State) {
	s.TypeSigs["setprop"] = []string{"void", "string", "string", "string"}
	s.TypeSigs["allobjects"] = []string{"list"}
	s.TypeSigs["findobject"] = []string{"string", "string"}
	s.TypeSigs["clone"] = []string{"string", "string", "string"}
	s.TypeSigs["formatobject"] = []string{"string", "string"}
	s.TypeSigs["move"] = []string{"void", "string", "string"} //Should be bool?
	s.TypeSigs["getprop"] = []string{"string", "string", "string"}
	s.TypeSigs["setverb"] = []string{"void", "string", "string", "string", "string"}
	s.TypeSigs["msg"] = []string{"void", "string", "string", "string", "string", "string", "string"}
	s.TypeSigs["o"] = []string{"string", "string"}
}

func xshBuiltins(s xsh.State, command []autoparser.Node, parent *autoparser.Node, level int) (autoparser.Node, bool) {
	player := s.UserData.(string)
	if len(command) > 0 {
		c, err := xsh.ListToStrings(command)
		if err != nil {
			//log.Println("Error converting command to string:", err)
		} else {
			//fmt.Printf("Running custom handler for command %v\n", c)
			switch c[0] {
			case "setprop":
				SetProp(c[1], c[2], c[3])
				return command[3], true
			case "findobject":
				num := GetObjectByName(player, c[1])
				fmt.Println("Searched for object", c[1], "found", num)
				if num != "" {
					return xsh.N(num), true
				}
				return xsh.Void(command[0]), true
			case "getprop":
				return xsh.N(GetProp(c[1], c[2])), true
			case "clone":
				return xsh.N(Clone(c[1], c[2])), true
			case "formatobject":
				fmt.Printf("Formatting object from args: %v\n", c)
				return xsh.N(FormatObject(c[1])), true
			case "move":
				return xsh.Bool(MoveObj(c[1], c[2])), true
			case "setverb":
				obj := c[1]
				prop := c[2]
				interpreter := c[3]
				value := c[4]
				SetVerb(obj, prop, value, interpreter)
				return xsh.Void(command[0]), true
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
				return xsh.Void(command[0]), true
			case "o":
				num := GetObjectByName(player, c[1])
				fmt.Println("Searched for object", c[1], "found", num)
				if num != "" {
					return xsh.N(num), true
				}
				return xsh.Void(command[0]), true

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

			xsh.WantDebug = false
			state := xsh.New()
			addPmooTypes(state)
			state.ExtraBuiltins = xshBuiltins
			state.UserData = player
			code = BuildXshCode(verbStruct.Value, player, this, verb, dobj, dpropstr, prepstr, iobj, ipropstr, dobjstr, iobjstr)
			log.Println("xsh program: ", code)
			std := xsh.Parse(xsh.Stdlib_str, "stdlib")
			xsh.Run(state, std)
			xsh.WantDebug = pmooDebug
			tr := xsh.Parse(code, "pmoo")
			fmt.Printf("Substituting pmoo vars\n")
			tr = subsitutePmooVars(tr)
			log.Printf("Running xsh program: %v\n", tr)
			xsh.Run(state, tr)
		default:
			log.Println("Unknown interpreter: ", verbStruct.Interpreter)
		}
	}
}

func subsitutePmooVars(code []autoparser.Node) []autoparser.Node {
	//fmt.Printf("Substituting vars in %+v\n", code)
	out := xsh.TreeMap(func(n autoparser.Node) autoparser.Node {
		str := xsh.S(n)
		//fmt.Printf("Examining %v\n", str)
		if strings.HasPrefix(str, "%") {
			re := regexp.MustCompile("\\%([^.])+\\.?(.+)?")
			res := re.FindString(str)
			fmt.Printf("Matched object ref: %v\n", res)
			objStr := string(res[1:])
			fmt.Printf("Looking up object '%v'\n", objStr)
			id := GetObjectByName(DefaultPlayerId, objStr)
			fmt.Printf("Found object %v\n", id)
			return xsh.N(fmt.Sprintf("%v", id))
		}

		return n

	}, code)
	return out
}
