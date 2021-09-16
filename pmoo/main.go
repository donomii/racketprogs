package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"runtime/debug"
	"strings"

	. "github.com/donomii/pmoo"
	"github.com/donomii/throfflib"
	"github.com/traefik/yaegi/interp"
)

func toStr(i interface{}) string {
	return fmt.Sprintf("%v", i)
}
func VerbSearch(o *Object, aName string) (*Object, *Property) {

	locId := GetPropertyStruct(o, "location", 10).Value
	loc := LoadObject(locId)
	roomContents := SplitStringList(GetPropertyStruct(loc, "contains", 10).Value)
	playerContents := SplitStringList(GetPropertyStruct(o, "contains", 10).Value)
	contains := append([]string{toStr(o.Id), locId}, roomContents...)
	contains = append(contains, playerContents...)
	for _, objId := range contains {
		obj := LoadObject(objId)
		nameProp := GetVerbStruct(obj, aName, 10)
		if nameProp != nil {
			return obj, nameProp
		}
	}

	log.Printf("Failed to find verb %v here!\n", aName)
	return nil, nil

}

func NameSearch(o *Object, aName string) (*Object, *Property) {

	locId := GetPropertyStruct(o, "location", 10).Value
	loc := LoadObject(locId)
	contains := SplitStringList(GetPropertyStruct(loc, "contains", 10).Value)
	contains = append([]string{locId, toStr(o.Id)}, contains...)
	for _, objId := range contains {
		obj := LoadObject(objId)
		nameProp := GetPropertyStruct(obj, "name", 10)
		if nameProp != nil {
			if nameProp.Value == aName {
				return obj, nameProp
			}
		}
	}

	log.Printf("Failed to find object %v here!\n", aName)
	return nil, nil

}

func ParseDo(s string, objId string) (string, string) {
	if s == "me" {
		return objId, ""
	}
	if s == "here" {
		return GetPropertyStruct(LoadObject(objId), "location", 10).Value, ""
	}

	//It's a generic object, look for it in the properties of #1
	if len(s) > 0 && s[0] == '$' {
		prop := s[1:]
		one := LoadObject("1")
		oneprop := GetPropertyStruct(one, prop, 10)
		if oneprop == nil {
			fmt.Printf("Could not find special property %v on 1\n", prop)
		}
		objstr := oneprop.Value
		return objstr, ""
	}

	//It's an object number
	if len(s) > 0 && s[0] == '#' {
		s = s[1:]
		log.Println("Splitting", s, "on", ".")
		ss := strings.Split(s, ".")
		ss = append(ss, "no property")
		if ss[0] == "me" {
			return objId, ss[1]
		}
		if ss[0] == "here" {
			return GetPropertyStruct(LoadObject(objId), "location", 10).Value, ss[1]
		}
		return ss[0], ss[1]
	}

	//It might be the name of an object somewhere close
	foundObjId, _ := NameSearch(LoadObject(objId), s)
	if foundObjId != nil {
		return toStr(foundObjId.Id), ""
	}

	return "", ""
}
func Find(a []string, x string) int {
	for i, n := range a {
		if x == n {
			return i
		}
	}
	return -1
}

func FindPreposition(words []string) int {
	preps := strings.Split("named that is with using at to in front of in inside into on top of on onto upon out of from inside from over through under underneath beneath behind beside for about is as off off of", " ")
	for _, p := range preps {
		//log.Println("Searching for ", p, "in", words)
		r := Find(words, p)
		if r > -1 {
			return r
		}
	}
	return -1
}

func BreakSentence(s string) (string, string, string, string) {
	x, _ := LexLine(s)
	log.Printf("Parsed line into %v", strings.Join(x, ":"))
	if len(x) == 0 {
		return "", "", "", ""
	}
	if len(x) == 1 {
		return s, "", "", ""
	}
	if len(x) == 2 {
		return x[0], x[1], "", ""
	}
	verb := x[0]
	x = x[1:]
	preppos := FindPreposition(x)
	if preppos < 0 {
		return verb, strings.Join(x, " "), "", ""
	}

	do := x[:preppos]
	prep := x[preppos]
	io := x[preppos+1:]

	return verb, strings.Join(do, " "), prep, strings.Join(io, " ")

}
func SetThroffVerb(obj, name, code string) {
	log.Println("SetThroffVerb: ", obj, name, code)
	o := LoadObject(obj)
	v := Property{Value: code, Verb: true, Throff: true}
	log.Println("object:", o)
	o.Properties[name] = v
	SaveObject(o)
}

