package pmoo

import (
	"embed"
	"encoding/json"
	"errors"
	"fmt"
	"go/build"
	"io/ioutil"
	"log"
	"os"
	"runtime/debug"
	"strings"
	"time"

	"github.com/donomii/goof"
	"github.com/google/uuid"
	"github.com/traefik/yaegi/interp"
	"github.com/traefik/yaegi/stdlib"
	"github.com/traefik/yaegi/stdlib/syscall"
	"github.com/traefik/yaegi/stdlib/unrestricted"
	"github.com/traefik/yaegi/stdlib/unsafe"
)

// content holds our static web server content.
//go:embed fallback/*
var fallback_objs embed.FS

//The default amount of ticks to allocate to a new message.
var DefaultTicks = 1000

//Operate in cluster mode.  i.e. use the networked object store and networked queue
var Cluster bool

//the IP address of the queue and object server
var QueueServer string

//If using the filesystem data store, objects will be stored in this directory
var DataDir string = "objects"

//Choose the network Queue server
func SetQueueServer(s string) {
	QueueServer = s
}

//Somewhere to save the objects
func SetDataDir(s string) {
	DataDir = s
}

type Message struct {
	Player string //The player id (the object id)
	This   string //The object that is currently executing the method (i.e. the usual OO "this")
	// The parts of speech from the sentence that the user typed in.  Not all of them will be present, e.g. the indirect object may be missing.
	Verb                                                      string
	Dobj, Dpropstr, Prepstr, Iobj, Ipropstr, Dobjstr, Iobjstr string
	Data                                                      string   //An arbitary data field
	From                                                      string   //The object that sent the message (i.e. the caller)
	Trace                                                     string   //Switch on message tracing for this message and all its consequents
	Affinity                                                  string   //Force this message to be processed on a node with matching affinity (i.e. force it to run on a particular computer)
	Args                                                      []string //An alternate way of passing method args, for more traditional methods that are not exposed to the user.
	Ticks                                                     int      //The amount of allowed runtime remaining.  Stops infinite loops.
}

var Q chan *Message

func SetQ(queue chan *Message) {
	Q = queue
	//log.Printf(" set queue to %v", Q)
}

//Take a message from the user and submit it to the queue
func InputMsg(from, target, verb, arg1 string) {
	m := &Message{Player: from, This: target, Verb: verb, Data: arg1, Ticks: DefaultTicks}
	log.Printf("**********Queueing Message %v to %v\n", m, Q)
	Q <- m
	log.Println("**************Message queued")
}

//Submit a message to the queue
func Msg(from, target, verb, dobjstr, prep, iobjstr string) {
	m := &Message{Player: from, This: target, Verb: verb, Dobjstr: dobjstr, Prepstr: prep, Iobjstr: iobjstr, Ticks: DefaultTicks}
	Q <- m
	log.Printf("Audit: Message %v\n", m)
}

//Submit a constructed message struct to the queue
func RawMsg(m Message) {
	Q <- &m
	log.Printf("Audit: Message %v\n", m)
}

//An object property
type Property struct {
	Value       string
	Verb        bool
	Throff      bool
	Interpreter string
}

//An object
type Object struct {
	Properties map[string]Property
	Id         string
}

//If error is not nil, panic
func panicErr(err error) {
	if err != nil {
		panic(err)
	}
}

//Convert anything to a string
func ToStr(i interface{}) string {
	return fmt.Sprintf("%v", i)
}

//Return all the visible objects in the room
func VisibleObjects(player *Object) []string { //FIXME use player id string, not obj
	out := []string{}

	locId := GetPropertyStruct(player, "location", 10).Value
	loc := LoadObject(locId)
	contents := SplitStringList(GetPropertyStruct(loc, "contents", 10).Value)
	contents = append([]string{locId}, contents...)
	log.Printf("Visible objects for player %v in %v: %v\n", player.Id, locId, contents)
	for _, objId := range contents {
		if objId != "" {
			out = append(out, objId)
		}
	}
	return out
}

func FuckGo(cond bool, v1, v2 string) string {
	if cond {
		return v1
	} else {
		return v2
	}
}

