package main

import (
	"bufio"
	"flag"
	"fmt"
	"go/build"
	"log"
	"os"
	"reflect"
	"strings"

	. "github.com/donomii/pmoo"
	"github.com/traefik/yaegi/interp"
	"github.com/traefik/yaegi/stdlib"
	"github.com/traefik/yaegi/stdlib/syscall"
)

func main() {
	var init bool
	flag.BoolVar(&init, "init", false, "Create a core object.  Overwrites existing")

	flag.Parse()
	if init {
		log.Println("Overwriting core")
		coreObj := Object{}
		coreObj.Verbs = map[string]Verb{}
		coreObj.Properties = map[string]Property{}

		coreObj.Properties["player"] = Property{Value: `false`}
		coreObj.Properties["location"] = Property{Value: `0`}
		coreObj.Properties["parent"] = Property{Value: `0`}
		coreObj.Properties["owner"] = Property{Value: `0`}
		coreObj.Properties["programmer"] = Property{Value: `false`}
		coreObj.Properties["wizard"] = Property{Value: `false`}
		coreObj.Properties["read"] = Property{Value: `true`}
		coreObj.Properties["write"] = Property{Value: `false`}

		prop := Verb{Value: `//go
	p := Property{Value: iobjstr}
	dobj.Properties[dpropstr] = p
	SaveObject(dobj)
	`}
		coreObj.Verbs["property"] = prop

		ver := Verb{Value: `//go
	v := Verb{Value: iobjstr}
	dobj.Verbs[dpropstr] = v
	SaveObject(dobj)
	`}
		coreObj.Verbs["verb"] = ver

		SaveObject(coreObj)

		log.Println("Overwriting Player 1")
		playerobj := Object{}
		playerobj.Verbs = map[string]Verb{}
		playerobj.Properties = map[string]Property{}

		playerobj.Properties["player"] = Property{Value: `true`}
		playerobj.Properties["location"] = Property{Value: `0`}
		playerobj.Properties["parent"] = Property{Value: `1`}
		playerobj.Properties["owner"] = Property{Value: `1`}
		playerobj.Properties["programmer"] = Property{Value: `true`}
		playerobj.Properties["wizard"] = Property{Value: `true`}
		playerobj.Properties["read"] = Property{Value: `true`}
		playerobj.Properties["write"] = Property{Value: `false`}

	}
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
	/*
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
	*/
	//i.Eval(lib())
	//log.Println("libs loaded")
	reader := bufio.NewReader(os.Stdin)
	var verb Verb
	player := "1"
	for {

		fmt.Println(verb)
		fmt.Print("Enter text: ")
		text, _ := reader.ReadString('\n')
		text = text[:len(text)-1]
		fmt.Println(text)
		verb, directObjectStr, prepositionStr, indirectObjectStr := BreakSentence(text)
		dobjstr, dpropstr := ParseDo(directObjectStr)
		iobjstr, ipropstr := ParseDo(indirectObjectStr)
		dobj := LoadObject(dobjstr)
		//iobj := LoadObject(iobjstr)

		call := ` 
		import . "github.com/donomii/pmoo"
		
		func runme(){
	
		
		player := LoadObject("` + player + `")  //an object, the player who typed the command` + `
		this := LoadObject("` + player + `") //an object, the object on which this verb was found
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

		ve := dobj.Verbs[verb]
		//log.Println(do)
		//log.Println("Verb", verb, "is", ve)
		call = call + ve.Value
		log.Println("Evalling ", call)
		var v reflect.Value
		v, err := i.Eval(call + `}
		func main() {runme()}`)
		fmt.Println(err)
		if v.IsValid() {
			fmt.Println(v)
		}
	}
}

func lib() string {
	return `
	import (
	
		"os"

	)
	type Property struct {
		Value       string
		Owner       string
		Read        bool
		Write       bool
		ChangeOwner bool
	}
	
	type Verb struct {
		Value   string
		Owner   string
		Read    bool
		Write   bool
		Execute bool
		Debug   bool
	}
	
	type Object struct {
		Properties map[string]Property
		Verbs      map[string]Verb
		Id         int
	}
	
	func SaveObject(o Object) {
os.Mkdir("objects", 0777)
txt, err := json.Marshal(o)
panicErr(err)
err = ioutil.WriteFile(fmt.Sprintf("objects/%v.json", o.Id), txt, 0600)
panicErr(err)
}

func LoadObject(id string) Object {
log.Println("Loading " + "objects/" + id + ".json")
file, _ := ioutil.ReadFile("objects/" + id + ".json")

data := Object{}

_ = json.Unmarshal([]byte(file), &data)
return data
}
func ParseDo(s string) (string, string) {
log.Println("Splitting", s, "on", ".")
ss := strings.Split(s, ".")
ss = append(ss, "no property")
return ss[0], ss[1]
}`
}

/*
name
a string, the usual name for this object
owner
an object, the player who controls access to it
location
an object, where the object is in virtual reality
contents
a list of objects, the inverse of location
programmer
a bit, does the object have programmer rights?
wizard
a bit, does the object have wizard rights?
r
a bit, is the object publicly readable?
w
a bit, is the object publicly writable?
f
a bit, is the object fertile?

*/