//Writes the core objects to disk. Overwrites any that already exist.
func initDB() {
	log.Println("Overwriting core")
	rootObj := Object{}
	rootObj.Id = 1
	rootObj.Properties = map[string]Property{}

	rootObj.Properties["name"] = Property{Value: `root`}
	rootObj.Properties["player"] = Property{Value: `false`}
	rootObj.Properties["location"] = Property{Value: `0`}
	rootObj.Properties["parent"] = Property{Value: `1`}
	rootObj.Properties["owner"] = Property{Value: `0`}
	rootObj.Properties["programmer"] = Property{Value: `false`}
	rootObj.Properties["wizard"] = Property{Value: `false`}
	rootObj.Properties["read"] = Property{Value: `true`}
	rootObj.Properties["write"] = Property{Value: `false`}
	rootObj.Properties["contains"] = Property{Value: ``}
	rootObj.Properties["room"] = Property{Value: `4`}
	rootObj.Properties["player"] = Property{Value: `5`}
	rootObj.Properties["thing"] = Property{Value: `6`}
	rootObj.Properties["lastId"] = Property{Value: `101`}

	prop := Property{Value: ` SetProp dobj dpropstr iobjstr `, Verb: true, Throff: true}
	rootObj.Properties["property"] = prop

	ver := Property{Value: `SetVerb dobj dpropstr iobjstr`, Verb: true}
	rootObj.Properties["goscript"] = ver

	thr := Property{Value: `SetThroffVerb dobj dpropstr iobjstr`, Verb: true, Throff: true}
	rootObj.Properties["verb"] = thr

	log.Println("Overwriting Player 1")
	playerobj := Object{}
	playerobj.Id = 2
	playerobj.Properties = map[string]Property{}

	playerobj.Properties["name"] = Property{Value: "Wizard"}
	playerobj.Properties["description"] = Property{Value: "an old man with a scruffy beard, and a wizard's robe and hat"}
	playerobj.Properties["player"] = Property{Value: `true`}
	playerobj.Properties["location"] = Property{Value: `3`}
	playerobj.Properties["parent"] = Property{Value: `5`}
	playerobj.Properties["owner"] = Property{Value: `1`}
	playerobj.Properties["programmer"] = Property{Value: `true`}
	playerobj.Properties["wizard"] = Property{Value: `true`}
	playerobj.Properties["read"] = Property{Value: `true`}
	playerobj.Properties["write"] = Property{Value: `false`}
	playerobj.Properties["contains"] = Property{Value: ``}
	SaveObject(&playerobj)

	log.Println("Overwriting oops")
	oops := Object{}
	oops.Id = 0
	oops.Properties = map[string]Property{}

	oops.Properties["player"] = Property{Value: `false`}
	oops.Properties["location"] = Property{Value: `0`}
	oops.Properties["parent"] = Property{Value: `1`}
	oops.Properties["owner"] = Property{Value: `1`}
	oops.Properties["programmer"] = Property{Value: `false`}
	oops.Properties["wizard"] = Property{Value: `false`}
	oops.Properties["read"] = Property{Value: `true`}
	oops.Properties["write"] = Property{Value: `false`}
	oops.Properties["contains"] = Property{Value: ``}
	SaveObject(&oops)

	log.Println("Overwriting First room")
	room := Object{}
	room.Id = 3
	room.Properties = map[string]Property{}

	room.Properties["name"] = Property{Value: `The First Room`}
	room.Properties["description"] = Property{Value: `The default entrance.`}
	room.Properties["player"] = Property{Value: `false`}
	room.Properties["location"] = Property{Value: `0`}
	room.Properties["parent"] = Property{Value: `4`}
	room.Properties["owner"] = Property{Value: `1`}
	room.Properties["programmer"] = Property{Value: `false`}
	room.Properties["wizard"] = Property{Value: `false`}
	room.Properties["read"] = Property{Value: `true`}
	room.Properties["write"] = Property{Value: `false`}
	room.Properties["contains"] = Property{Value: ``}
	SaveObject(&room)

	log.Println("Overwriting genroom")
	genroom := Object{}
	genroom.Id = 4
	genroom.Properties = map[string]Property{}

	genroom.Properties["name"] = Property{Value: `Generic Room`}
	genroom.Properties["description"] = Property{Value: `You see nothing special.`}
	genroom.Properties["player"] = Property{Value: `false`}
	genroom.Properties["location"] = Property{Value: `4`}
	genroom.Properties["parent"] = Property{Value: `1`}
	genroom.Properties["owner"] = Property{Value: `1`}
	genroom.Properties["programmer"] = Property{Value: `false`}
	genroom.Properties["wizard"] = Property{Value: `false`}
	genroom.Properties["read"] = Property{Value: `true`}
	genroom.Properties["write"] = Property{Value: `false`}
	genroom.Properties["contains"] = Property{Value: ``}
	SaveObject(&genroom)

	log.Println("Overwriting generic player")
	genplayer := Object{}
	genplayer.Id = 5
	genplayer.Properties = map[string]Property{}

	genplayer.Properties["name"] = Property{Value: "Generic player"}
	genplayer.Properties["description"] = Property{Value: "A wavering, indistinct figure"}
	genplayer.Properties["player"] = Property{Value: `true`}
	genplayer.Properties["location"] = Property{Value: `5`}
	genplayer.Properties["parent"] = Property{Value: `1`}
	genplayer.Properties["owner"] = Property{Value: `1`}
	genplayer.Properties["programmer"] = Property{Value: `false`}
	genplayer.Properties["wizard"] = Property{Value: `false`}
	genplayer.Properties["read"] = Property{Value: `false`}
	genplayer.Properties["write"] = Property{Value: `false`}
	genplayer.Properties["contains"] = Property{Value: ``}
	SaveObject(&genplayer)

	log.Println("Overwriting generic thing")
	genthing := Object{}
	genthing.Id = 6
	genthing.Properties = map[string]Property{}

	genthing.Properties["name"] = Property{Value: "Generic thing"}
	genthing.Properties["description"] = Property{Value: "small, grey and uninteresting"}
	genthing.Properties["player"] = Property{Value: `false`}
	genthing.Properties["location"] = Property{Value: `6`}
	genthing.Properties["parent"] = Property{Value: `1`}
	genthing.Properties["owner"] = Property{Value: `1`}
	genthing.Properties["programmer"] = Property{Value: `false`}
	genthing.Properties["wizard"] = Property{Value: `false`}
	genthing.Properties["read"] = Property{Value: `false`}
	genthing.Properties["write"] = Property{Value: `false`}
	genthing.Properties["contains"] = Property{Value: ``}
	SaveObject(&genthing)

	log.Println("Overwriting core object")
	coreObj := Object{}
	coreObj.Id = 7
	coreObj.Properties = map[string]Property{}

	coreObj.Properties["name"] = Property{Value: "Core"}
	coreObj.Properties["description"] = Property{Value: "System core"}
	coreObj.Properties["player"] = Property{Value: `false`}
	coreObj.Properties["location"] = Property{Value: `7`}
	coreObj.Properties["parent"] = Property{Value: `7`}
	coreObj.Properties["owner"] = Property{Value: `7`}
	coreObj.Properties["programmer"] = Property{Value: `false`}
	coreObj.Properties["wizard"] = Property{Value: `false`}
	coreObj.Properties["read"] = Property{Value: `false`}
	coreObj.Properties["write"] = Property{Value: `false`}
	coreObj.Properties["contains"] = Property{Value: ``}
	SaveObject(&coreObj)
	SaveObject(&rootObj)

	log.Println("Initialised core objects")
}

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
func StringsToStack(stringBits []string) throfflib.Stack {
	var tokens throfflib.Stack

	for _, v := range stringBits {
		if len(v) > 0 {
			t := throfflib.NewToken(v, throfflib.NewHash())

			tokens = throfflib.PushStack(tokens, t)
		}
	}
	return tokens
}