//Arrange and object for user display
func FormatObject(id string) string {
	o := LoadObject(id)
	if o == nil {
		return "Object id '" + id + "' not found"
		debug.PrintStack()
	}
	var out string
	loc := GetProp(id, "location")
	locName := "Not found"
	if loc != "" {
		locName = GetProp(loc, "name")
	}
	shortName := GetProp(ToStr(o.Id), "name")

	out = out + fmt.Sprintf("\n\nObject %v, %v at %v\n\nVerbs\n-----\n", id, shortName, locName)
	o = LoadObject(id)
	var verbs, props []string
	for k, v := range o.Properties {
		if v.Verb {
			verbs = append(verbs, k)
		} else {
			props = append(props, k)
		}

	}
	out = out + strings.Join(verbs, ",") + "\n\nProperties\n----------\n" + strings.Join(props, ",") + "\n"
	out = out + "\nDefinitions\n-----------\n"
	for k, v := range o.Properties {
		if v.Throff {
			out = out + fmt.Sprintf("%v(Verb,Throff): %v\n", k, v.Value)
		} else {
			out = out + fmt.Sprintf("%v(Noun): %v\n", k, v.Value)
		}

	}
	return out
}

//Print an object to the screen
func DumpObject(id string) {
	fmt.Println(FormatObject(id))
}

//Log a message to the log system
func L(s interface{}) {
	log.Println(s)
}

//Store an object in the database
func SaveObject(o *Object) {
	txt, err := json.MarshalIndent(o, "", " ")
	panicErr(err)
	if Cluster {
		for !DatabaseConnection(QueueServer) {
			log.Println("Lost connection to database at ", QueueServer, ", retrying")
			time.Sleep(time.Second)
		}
		StoreObject(QueueServer, o.Id, o)
	} else {
		os.Mkdir(DataDir, 0600)

		err = ioutil.WriteFile(fmt.Sprintf(DataDir+"/%v.json", o.Id), txt, 0600)
		panicErr(err)
		goof.QCI([]string{"sync"})
	}
	log.Printf("Audit: saved object %v\n", o.Id)
}

//Attempt to load object from network server or disk, depending on mode
func LoadObject(id string) *Object {
	if Cluster {
		for !DatabaseConnection(QueueServer) {
			log.Println("Lost connection to database ", QueueServer, ", retrying")
			time.Sleep(time.Second)
		}
		return FetchObject(QueueServer, id)
	} else {
		if id == "" {
			log.Println("LoadObject called with empty id")
			return nil
		}
		name := DataDir + "/" + id + ".json"
		//fmt.Println("Loading '" + name + "'")
		file, err := ioutil.ReadFile(name)
		if err != nil {
			log.Println("Failed to load" + name)
			file, err = fallback_objs.ReadFile("fallback/" + id + ".json")
			if err != nil {
				log.Println("Failed to load" + name)
				return nil
			}
		}

		data := Object{}

		err = json.Unmarshal([]byte(file), &data)
		if err != nil {
			log.Println("Failed to unmarshal"+name, err)
			return nil
		}

		//fmt.Printf("%+v\n", data)
		return &data
	}
}
func RecFindProp(o *Object, name string, timeout int) *Object {
	//log.Println(o)
	if timeout < 1 {
		log.Printf("Timeout while looking up %v on %v\n", name, o.Id)
		return nil
	}
	if o == nil {
		return nil
	}
	log.Printf("Searching for property %v in %v(%v)\n", name, o.Id, o.Properties["name"].Value)
	val, ok := o.Properties[name]
	if ok {
		log.Printf("Found %v\n", val)
		return o
	}
	parentProp, ok := o.Properties["parent"]
	log.Printf("Moving to parent %v\n", parentProp)
	if !ok {
		//All objects must have a parent
		panic(fmt.Sprintf("No parent for %v when looking for property %v in %v", o.Id, name, o.Id))
	}
	parent := parentProp.Value
	//log.Printf("Searching %v, then parent %v\n", fmt.Sprintf("%v", o.Id), parent)
	//Object points to itself, time to quit
	if parent == fmt.Sprintf("%v", o.Id) {
		return nil
	}
	return RecFindProp(LoadObject(parent), name, timeout-1)
}

//Fixme copied
func GetPropertyStruct(o *Object, name string, timeout int) *Property {
	val, ok := o.Properties[name]
	if ok {
		return &val
	}
	return nil
}

//Load a property from an object (given object id)
func GetProp(objstr, name string) string {
	if objstr == "" {
		panic("GetProp called with empty object id")
	}
	o := RecFindProp(LoadObject(objstr), name, 10)
	//fmt.Println("GetProp", objstr, name, o)
	if o == nil {
		return ""
		//FIXME panic(fmt.Sprintf("GetProp called with invalid object id '%v'", objstr))
	}
	p := GetPropertyStruct(o, name, 10)
	if p != nil {
		return p.Value
	} else {
		return ""
	}
}

