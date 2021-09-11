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
	"github.com/traefik/yaegi/stdlib/unrestricted"
	"github.com/traefik/yaegi/stdlib/unsafe"
)

func VerbSearch(o *Object, verb string) (*Object, *Verb) {
	ve := GetVerb(o, verb, 10)
	foundObj := o
	if ve == nil {
		parent := LoadObject(GetProperty(o, "location", 10).Value)
		ve = GetVerb(parent, verb, 10)
		foundObj = parent
		if ve == nil {
			fmt.Printf("Failed to lookup %v on %v\n", verb, o.Id)
			return nil, nil
		}
	}
	return foundObj, ve

}

func main() {
	var init bool
	flag.BoolVar(&init, "init", false, "Create a core object.  Overwrites existing")

	flag.Parse()
	if init {
		log.Println("Overwriting core")
		coreObj := Object{}
		coreObj.Id = 1
		coreObj.Verbs = map[string]Verb{}
		coreObj.Properties = map[string]Property{}

		coreObj.Properties["player"] = Property{Value: `false`}
		coreObj.Properties["location"] = Property{Value: `0`}
		coreObj.Properties["parent"] = Property{Value: `1`}
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

		SaveObject(&coreObj)

		log.Println("Overwriting Player 1")
		playerobj := Object{}
		playerobj.Id = 2
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
		SaveObject(&playerobj)

		log.Println("Overwriting oops")
		oops := Object{}
		oops.Id = 0
		oops.Verbs = map[string]Verb{}
		oops.Properties = map[string]Property{}

		oops.Properties["player"] = Property{Value: `false`}
		oops.Properties["location"] = Property{Value: `0`}
		oops.Properties["parent"] = Property{Value: `1`}
		oops.Properties["owner"] = Property{Value: `1`}
		oops.Properties["programmer"] = Property{Value: `false`}
		oops.Properties["wizard"] = Property{Value: `false`}
		oops.Properties["read"] = Property{Value: `true`}
		oops.Properties["write"] = Property{Value: `false`}
		SaveObject(&oops)

		log.Println("Overwriting First room")
		room := Object{}
		room.Id = 3
		room.Verbs = map[string]Verb{}
		room.Properties = map[string]Property{}

		room.Properties["description"] = Property{Value: `The First Room`}
		room.Properties["player"] = Property{Value: `false`}
		room.Properties["location"] = Property{Value: `0`}
		room.Properties["parent"] = Property{Value: `1`}
		room.Properties["owner"] = Property{Value: `1`}
		room.Properties["programmer"] = Property{Value: `false`}
		room.Properties["wizard"] = Property{Value: `false`}
		room.Properties["read"] = Property{Value: `true`}
		room.Properties["write"] = Property{Value: `false`}
		SaveObject(&room)
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

	i.Eval(`		import . "github.com/donomii/pmoo"
		import "os"
		import . "fmt"`)
	//log.Println("libs loaded")
	reader := bufio.NewReader(os.Stdin)
	var verb Verb
	player := "2"
	for {

		fmt.Println(verb)
		fmt.Print("Enter text: ")
		text, _ := reader.ReadString('\n')
		text = text[:len(text)-1]
		fmt.Println(text)
		verb, directObjectStr, prepositionStr, indirectObjectStr := BreakSentence(text)
		dobjstr, dpropstr := ParseDo(directObjectStr, player)
		iobjstr, ipropstr := ParseDo(indirectObjectStr, player)
		dobj := LoadObject(dobjstr)
		//iobj := LoadObject(iobjstr)

		this, verbSource := VerbSearch(LoadObject(player), verb)
		if this == nil {
			fmt.Printf("Verb %v not found\n", verb)
			continue
		}
		call := ` 

		
		func runme(){
	
		
		player := LoadObject("` + player + `")  //an object, the player who typed the command` + `
		this := LoadObject("` + fmt.Sprintf("%v", this.Id) + `") //an object, the object on which this verb was found
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

		if verbSource == nil {
			fmt.Printf("Failed to lookup %v on %v\n", verb, dobj.Id)
		} else {
			//log.Println(do)
			//log.Println("Verb", verb, "is", ve)
			call = call + verbSource.Value
			//log.Println("Evalling ", call)
			var v reflect.Value
			v, err := i.Eval(call + `}
		func main() {runme()}`)
			fmt.Println(err)
			if v.IsValid() {
				fmt.Println(v)
			}
		}
	}
}
