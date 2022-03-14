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

	ver := Property{Value: `SetVerb dobj dpropstr iobjstr`, Verb: true, Interpreter: "yaegi"}
	rootObj.Properties["verb.goscript"] = ver

	thr := Property{Value: `SetThroffVerb dobj dpropstr iobjstr`, Verb: true, Throff: true, Interpreter: "throff"}
	rootObj.Properties["verb.throff"] = thr

	xsh := Property{Value: `SetXshVerb dobj dpropstr iobjstr`, Verb: true, Throff: true, Interpreter: "throff"}
	rootObj.Properties["verb.xsh"] = xsh

	log.Println("Overwriting Player 1")
	playerobj := Object{}
	playerobj.Id = "2"
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
	playerobj.Properties["contents"] = Property{Value: ``}
	SaveObject(&playerobj)

	log.Println("Overwriting oops")
	oops := Object{}
	oops.Id = "0"
	oops.Properties = map[string]Property{}

	oops.Properties["player"] = Property{Value: `false`}
	oops.Properties["location"] = Property{Value: `0`}
	oops.Properties["parent"] = Property{Value: `1`}
	oops.Properties["owner"] = Property{Value: `1`}
	oops.Properties["programmer"] = Property{Value: `false`}
	oops.Properties["wizard"] = Property{Value: `false`}
	oops.Properties["read"] = Property{Value: `true`}
	oops.Properties["write"] = Property{Value: `false`}
	oops.Properties["contents"] = Property{Value: ``}
	SaveObject(&oops)

	log.Println("Overwriting First room")
	room := Object{}
	room.Id = "3"
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
	room.Properties["contents"] = Property{Value: ``}
	SaveObject(&room)

	log.Println("Overwriting genroom")
	genroom := Object{}
	genroom.Id = "4"
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
	genroom.Properties["contents"] = Property{Value: ``}
	SaveObject(&genroom)

	log.Println("Overwriting generic player")
	genplayer := Object{}
	genplayer.Id = "5"
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
	genplayer.Properties["contents"] = Property{Value: ``}
	SaveObject(&genplayer)

	log.Println("Overwriting generic thing")
	genthing := Object{}
	genthing.Id = "6"
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
	genthing.Properties["contents"] = Property{Value: ``}
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