//Load a verb from an object (given object id)
func GetVerb(objstr, name string) string {
	o := RecFindProp(LoadObject(objstr), name, 10)
	p := GetVerbStruct(o, name, 10)
	if p != nil {
		return p.Value
	} else {
		return ""
	}
}

func GetVerbStruct(o *Object, name string, timeout int) *Property {
	if o == nil {
		return nil
	}

	val, ok := o.Properties[name]
	if ok {
		if val.Verb {
			log.Printf("Found %v in %v(%v)", name, o.Id, GetProp(o.Id, "name"))
			return &val
		}
		//Property is not a verb.  Maybe we should stop here anyway?
	} else {
		//log.Printf("Verb not found in %v", o.Properties)
	}

	return nil
}

//Allocate a new GUID for an object.  GUID will be ASCII, and hopefully unique
func GetFreshId() string {

	guid, err := uuid.NewUUID()
	panicErr(err)
	return guid.String()
}

//Copy a loaded MOO object.  Saves the copy before returning
func CloneObject(o *Object, location string) *Object {
	log.Printf("Cloning %v\n", o.Id)
	out := *o
	name := out.Properties["name"]
	name.Value = "Copy of " + name.Value
	out.Properties["name"] = name
	out.Id = GetFreshId()

	loc := out.Properties["location"]
	loc.Value = location
	out.Properties["location"] = loc

	newloc := LoadObject(location)
	if newloc == nil {
		panic("CloneObject called with invalid location")
	}
	cont, ok := newloc.Properties["contents"]
	log.Printf("Found contents %v of %v\n", cont, location)
	if !ok {
		panic("CloneObject called with invalid contents for newloc")
	}
	cont.Value = AddToStringList(cont.Value, out.Id)
	log.Printf("New contents %v of %v\n", cont, location)
	newloc.Properties["contents"] = cont

	SaveObject(&out)
	log.Printf("Saved %v\n", out.Id)
	SaveObject(newloc)
	log.Printf("Saved %v\n", newloc.Id)
	goof.QC([]string{"ls objects"})
	log.Println("Audit: Cloned ", o.Id, " to ", out.Id, " at ", location)
	return &out
}

//Create a copy of a MOO object
func Clone(objstr, location string) string {
	sourceO := LoadObject(objstr)
	newO := CloneObject(sourceO, location)
	return ToStr(newO.Id)
}

//Set a property on a loaded object
func SetProperty(o *Object, name, value string) {
	log.Printf("Setting property %v on object %v to %v\n", name, o.Id, value)
	prop := GetPropertyStruct(o, name, 10)
	if prop == nil {
		prop = &Property{}
	}
	p := *prop
	p.Value = value
	o.Properties[name] = p
	log.Printf("Audit: Set property %v on %v to %v\n", name, o.Id, value)
	SaveObject(o)
}

//Set a property on an object
func SetProp(objstr, name, value string) {
	log.Printf("Setting prop %v on object %v to %v\n", name, objstr, value)
	o := LoadObject(objstr)
	if o == nil {
		log.Printf("Object '%v' not found!\n", objstr)
	}
	//Send message to player that the object does not exist
	SetProperty(o, name, value)
}

//Delete a property from an object
func DeleteProperty(o *Object, name string) {
	log.Printf("Deleting property %v on object %v\n", name, o.Id)
	delete(o.Properties, name)
	log.Printf("Audit: Deleted property %v on %v\n", name, o.Id)
	SaveObject(o)
}
func DelProp(objstr, name string) {
	log.Printf("Deleting prop %v on object %v\n", name, objstr)
	o := LoadObject(objstr)
	if o == nil {
		log.Printf("Object '%v' not found!\n", objstr)
	}
	DeleteProperty(o, name)
}

func SetVerbStruct(o *Object, name, value, interpreter string) {
	//fmt.Printf("Setting verb %v on object %v to %v\n", name, o, value)

	prop := &Property{Verb: true}

	prop.Verb = true
	p := *prop
	p.Value = value
	p.Interpreter = interpreter
	if interpreter == "throff" {
		p.Throff = true
	}
	o.Properties[name] = p
	log.Printf("Audit: Set verb %v on %v to %v\n", name, o.Id, value)
	SaveObject(o)
}

