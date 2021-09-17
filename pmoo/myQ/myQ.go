package myQ

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"
)

func Receiver(url string, callback func([]byte)) {
	for {
		resp, err := http.Get(url + "/subscribe/main")
		if err != nil {
			//log.Fatalln(err)
		} else {
			data, _ := ioutil.ReadAll(resp.Body)
			callback(data)
		}
	}
}

func Message(url string, mess interface{}) {
	json, _ := json.Marshal(mess)
	Send(url, json)
}

func Send(url string, data []byte) {
	http.Post(url+"/publish/main", "who/cares", bytes.NewReader(data))
}
