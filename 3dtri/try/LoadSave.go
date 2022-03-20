// LoadSave.go
package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
)

//Holds all the data to import/export
type StateExport struct {
	Points  []float32 //Triangle data (or other shapes)
	Fitness int64     //Current difference in fit from the reference picture
	Views   []View
}

//Contains the input photo + control data for one "view" of the scene
//
//Will eventually hold camera angles and translation as well
type View struct {
	Pix       []byte    //The input photo
	Width     int       //Width, in pixels
	Height    int       //Height in pixels
	Angle     euler     //The euler angles to position the camera, looking towards the origin
	Translate []float32 //Translation vector, applied after rotation
}

func LoadState(filename string) ([]float32, int64) {
	jdata, _ := ioutil.ReadFile(filename)
	var out StateExport
	json.Unmarshal(jdata, &out)
	return out.Points, out.Fitness
}

type euler []float32

func SaveState(path string, renderPix, diffBuff []byte, currDiff int64, genome []float32, views []View) {
	s := StateExport{genome, currDiff, views}
	state_json, _ := json.Marshal(s)
	ioutil.WriteFile(fmt.Sprintf("%v/current.json", path), state_json, 0777)
	ioutil.WriteFile(fmt.Sprintf("%v/backup.json", path), state_json, 0777)

	//	status := fmt.Sprintf("#Number of times we have modified and tested the parameters (for this run)\nCycle: %v\n#How well the current state matches the target picture(0 is exact match)\nFitness: %v\nView angle1: %v", unique, currDiff, state.Views[0].Angle)
	//	ioutil.WriteFile(fmt.Sprintf("%v/statistics.txt", checkpointDir), []byte(status), 0777)

}