//Set a verb on an object (given object id)
func SetVerb(objstr, name, value, interpreter string) {
	if objstr == "" {
		panic("SetVerb called with empty object id")
	}
	if name == "" {
		panic("SetVerb called with empty verb name")
	}
	if value == "" {
		panic("SetVerb called with empty verb value")
	}
	o := LoadObject(objstr)
	if o == nil {
		log.Printf("SetVerb: Object id '%v' not found!\n", objstr)
	}
	SetVerbStruct(o, name, value, interpreter)
}

//pmoo keeps its lists as a comma-separated string, so we need to convert to a slice
func SplitStringList(s string) []string {
	return strings.Split(s, ",")
}

//Slice to comma-separated string
func BuildStringList(l []string) string {
	return strings.Join(l, ",")
}

//shortcut: add an object id to a comma-separated list
func AddToStringList(l, s string) string {
	if l == "" {
		return s
	}
	return l + "," + s
}

//shortcut: remove an object id from a comma-separated list
func RemoveFromStringList(l, s string) string {
	list := SplitStringList(l)
	var out []string
	for _, v := range list {
		if v != s {
			out = append(out, v)
		}
	}
	return BuildStringList(out)
}

//create a new yaegi interpreter
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

//Run some code in a yaegi interpreter
func Eval(i *interp.Interpreter, code string) {
	prog := `
		
	func runme(){

	` + code + `
}
func main() {runme()}`
	log.Println("Evalling:", prog)

	_, err := i.Eval(prog)
	if err != nil {
		fmt.Println("An error occurred:", err)
	}
}

//Implementing move as a built-in because it is complicated enough to need it
func MoveObj(objstr, targetstr string) bool {
	log.Printf("Moving %v to %v", objstr, targetstr)
	if objstr == "" || targetstr == "" {
		log.Printf("MoveObj: objstr or targetstr is empty")
		return false
	}
	//Remove from old location
	oldlocationstr := GetProp(objstr, "location")
	if oldlocationstr == "" {
		log.Printf("MoveObj: objstr %v has no location", objstr)
		return false
	}
	log.Printf("Old location: %v", oldlocationstr)
	oldloc := LoadObject(oldlocationstr)
	log.Printf("Old location object: %v", oldloc)
	if oldloc == nil {
		log.Printf("MoveObj: oldlocationstr %v is not a valid object", oldlocationstr)
		return false
	}
	oldcontainercontentsstr := GetProp(oldlocationstr, "contents")
	newcontainerstr := RemoveFromStringList(oldcontainercontentsstr, objstr)
	oldtargetcontainerstr := GetProp(targetstr, "contents")
	newtargetcontainerstr := AddToStringList(oldtargetcontainerstr, objstr)
	if newtargetcontainerstr == "" {
		log.Printf("MoveObj: newtargetcontainerstr(%v) is empty while moving %v from %v to %v", oldcontainercontentsstr, newtargetcontainerstr, objstr, oldlocationstr, targetstr)
		return false
	}
	log.Printf("New container string %v", newcontainerstr)
	SetProp(oldlocationstr, "contents", newcontainerstr)

	//Add to target container

	log.Printf("xtainer string %v", newtargetcontainerstr)
	SetProp(targetstr, "contents", newtargetcontainerstr)

	//Set the object's new location
	SetProp(objstr, "location", targetstr)
	log.Printf("Audit: Moved %v from %v to %v\n", objstr, oldlocationstr, targetstr)
	return true
}

//from https://github.com/laurent22/massren/
func LexLine(editorCmd string) ([]string, error) {
	var args []string
	state := "start"
	current := ""
	quote := "\""
	for i := 0; i < len(editorCmd); i++ {
		c := editorCmd[i]

		if state == "quotes" {
			if string(c) != quote {
				current += string(c)
			} else {
				args = append(args, current)
				current = ""
				state = "start"
			}
			continue
		}

		if c == '"' || c == '\'' {
			state = "quotes"
			quote = string(c)
			continue
		}

		if state == "arg" {
			if c == ' ' || c == '\t' {
				args = append(args, current)
				current = ""
				state = "start"
			} else {
				current += string(c)
			}
			continue
		}

		if c != ' ' && c != '\t' {
			state = "arg"
			current += string(c)
		}
	}

	if state == "quotes" {
		return []string{}, errors.New(fmt.Sprintf("Unclosed quote in command line: %s", editorCmd))
	}

	if current != "" {
		args = append(args, current)
	}

	if len(args) <= 0 {
		return []string{}, errors.New("Empty command line")
	}

	if len(args) == 1 {
		return args, nil
	}

	return args, nil
}

