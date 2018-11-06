//Run as ./imap server:port username password
//
//e.g.  ./imap imap.gmail.com:993 xxxx@gmail.com password

package main

import (
    "encoding/json"
    "os"
    "fmt"
    "time"
  "gopkg.in/mvader/go-imapreader.v1"
  "net/mail"
)

type Email struct {
    // Array of flags the message has
    Flags []string
    // Contains all the message headers
    Header mail.Header
    // Contains the message body
    Body []byte
    BodyString string
}


func main() {
  r, err := imapreader.NewReader(imapreader.Options{
      Addr:     os.Args[1],
		Username: os.Args[2],
		Password: os.Args[3],
		TLS:      true,
		Timeout:  60 * time.Second,
		MarkSeen: false,
	})
	if err != nil {
	  panic(err)
	}

	if err := r.Login(); err != nil {
	  panic(err)
	}
	defer r.Logout()

	// Search for all the emails in "all mail" that are unseen
	// read the docs for more search filters
	messages, err := r.List(imapreader.GMailAllMail, imapreader.SearchAll)
	if err != nil {
	  panic(err)
	}

    outMessages := []Email{}
    for _, v := range messages {
        e := Email{}
        e.Flags = v.Flags
        e.Header = v.Header
        e.Body = v.Body
        e.BodyString = string(v.Body)
        outMessages = append(outMessages, e)
    }
        j, _ := json.Marshal(outMessages)
        fmt.Println(string(j))

	// do stuff with messages
}
