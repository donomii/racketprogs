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
	"strconv"
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

func ConsoleInputHandler(queue chan *Message) {
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
				fmt.Println(xshRun(text[2:], DefaultPlayerId))
			} else {
				fmt.Printf("ConsoleInputHandler: %s\n", text)
				//Console is always the wizard, at least for now
				InputMsg(DefaultPlayerId, DefaultSystemCore, "input", text)
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
func ReadLineInputHandler(queue chan *Message) {
	xsh.WantDebug = false
	xshEngine := xsh.New()
	addPmooTypes(xshEngine)
	xshEngine.ExtraBuiltins = xshBuiltins
	xsh.WantDebug = pmooDebug

	var completer = readline.NewPrefixCompleter(
		readline.PcItemDynamic(listVerbs(DefaultPlayerId)),
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
			readline.PcItemDynamic(listVerbs(DefaultPlayerId)),
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

				state := xsh.New()
				addPmooTypes(state)
				state.ExtraBuiltins = xshBuiltins
				state.UserData = DefaultPlayerId
				std := xsh.Parse(xsh.Stdlib_str, "stdlib")
				xsh.Run(state, std)
				xsh.WantDebug = pmooDebug
				code := text[2:]
				code = BuildXshCode(code, DefaultPlayerId, DefaultPlayerId, "", "", "", "", "", "", "", "")
				log.Println("xsh program: ", code)

				tr := xsh.Parse(code, "pmoo")
				//fmt.Printf("Substituting pmoo vars\n")
				tr = subsitutePmooVars(tr)
				log.Printf("Running xsh program: %v\n", tr)
				xsh.Run(state, tr)
				fmt.Println(xshRun(text[2:], DefaultPlayerId))
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
var cmdProg = path.Base(os.Args[0])

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	var init bool
	var RawTerm bool
	var inQ chan *Message = make(chan *Message, 100)
	cmdProg = path.Base(os.Args[0])
	pmooDebug = false

	flag.BoolVar(&pmooDebug, "debug", false, "Print log messages")
	flag.BoolVar(&init, "init", false, "Create basic objects.  Overwrites existing")
	flag.BoolVar(&batch, "batch", false, "Batch mode.  Wait for each command to finish before starting next.")
	flag.BoolVar(&Cluster, "cluster", false, "Run in cluster mode.  See instructions in README.")
	flag.StringVar(&QueueServer, "queue", "http://127.0.0.1:8080", "Location of queue server.")
	flag.StringVar(&Affinity, "affinity", DefaultSystemCore, "Will exclusively process all messages with this affinity id.")
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
		//FIXME duplicate code
		text := strings.Join(flag.Args(), " ")
		text = strings.TrimSuffix(text, "\r\n")
		text = strings.TrimSuffix(text, "\n")
		if text != "" {
			//fmt.Printf("Examining input: %s\n", text[:2])
			if text[:2] == "x " {
				fmt.Println(xshRun(text[2:], DefaultPlayerId))
			} else {
				fmt.Printf("p input handler: %s\n", text)
				//Console is always the wizard, at least for now
				InputMsg(DefaultPlayerId, DefaultSystemCore, "input", text)
			}
		}
	} else {
		if Cluster {
			//okdb.Connect("192.168.178.22:7778")

			//go StartClient(QueueServer)
			SetQueueServer(QueueServer)
			go Receiver(QueueServer, "main", func(b []byte) {
				var m Message
				err := json.Unmarshal(b, &m)
				if err == nil {
					inQ <- &m
				}
			})
			go Receiver(QueueServer, DefaultSystemCore, func(b []byte) {
				var m Message
				err := json.Unmarshal(b, &m)
				if err == nil {
					inQ <- &m
				}
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
			go ConsoleInputHandler(inQ)
		} else {
			go ReadLineInputHandler(inQ)
		}
	}

	MOOloop(inQ)
}
func MOOloop(inQ chan *Message) {
	for {
		log.Println("Waiting on queue", len(inQ), "/", cap(inQ))
		if cmdProg == "p" && len(inQ) == 0 {
			os.Exit(0)
		}
		m := <-inQ
		log.Println("Q:", m)
		if m.Ticks < 1 {
			log.Println("Audit: Dropped message because it timed out:", m)
		}
		if m.Affinity != "" && m.Affinity != Affinity && Cluster && Affinity != "" {
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
			} else {
				log.Println("Dropped message because it was malformed:", m)
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
		dobj, dpropstr := ParseDirectObject(dobjstr, DefaultPlayerId)
		iobj, ipropstr := ParseDirectObject(iobjstr, DefaultPlayerId)

		thisObj, _ := VerbSearch(DefaultPlayerId, verb)

		if thisObj == nil {
			msg := fmt.Sprintf("Verb '%v' not found!\n", verb)
			RawMsg(Message{From: DefaultSystemCore, Player: DefaultPlayerId, Verb: "notify", Dobjstr: msg, Ticks: m.Ticks - 100})

		} else {
			this := ToStr(thisObj.Id)
			affin := thisObj.Properties["affinity"].Value
			log.Println("Props", thisObj.Properties)
			log.Println("Found affinity:", affin)

			if Cluster {
				msg := Message{Player: DefaultPlayerId, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Affinity: affin, Args: args, Ticks: m.Ticks}
				log.Println("Handling input - Queueing direct message:", msg)
				//SendNetMessage(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Affinity: this.affin})
				MyQMessage(QueueServer, msg)
				//time.Sleep(1 * time.Second) //FIXME
			} else {
				msg := Message{Player: DefaultPlayerId, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace, Args: args, Ticks: m.Ticks - 100}
				log.Println("Handling input - Invoking direct message:", msg)
				RawMsg(msg)
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
	s.TypeSigs["become"] = []string{"bool", "string", "string"}
	s.TypeSigs["sleep"] = []string{"void", "string"}
	s.TypeSigs["o"] = []string{"string", "string"}
}
func become(player, affinity string) bool {
	DefaultPlayerId = player
	pmoo.SetProp(player, "affinity", affinity)
	fmt.Printf("Became player id: %v on node: %v\n", DefaultPlayerId, affinity)
	return true
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
			case "help":
				if len(c) == 1 {
					c = []string{"help", "all"}
				}
				switch c[1] {
				case "cluster":
					return xsh.N(`
PMOO  - Personal MUD Object Oriented

*** WARNING Cluster mode has no security! ***

Running in cluster mode allows any user to potentially delete your computer!  Do not run cluster mode
unless you are sure you have complete network security.

PMOO has a cluster mode that allows multiple computers to run the same PMOO.  This mostly works, except
that there is no protection against concurrent updates to an object overwriting each other.  This may
be solved by only allowing an object to update itself, allowing it to enforce consistency for itself.

Setting up the cluster is covered elsewhere.  The important thing to know inside the MOO is 'affinity'.

Affinity is a string that identifies the node that an object is limited to.  This is used to determine which nodes
will actually run the code for an object.  For example, the player object has an affinity set to the player's 
computer.  When someone sends a 'tell player that ...' message, the tell verb will only run on the player's
computer, displaying a message on the player's screen.  If there was no affinity, the tell verb would run
on any node that picked it off the queue.  The message would appear on a random screen in the cluster.

The affinity is set by the 'become' verb for players, otherwise the normal 'setprop' command works.

setprop shell affinity "Node A"

The affinity of a node is set on the command line (or in the config file) when the node is started.  There is 
currently no way to list all the nodes in the cluster.
					`), true
				case "scripting":
					return xsh.N(`
PMOO - Personal MUD Object Oriented 

PMOO is a 'live object' system.  You create objects and verbs, and then use them.  Objects have inheritence through their 'parent'
property.  All commands are executed in parallel.  You cannot rely on commands running in the same order that you give them, as one
might be held up, allowing the next one to run first.

Pmoo is a relatively complex system to program in.  There are multiple levels to program in:

- The user level, which uses pseudo-english to give commands
- The object level, where objects receive direct messages
- The verb level, where verbs are executed in one of many scripting languages

The following example follows a "snap photo" command, which uses the computer's camera to take a photo. 

When the user types 'snap photo', the system will break the sentence up to find the verb and direct object.  The verb
is 'snap', and the direct object is 'photo'.  The parser then searches for an object that can handle the 'snap' verb, 
generates a message, and sends it to that object.  If running in cluster mode, the message might be sent to another computer
before it is executed.

Messages are exchanged as JSON data.  They are added to a queue, and later on are removed and processed by a random node (or the 
affinity node, if set).  They might be delayed - even by a couple of seconds.  There is currently no way to tell if a message
succeeded or failed.  There is also no way to get the result value of a message.  To do that, the receiving object must create a new
message and send that back to the sender.  There is also no way to tell if this message succeeds.

The object receives the message, and then runs the verb.  The code might look something like:

    raspistill -o /tmp/snap.jpg
	setprop this data [contents /tmp/snap.jpg]

the first line is a system command that uses the raspistill program to take a photo.  The second line is a PMOO command that
sets the 'data' property of the current object (the camera) to the contents of the photo.  A better version would perhaps create
a new object called 'picture', and set the 'data' property of that picture object to the contents of the photo.

There are currently 3 options for writing code in PMOO:  

yaegi, a scripted version of go that allows most access to the underlying
PMOO engine.  Yaegi is unfortunately a bit unstable and incomplete.

sh, the original system shell.  sh has almost no access to PMOO.  It is handy for controlling the system, not so much for extracting data for processing it.

Xsh, a shell-like scripting language.  It is much more regular and safe than traditional POSIX shells.  It has access to most of PMOO.

PMOO is mostly scripted in the xsh language.  You can learn about xsh at: xxxx add url here.  Xsh has been extended with 
several commands to work with PMOO.  These commands are:

sleep 1000 - Sleep for 1000 milliseconds
become UUID - Become the player with the given UUID
setprop UUID PROP VALUE - Set the property PROP to VALUE on the object with the given UUID
getprop UUID PROP - Get the property PROP from the object with the given UUID
findobject NAME - Find the object with the given name
clone UUID NAME - Clone the object with the given UUID and give it the given NAME and new UUID.
formatobject UUID - Format the object with the given UUID as a string
move UUID TO_UUID- Move the object with the given UUID into the object with the given TO_UUID
setverb UUID PROP "xsh" PROGRAM - Set the verb PROP to the given PROGRAM on the object with the given UUID.
msg FROM_UUID TO_UUID VERB OBJ PREP IOBJ - Send a message from FROM_UUID to TO_UUID.
o NAME - Get the object with the given name

All verb scripts are started with some standard variables available:
	here - The location that the caller is located
	playerid - The player id of the player who sent the message
	this - The object id of the object that the verb is being called on
	verb - The verb that is being called
	dobj - The direct object of the verb
	dpropstr - The direct property of the dobj
	prepstr - The preposition of the verb
	iobj - The indirect object of the verb
	ipropstr - The indirect property of the iobj
	dobjstr - The direct object of the verb as a string
	iobjstr - The indirect object of the verb as a string
	trace - The trace of the message
	args - The arguments of the message, parsed as a posix shell command
	ticks - The number of ticks that have passed since the message was sent


You can run scripts directly by typing 'x command', e.g.

x puts hello world

or create your own verb with

x setverb 4 help xsh "msg playerid playerid \"tell\" [help dobj] 0 0"

Note that you do not write %4 for the object UUID in xsh, just use the number directly.
					`), true
				case "moo":
					return xsh.N(`
PMOO - Personal MUD Object Oriented Programming

MOOs are an online, multiuser version of old text adventure games like Zork or Adventure.  MOOs were briefly 
popular in the 90s, but have since been replaced by more modern games that are actually fun.  You can still 
find the original MOOs online, the wikipedia page is a good place to start: https://en.wikipedia.org/wiki/LambdaMOO

PMOO is an experiment to use MOOs beyond their original purpose, and has ended up being a kind of virtual world
command shell.  It is still possible to use it as a multiplayer environment, but it lacks any of the security
features that would make that possible.  In particular, it does not prevent players from formatting the 
computer if they want to!

Players can move around the MOO using the traditional commands:
> go east
> take box
> open door
> say hello to Bob
> say "What do you want to do?" to Bob

There are some shortcut words for common objects:

> examine me
> examine here

If you want to use the UUID of an object directly, put a % in front of it:

> examine %1

Writing your own commands is encouraged.  The scripting language is XSH, you can learn more with 'help scripting'.
					`), true
				default:
					return xsh.N(`
PMOO - Personal MUD Object Oriented

PMOO is a Personal MOO.  Rather than duplicating the original MOOs, it builds on their ideas and combines it with 
modern concepts, like clusters, or running on your laptop.  It is not sandboxed off from your computer, so you can 
create MOO objects that manipulate your computer.

A quick feature list:
- MOO objects are saved to files and be can checked into git.  Your entire MOO can be branched and reverted.
- No sandbox.  You can create MOO objects that manipulate your computer, using the built in scripting language
- Cluster operation.  Multiple computers can run the MOO at the same time.
- Disconnected operation.  MOO objects now have UUIDs, so disconnected operation is possible.
- Multiple scripting languages.  Adding more is possible, if not easy.

Additional help is available for:

moo - what is a MOO?
scripting - writing commands to control the MOO
cluster - cluster mode
					`), true
				}

			case "sleep":
				duration, _ := strconv.ParseInt(c[1], 10, 64)
				time.Sleep(time.Duration(duration) * time.Millisecond)
				return xsh.Bool(true), true
			case "become":
				return xsh.Bool(become(c[1], c[2])), become(c[1], c[2])
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
			case "delprop":
				DelProp(c[1], c[2])
				return xsh.N(c[2]), true
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
				affProp, ok := thisObj.Properties["affinity"]
				affin := ""
				if ok {
					affin = affProp.Value
				}
				//log.Printf("From: %v, Target: %v, Verb: %v, Dobj: %v, Prep: %v, Iobj: %v\n", from.GetString(), target.GetString(), verb.GetString(), dobj.GetString(), prep.GetString(), iobj.GetString())

				if Cluster {
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
			if verb != "notify" {
				Msg(this, player, "notify", fmt.Sprintf("Failed to %v %v, because %v %v", verb, dobjstr, r, string(debug.Stack())), "", "")
			}
		}
	}()
	if verb != "tell" && verb != "notify" {
		objstr := dobjstr
		if objstr == "me" {
			objstr = "yourself"
		}
		Msg(this, player, "notify", fmt.Sprintf("You %v %v %v %v", verb, dobjstr, prepstr, iobjstr), "", "")
	}

	vobj := RecFindProp(LoadObject(this), verb, 10)
	if vobj == nil {
		log.Println("Failed to find verb", verb, "in object", this)
		return
	}
	verbStruct := GetVerbStruct(vobj, verb, 10)
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
			//fmt.Printf("Substituting pmoo vars\n")
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