//Setup default variables for a yaegi call
func BuildDefinitions(player, this, verb, dobj, dpropstr, prepositionStr, iobj, ipropstr, dobjstr, iobjstr string) string {
	definitions := ` 

	player := LoadObject("` + player + `")  //an object, the player who typed the command` + `
	playerid := "` + player + `"  //an object id, the player who typed the command` + `
	this := "` + this + `" //an object, the object on which this verb was found
	caller := LoadObject("` + player + `")  //an object, the same as player
	verb := "` + verb + `" //a string, the first word of the command
	//argstr //a string, everything after the first word of the command
	//args a list of strings, the words in argstr
	dobjstr := "` + dobjstr + `"` + ` //a string, the direct object string found during parsing
	dpropstr := "` + dpropstr + `"` + ` //a string, the direct object property string found during parsing
	dobj := LoadObject("` + dobj + `")  //an object, the direct object value found during matching
	prepstr:= "` + prepositionStr + `" //a string, the prepositional phrase found during parsing
	iobjstr := "` + iobjstr + `" //a string, the indirect object string
	ipropstr := "` + ipropstr + `" //a string, the indirect object string
	iobj := LoadObject("` + iobj + `")  //an object, the indirect object value

`
	return definitions
}

//Setup default variables for an Xsh call

func BuildXshCode(code, player, this, verb, dobj, dpropstr, prepositionStr, iobj, ipropstr, dobjstr, iobjstr string) string {
	definitions := ` 

	with { here		playerid        this           caller           verb            dobjstr       dobj     dpropstr           prepstr                  iobjstr    iobj       ipropstr           } = {"` + GetProp(player, "location") + `" "` + player + `" "` + this + `" "` + player + `" "` + verb + `" "` + dobjstr + `" "` + dobj + `"  "` + dpropstr + `" "` + prepositionStr + `" "` + iobjstr + `" "` + iobj + `" "` + ipropstr + `"} {
	` + code + `
	}
`
	return definitions
}

//Find a verb by searching visible objects
func VerbSearch(oid, aName string) (*Object, *Property) {
	o := LoadObject(oid)
	if o == nil {
		log.Printf("VerbSearch: oid %v is not a valid object", oid)
		return nil, nil
	}
	log.Println("Searching for verb", aName, "in", o.Id, "("+GetProp(o.Id, "name")+")")
	locId := GetPropertyStruct(o, "location", 10).Value
	loc := LoadObject(locId)
	roomContents := SplitStringList(GetPropertyStruct(loc, "contents", 10).Value)
	contents := append([]string{o.Id, locId}, roomContents...)
	contentsStruct := GetPropertyStruct(o, "contents", 10)
	if contentsStruct != nil {
		playerContents := SplitStringList(contentsStruct.Value)
		contents = append(contents, playerContents...)
	}
	for _, objId := range contents {
		if objId != "" {
			log.Println("Loading object from contents: '" + objId + "'")
			obj := LoadObject(objId)
			vobj := RecFindProp(obj, aName, 10)
			if vobj != nil {
				nameProp := GetVerbStruct(vobj, aName, 10)
				if nameProp != nil {
					return obj, nameProp
				}
			}
		}
	}

	log.Printf("Failed to find verb %v here!\n", aName)
	return nil, nil
}

//Find an object by name, by searching the currently visible objects
//and their parents

func GetObjectByName(player, name string) string {
	if player == "" {
		panic("GetObjectByName: player is empty.  All calls must be attributed to a player")
	}
	if name == "" {
		panic("GetObjectByName: lookup on empty name")
	}
	objects := VisibleObjects(LoadObject(player))
	log.Printf("Visible objects: %v\n", objects)
	for _, obj := range objects {
		if GetProp(obj, "name") == name {
			return obj
		}
	}
	return ""
}

//List all verbs from all objects visible to the player
func VerbList(player string) []string {
	o := LoadObject(player)
	out := []string{}
	locId := GetPropertyStruct(o, "location", 10).Value
	loc := LoadObject(locId)
	roomContents := SplitStringList(GetPropertyStruct(loc, "contents", 10).Value)
	playerContents := SplitStringList(GetPropertyStruct(o, "contents", 10).Value)
	contents := append([]string{o.Id, locId}, roomContents...)
	contents = append(contents, playerContents...)
	for _, objId := range contents {
		if objId == "" {
			log.Println("Invalid object id \"\"")
		} else {
			log.Println("Loading object from contents:", objId)
			obj := LoadObject(objId)
			for name, s := range obj.Properties {
				if s.Verb {
					out = append(out, name)
				}
			}
		}
	}

	return out
}

