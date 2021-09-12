package main

import (
	"bufio"
	"flag"
	"fmt"
	"go/build"
	"log"
	"os"
	"strings"

	. "github.com/donomii/pmoo"
	"github.com/traefik/yaegi/interp"
	"github.com/traefik/yaegi/stdlib"
	"github.com/traefik/yaegi/stdlib/syscall"
	"github.com/traefik/yaegi/stdlib/unrestricted"
	"github.com/traefik/yaegi/stdlib/unsafe"
)

func toStr(i interface{}) string {
	return fmt.Sprintf("%v", i)
}
func VerbSearch(o *Object, aName string) (*Object, *Property) {

	locId := GetProperty(o, "location", 10).Value
	loc := LoadObject(locId)
	contains := SplitStringList(GetProperty(loc, "contains", 10).Value)
	contains = append([]string{toStr(o.Id), locId}, contains...)
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

	locId := GetProperty(o, "location", 10).Value
	loc := LoadObject(locId)
	contains := SplitStringList(GetProperty(loc, "contains", 10).Value)
	contains = append([]string{locId, toStr(o.Id)}, contains...)
	for _, objId := range contains {
		obj := LoadObject(objId)
		nameProp := GetProperty(obj, "name", 10)
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
		return GetProperty(LoadObject(objId), "location", 10).Value, ""
	}

	//It's a generic object, look for it in the properties of #1
	if s[0] == '$' {
		prop := s[1:]
		one := LoadObject("1")
		oneprop := GetProperty(one, prop, 10)
		if oneprop == nil {
			fmt.Printf("Could not find special property %v on 1\n", prop)
		}
		objstr := oneprop.Value
		return objstr, ""
	}

	//It's an object number
	if s[0] == '#' {
		s = s[1:]
		log.Println("Splitting", s, "on", ".")
		ss := strings.Split(s, ".")
		ss = append(ss, "no property")
		if ss[0] == "me" {
			return objId, ss[1]
		}
		if ss[0] == "here" {
			return GetProperty(LoadObject(objId), "location", 10).Value, ss[1]
		}
		return ss[0], ss[1]
	}

	//It might be the name of an object somewhere close
	foundObjId, _ := NameSearch(LoadObject(objId), s)
	if foundObjId != nil {
		return toStr(foundObjId.Id), ""
	}

	return s, ""
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
	preps := strings.Split("is with using at to in front of in inside into on top of on onto upon out of from inside from over through under underneath beneath behind beside for about is as off off of", " ")
	for _, p := range preps {
		log.Println("Searching for ", p, "in", words)
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
		return "", "oops", "oops", "oops"
	}
	if len(x) == 1 {
		return s, "oops", "oops", "oops"
	}
	if len(x) == 2 {
		return x[0], x[1], "oops", "oops"
	}
	verb := x[0]
	x = x[1:]
	preppos := FindPreposition(x)
	if preppos < 0 {
		return verb, strings.Join(x, " "), "oops", "oops"
	}

	do := x[:preppos]
	prep := x[preppos]
	io := x[preppos+1:]

	return verb, strings.Join(do, " "), prep, strings.Join(io, " ")

}

//Writes the core objects to disk. Overwrites any that already exist.
func initDB() {
	log.Println("Overwriting core")
	coreObj := Object{}
	coreObj.Id = 1
	coreObj.Properties = map[string]Property{}

	coreObj.Properties["player"] = Property{Value: `false`}
	coreObj.Properties["location"] = Property{Value: `0`}
	coreObj.Properties["parent"] = Property{Value: `1`}
	coreObj.Properties["owner"] = Property{Value: `0`}
	coreObj.Properties["programmer"] = Property{Value: `false`}
	coreObj.Properties["wizard"] = Property{Value: `false`}
	coreObj.Properties["read"] = Property{Value: `true`}
	coreObj.Properties["write"] = Property{Value: `false`}
	coreObj.Properties["contains"] = Property{Value: ``}
	coreObj.Properties["room"] = Property{Value: `4`}
	coreObj.Properties["player"] = Property{Value: `5`}
	coreObj.Properties["thing"] = Property{Value: `6`}
	coreObj.Properties["lastId"] = Property{Value: `101`}

	prop := Property{Value: `//go
	p := Property{Value: iobjstr}
	dobj.Properties[dpropstr] = p
	SaveObject(dobj)
	`, Verb: true}
	coreObj.Properties["property"] = prop

	ver := Property{Value: `//go
	v := Property{Value: iobjstr, Verb: true}
	dobj.Properties[dpropstr] = v
	SaveObject(dobj)
	`, Verb: true}
	coreObj.Properties["verb"] = ver

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
	SaveObject(&coreObj)

	log.Println("Initialised core objects")
}

