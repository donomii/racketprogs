package main

import (
	. "github.com/donomii/pmoo"
	"github.com/donomii/throfflib"
)

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
