package main

import (
	"log"

	. "../pmoolib"
)

//Writes the core objects to disk. Overwrites any that already exist.
func initDB() {
	log.Println("Overwriting core")
	rootObj := Object{}
	rootObj.Id = "1"
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
	rootObj.Properties["contents"] = Property{Value: ``}
	rootObj.Properties["room"] = Property{Value: `4`}
	rootObj.Properties["player"] = Property{Value: `5`}
	rootObj.Properties["thing"] = Property{Value: `6`}
	rootObj.Properties["lastId"] = Property{Value: `101`}

	prop := Property{Value: ` SetProp dobj dpropstr iobjstr `, Verb: true, Throff: true, Interpreter: "throff"}
	rootObj.Properties["property"] = prop

	ver := Property{Value: `SetVerb dobj dpropstr iobjstr yaegi`, Verb: true, Interpreter: "throff"}
	rootObj.Properties["verb.goscript"] = ver

	thr := Property{Value: `SetThroffVerb dobj dpropstr iobjstr`, Verb: true, Throff: true, Interpreter: "throff"}
	rootObj.Properties["verb.throff"] = thr

	xsh := Property{Value: `SetXshVerb dobj dpropstr iobjstr`, Verb: true, Throff: true, Interpreter: "throff"}
	rootObj.Properties["verb.xsh"] = xsh

	log.Println("Overwriting Player 1")
	playerobj := Object{}
	playerobj.Id = "2"
	playerobj.Properties = map[string]Property{}

	playerobj.Properties["name"] = Property{Value: "urplayer"}
	playerobj.Properties["description"] = Property{Value: "An amorphous blur that looks, from some angles, like a player"}
	playerobj.Properties["location"] = Property{Value: `3`}
	playerobj.Properties["parent"] = Property{Value: `5`}
	SaveObject(&playerobj)

	log.Println("Overwriting oops")
	oops := Object{}
	oops.Id = "0"

	oops.Properties = map[string]Property{}
	oops.Properties["description"] = Property{Value: "The system garbage bin, and default error object.  If you are reading this, there was probably an error."}
	oops.Properties["location"] = Property{Value: `0`}
	SaveObject(&oops)

	log.Println("Overwriting First room")
	room := Object{}
	room.Id = "3"
	room.Properties = map[string]Property{}

	room.Properties["name"] = Property{Value: `The First Room`}
	room.Properties["description"] = Property{Value: `The default entrance.`}
	room.Properties["location"] = Property{Value: `0`}
	room.Properties["parent"] = Property{Value: `4`}
	room.Properties["owner"] = Property{Value: `1`}
	room.Properties["programmer"] = Property{Value: `false`}
	room.Properties["wizard"] = Property{Value: `false`}
	room.Properties["read"] = Property{Value: `true`}
	room.Properties["write"] = Property{Value: `false`}
	room.Properties["contents"] = Property{Value: ``}
	SaveObject(&room)

	log.Println("Overwriting genroom")
	genroom := Object{}
	genroom.Id = "4"
	genroom.Properties = map[string]Property{}

	genroom.Properties["name"] = Property{Value: `Generic Room`}
	genroom.Properties["description"] = Property{Value: `You see nothing special.`}
	genroom.Properties["location"] = Property{Value: `4`}
	genroom.Properties["parent"] = Property{Value: `1`}
	SaveObject(&genroom)

	log.Println("Overwriting generic player")
	genplayer := Object{}
	genplayer.Id = "5"
	genplayer.Properties = map[string]Property{}

	genplayer.Properties["name"] = Property{Value: "Generic player"}
	genplayer.Properties["description"] = Property{Value: "A wavering, indistinct figure"}
	genplayer.Properties["location"] = Property{Value: `5`}
	genplayer.Properties["parent"] = Property{Value: `1`}
	SaveObject(&genplayer)

	log.Println("Overwriting generic thing")
	genthing := Object{}
	genthing.Id = "6"
	genthing.Properties = map[string]Property{}

	genthing.Properties["name"] = Property{Value: "Generic thing"}
	genthing.Properties["description"] = Property{Value: "small, grey and uninteresting"}
	genthing.Properties["location"] = Property{Value: `6`}
	genthing.Properties["parent"] = Property{Value: `1`}
	SaveObject(&genthing)

	log.Println("Overwriting core object")
	coreObj := Object{}
	coreObj.Id = "7"
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
	coreObj.Properties["contents"] = Property{Value: ``}
	SaveObject(&coreObj)
	SaveObject(&rootObj)

	log.Println("Initialised core objects")
}