func NewInterpreter() *interp.Interpreter {
	i := interp.New(interp.Options{GoPath: build.Default.GOPATH, BuildTags: strings.Split("", ",")})
	if err := i.Use(stdlib.Symbols); err != nil {
		panic(err)
	}

	if err := i.Use(interp.Symbols); err != nil {
		panic(err)
	}

	if err := i.Use(syscall.Symbols); err != nil {
		panic(err)
	}

	// Using a environment var allows a nested interpreter to import the syscall package.
	if err := os.Setenv("YAEGI_SYSCALL", "1"); err != nil {
		panic(err)
	}

	if err := i.Use(unsafe.Symbols); err != nil {
		panic(err)
	}
	if err := os.Setenv("YAEGI_UNSAFE", "1"); err != nil {
		panic(err)
	}

	// Use of unrestricted symbols should always follow stdlib and syscall symbols, to update them.
	if err := i.Use(unrestricted.Symbols); err != nil {
		panic(err)
	}

	return i

}

func Eval(i *interp.Interpreter, code string) {
	log.Println("Evalling:", code)

	_, err := i.Eval(`
		
	func runme(){

	` + code + `}
func main() {runme()}`)
	if err != nil {
		fmt.Println("An error occurred:", err)
	}
}

func main() {
	var init bool
	flag.BoolVar(&init, "init", false, "Create basic objects.  Overwrites existing")

	flag.Parse()
	if init {
		initDB()
	}

	i := NewInterpreter()
	i.Eval(`		
	import . "github.com/donomii/pmoo"
	import "os"
	import . "fmt"`)

	reader := bufio.NewReader(os.Stdin)

	player := "2"
	for {

		//fmt.Println(verb)
		fmt.Print("Enter text: ")
		text, _ := reader.ReadString('\n')
		text = text[:len(text)-1]
		verb, directObjectStr, prepositionStr, indirectObjectStr := BreakSentence(text)
		log.Println(strings.Join([]string{verb, directObjectStr, prepositionStr, indirectObjectStr}, ":"))
		dobjstr, dpropstr := ParseDo(directObjectStr, player)
		iobjstr, ipropstr := ParseDo(indirectObjectStr, player)
		dobj := LoadObject(dobjstr)

		this, verbSource := VerbSearch(LoadObject(player), verb)
		if this == nil {
			fmt.Printf("Verb %v not found\n", verb)
			continue
		}

		if verbSource == nil {
			fmt.Printf("Failed to lookup %v on %v\n", verb, dobj.Id)
		} else {
			definitions := ` 

			player := LoadObject("` + player + `")  //an object, the player who typed the command` + `
			playerid := "` + player + `"  //an object id, the player who typed the command` + `
			this := "` + fmt.Sprintf("%v", this.Id) + `" //an object, the object on which this verb was found
			caller := LoadObject("` + player + `")  //an object, the same as player
			verb := "` + verb + `" //a string, the first word of the command
			//argstr //a string, everything after the first word of the command
			//args a list of strings, the words in argstr
			dobjstr := "` + dobjstr + `"` + ` //a string, the direct object string found during parsing
			dpropstr := "` + dpropstr + `"` + ` //a string, the direct object property string found during parsing
			dobj := LoadObject("` + dobjstr + `")  //an object, the direct object value found during matching
			prepstr:= "` + prepositionStr + `" //a string, the prepositional phrase found during parsing
			iobjstr := "` + iobjstr + `" //a string, the indirect object string
			ipropstr := "` + ipropstr + `" //a string, the indirect object string
			iobj := LoadObject("` + iobjstr + `")  //an object, the indirect object value
		`
			definitions = definitions + verbSource.Value
			Eval(i, definitions)
		}
	}
}