//Too similar to findobject?
func NameSearch(o *Object, aName, player string) (*Object, *Property) {

	locId := GetPropertyStruct(o, "location", 10).Value
	loc := LoadObject(locId)
	contents := SplitStringList(GetPropertyStruct(loc, "contents", 10).Value)
	playerObj := LoadObject(player)

	propStruct := GetPropertyStruct(playerObj, "contents", 10)

	if propStruct != nil {
		playerContents := SplitStringList(propStruct.Value)
		contents = append(contents, playerContents...)
	}
	contents = append([]string{o.Id, locId}, contents...)
	log.Println("Searching these objects:", contents)
	for _, objId := range contents {
		if objId != "" {
			log.Printf("Searching in %v", objId)
			obj := LoadObject(objId)
			nameProp := GetPropertyStruct(obj, "name", 10)
			if nameProp != nil {
				if nameProp.Value == aName {
					return obj, nameProp
				}
			}
		}
	}

	log.Printf("Failed to find object %v here!\n", aName)
	return nil, nil

}

func ParseDirectObject(s string, playerId string) (string, string) {
	s = strings.Trim(s, " \n\r")
	log.Printf("Parsing '%v', len: %v\n", string([]byte(s)), len(s))
	if playerId == "" {
		return "", ""
	}
	if s == "" {
		return "", ""
	}
	if len(s) == 0 {
		log.Println("WTF")
		return "", ""
	}
	if s == "me" {
		return playerId, ""
	}
	if s == "here" {
		return GetPropertyStruct(LoadObject(playerId), "location", 10).Value, ""
	}

	//It's a global object, look for it in the properties of %1
	if len(s) > 0 && s[0] == '$' {
		prop := s[1:]
		one := LoadObject("1")
		oneprop := GetPropertyStruct(one, prop, 10)
		if oneprop == nil {
			fmt.Printf("Could not find special property %v on 1\n", prop)
			return "", ""
		}
		objstr := oneprop.Value
		return objstr, ""
	}

	//It's an object id
	if len(s) > 0 && s[0] == '%' {
		s = s[1:]
		log.Println("Splitting", s, "on", ".")
		ss := strings.Split(s, ".")
		ss = append(ss, "")
		if ss[0] == "me" {
			return playerId, ss[1]
		}
		if ss[0] == "here" {
			return GetPropertyStruct(LoadObject(playerId), "location", 10).Value, ss[1]
		}
		return ss[0], ss[1]
	}

	//Note that only the object has to exist.  The property might not have been created yet
	//FIXME this is not a good way to handle it.  Users need error messages
	ss := strings.Split(s, ".")
	if ss[0] == "me" {
		return playerId, ss[1]
	}
	if ss[0] == "here" {
		return GetPropertyStruct(LoadObject(playerId), "location", 10).Value, ss[1]
	}
	//It might be the name of an object somewhere close
	log.Printf("Checking to see if the object of the sentence is a named object in the room or inventory.  Namesearch for '%v' in '%v'\n", ss[0], playerId)
	foundObj, _ := NameSearch(LoadObject(playerId), ss[0], playerId)
	if foundObj != nil {
		if len(ss) > 1 {
			return foundObj.Id, ss[1]
		} else {
			return foundObj.Id, ""
		}
	}
	log.Printf("No object found, assuming it is something else")

	return "", ""
}

//Find a string in a list of strings
func Find(a []string, x string) int {
	for i, n := range a {
		if x == n {
			return i
		}
	}
	return -1
}

//Find the index of the first preposition in the sentence

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

//Parse a sentence into a verb, direct object, indirect object, and preposition
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

//Set a verb property on an object
func SetThroffVerb(obj, name, code string) {
	log.Println("SetThroffVerb: ", obj, name, code)
	o := LoadObject(obj)
	if o == nil {
		log.Printf("SetThroffVerb: Could not load object '%v'", obj)
		return
	}
	v := Property{Value: code, Verb: true, Throff: true}
	log.Println("object:", o)
	o.Properties[name] = v
	SaveObject(o)
}

//Set a verb property on an object
func SetXshVerb(obj, name, code string) {
	log.Println("SetXshVerb: ", obj, name, code)
	o := LoadObject(obj)
	v := Property{Value: code, Verb: true, Throff: false, Interpreter: "xsh"}
	log.Println("object:", o)
	o.Properties[name] = v
	SaveObject(o)
}