func AddEngineFuncs(e *throfflib.Engine, player, from, traceId string) {
	e = throfflib.Add(e, "Msg", throfflib.NewCode("Msg", 6, 6, 0, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {

		from, ne := throfflib.PopData(ne)
		target, ne := throfflib.PopData(ne)
		verb, ne := throfflib.PopData(ne)
		dobj, ne := throfflib.PopData(ne)
		prep, ne := throfflib.PopData(ne)
		iobj, ne := throfflib.PopData(ne)

		//log.Printf("From: %v, Target: %v, Verb: %v, Dobj: %v, Prep: %v, Iobj: %v\n", from.GetString(), target.GetString(), verb.GetString(), dobj.GetString(), prep.GetString(), iobj.GetString())

		SendNetQ(Message{From: from.GetString(), Player: player, This: target.GetString(), Verb: verb.GetString(), Dobj: dobj.GetString(), Prepstr: prep.GetString(), Iobj: iobj.GetString(), Trace: traceId})
		//RawMsg(Message{From: player, Player: player, This: target.GetString(), Verb: verb.GetString(), Dobj: dobj.GetString(), Prepstr: prep.GetString(), Iobj: iobj.GetString(), Trace: traceId})
		//Msg(from.GetString(), target.GetString(), verb.GetString(), dobj.GetString(), prep.GetString(), iobj.GetString())
		return ne
	}))

	e = throfflib.Add(e, "FormatObject", throfflib.NewCode("FormatObject", 0, 1, 1, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {
		//Fetch data from throff
		obj, ne := throfflib.PopData(ne)

		//do something with it
		out := FormatObject(obj.GetString())

		//Push the result into the engine
		o := throfflib.NewString(out, throfflib.Environment(e))
		ne = throfflib.PushData(ne, o)
		return ne
	}))

	e = throfflib.Add(e, "Clone", throfflib.NewCode("Clone", 0, 1, 1, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {
		//Fetch data from throff
		obj, ne := throfflib.PopData(ne)

		//do something with it
		out := Clone(obj.GetString())

		//Push the result into the engine
		o := throfflib.NewString(out, throfflib.Environment(e))
		ne = throfflib.PushData(ne, o)
		return ne
	}))

	e = throfflib.Add(e, "GetProp", throfflib.NewCode("GetProp", 1, 2, 1, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {

		obj, ne := throfflib.PopData(ne)
		prop, ne := throfflib.PopData(ne)

		out := GetProp(obj.GetString(), prop.GetString())
		o := throfflib.NewString(out, throfflib.Environment(e))
		ne = throfflib.PushData(ne, o)
		return ne
	}))

	e = throfflib.Add(e, "SetProp", throfflib.NewCode("SetProp", 3, 3, 0, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {

		obj, ne := throfflib.PopData(ne)
		prop, ne := throfflib.PopData(ne)
		val, ne := throfflib.PopData(ne)

		SetProp(obj.GetString(), prop.GetString(), val.GetString())
		return ne
	}))

	e = throfflib.Add(e, "SetThroffVerb", throfflib.NewCode("SetThroffVerb", 3, 3, 0, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {

		obj, ne := throfflib.PopData(ne)
		name, ne := throfflib.PopData(ne)
		code, ne := throfflib.PopData(ne)

		SetThroffVerb(obj.GetString(), name.GetString(), code.GetString())
		return ne
	}))

	e = throfflib.Add(e, "MoveObj", throfflib.NewCode("MoveObj", 2, 2, 0, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {

		obj, ne := throfflib.PopData(ne)
		target, ne := throfflib.PopData(ne)

		MoveObj(obj.GetString(), target.GetString())
		return ne
	}))

	e = throfflib.Add(e, "GetVerb", throfflib.NewCode("GetVerb", 1, 2, 1, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {

		obj, ne := throfflib.PopData(ne)
		prop, ne := throfflib.PopData(ne)

		out := GetVerb(obj.GetString(), prop.GetString())
		o := throfflib.NewString(out, throfflib.Environment(e))
		ne = throfflib.PushData(ne, o)
		return ne
	}))

	e = throfflib.Add(e, "VisibleObjects", throfflib.NewCode("VisibleObjects", 0, 1, 1, func(ne *throfflib.Engine, c *throfflib.Thingy) *throfflib.Engine {

		player, ne := throfflib.PopData(ne)

		out := VisibleObjects(LoadObject(player.GetString()))
		o := throfflib.NewArray(StringsToStack(out))
		ne = throfflib.PushData(ne, o)
		return ne
	}))
}

var goScript *interp.Interpreter

func main() {

	var init bool
	flag.BoolVar(&init, "init", false, "Create basic objects.  Overwrites existing")
	flag.BoolVar(&Cluster, "cluster", false, "Run in cluster mode.  See instructions.")

	flag.Parse()
	if init {
		initDB()
	}
	if Cluster {
		startNetworkQ()
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

			log.Printf("Invoking direct message %+v", m)
			invoke(m.Player, m.This, m.Verb, m.Dobj, m.Dpropstr, m.Prepstr, m.Iobj, m.Ipropstr, m.Dobjstr, m.Iobjstr)
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
			SendNetQ(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace})
			//RawMsg(Message{Player: player, This: this, Verb: verb, Dobj: dobj, Dpropstr: dpropstr, Prepstr: prepstr, Iobj: iobj, Ipropstr: ipropstr, Dobjstr: dobjstr, Iobjstr: iobjstr, Trace: m.Trace})
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
