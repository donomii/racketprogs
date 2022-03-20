package atto
	import (
		"reflect"
		ns1 "github.com/donomii/glim"

	)
	func Build() map[string]map[string]map[string]reflect.Value {

	var p = map[string]map[string]map[string]reflect.Value{}

	p["glim"]=map[string]map[string]reflect.Value{}
		p["glim"]["func"]=map[string]reflect.Value{}
			p["glim"]["func"]["RenderPara"]=reflect.ValueOf(ns1.RenderPara)
				p["glim"]["func"]["RenderTokenPara"]=reflect.ValueOf(ns1.RenderTokenPara)
				p["glim"]["func"]["MaxI"]=reflect.ValueOf(ns1.MaxI)
				p["glim"]["func"]["PasteImg"]=reflect.ValueOf(ns1.PasteImg)
				p["glim"]["func"]["PasteText"]=reflect.ValueOf(ns1.PasteText)
				p["glim"]["func"]["RGBAtoColor"]=reflect.ValueOf(ns1.RGBAtoColor)
				p["glim"]["func"]["SaveImage"]=reflect.ValueOf(ns1.SaveImage)
				p["glim"]["func"]["DrawGlyphRGBA"]=reflect.ValueOf(ns1.DrawGlyphRGBA)
				p["glim"]["func"]["Fixed2int"]=reflect.ValueOf(ns1.Fixed2int)
				p["glim"]["func"]["InBounds"]=reflect.ValueOf(ns1.InBounds)
				p["glim"]["func"]["ToChar"]=reflect.ValueOf(ns1.ToChar)
				p["glim"]["func"]["CopyFormatter"]=reflect.ValueOf(ns1.CopyFormatter)
				p["glim"]["func"]["DrawStringRGBA"]=reflect.ValueOf(ns1.DrawStringRGBA)
				p["glim"]["func"]["FlipUp"]=reflect.ValueOf(ns1.FlipUp)
				p["glim"]["func"]["Rotate270"]=reflect.ValueOf(ns1.Rotate270)
				p["glim"]["func"]["SaveBuff"]=reflect.ValueOf(ns1.SaveBuff)
				p["glim"]["func"]["DrawCursor"]=reflect.ValueOf(ns1.DrawCursor)
				p["glim"]["func"]["MakeTransparent"]=reflect.ValueOf(ns1.MakeTransparent)
				p["glim"]["func"]["NewFormatter"]=reflect.ValueOf(ns1.NewFormatter)
				p["glim"]["func"]["GFormatToImage"]=reflect.ValueOf(ns1.GFormatToImage)
				p["glim"]["func"]["ImageToGFormat"]=reflect.ValueOf(ns1.ImageToGFormat)
				p["glim"]["func"]["Invert"]=reflect.ValueOf(ns1.Invert)
				p["glim"]["func"]["MoveInBounds"]=reflect.ValueOf(ns1.MoveInBounds)
				p["glim"]["func"]["RandPic"]=reflect.ValueOf(ns1.RandPic)
				p["glim"]["func"]["Abs8"]=reflect.ValueOf(ns1.Abs8)
				p["glim"]["func"]["ClearAllCaches"]=reflect.ValueOf(ns1.ClearAllCaches)
				p["glim"]["func"]["GDiff"]=reflect.ValueOf(ns1.GDiff)
				p["glim"]["func"]["PaintTexture"]=reflect.ValueOf(ns1.PaintTexture)
				p["glim"]["func"]["Abs32"]=reflect.ValueOf(ns1.Abs32)
				p["glim"]["func"]["CalcDiffSq"]=reflect.ValueOf(ns1.CalcDiffSq)
				p["glim"]["func"]["LoadImage"]=reflect.ValueOf(ns1.LoadImage)
				p["glim"]["func"]["GetGlyphSize"]=reflect.ValueOf(ns1.GetGlyphSize)
				p["glim"]["func"]["ImageToGFormatRGBA"]=reflect.ValueOf(ns1.ImageToGFormatRGBA)
				p["glim"]["func"]["Uint8ToBytes"]=reflect.ValueOf(ns1.Uint8ToBytes)
				p["glim"]["func"]["Abs64"]=reflect.ValueOf(ns1.Abs64)
				p["glim"]["func"]["AbsInt"]=reflect.ValueOf(ns1.AbsInt)
				p["glim"]["func"]["DumpBuff"]=reflect.ValueOf(ns1.DumpBuff)
				p["glim"]["func"]["Rotate90"]=reflect.ValueOf(ns1.Rotate90)
				p["glim"]["func"]["SanityCheck"]=reflect.ValueOf(ns1.SanityCheck)
				p["glim"]["func"]["CalcDiff"]=reflect.ValueOf(ns1.CalcDiff)
				p["glim"]["func"]["NextPo2"]=reflect.ValueOf(ns1.NextPo2)
				p["glim"]["func"]["PasteBytes"]=reflect.ValueOf(ns1.PasteBytes)
				return p
	}
