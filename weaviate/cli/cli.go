package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"strings"

	"github.com/chzyer/readline"
)

var url = "http://localhost:8080/v1/"

type AskResponse struct {
	Data struct {
		Get struct {
			Page []struct {
				Content    string `json:"content"`
				Additional struct {
					Answer struct {
						Certainty     float64 `json:"certainty"`
						EndPosition   int     `json:"endPosition"`
						HasAnswer     bool    `json:"hasAnswer"`
						Property      string  `json:"property"`
						Result        string  `json:"result"`
						StartPosition int     `json:"startPosition"`
					} `json:"answer"`
				} `json:"_additional"`
			} `json:"Page"`
		} `json:"Get"`
	} `json:"data"`
}

type Resp struct {
	Data struct {
		Get struct {
			Page []Result
		}
	}
}

type Result struct {
	Content string "json:\"content\""
}

func query(q []string) []string {
	quotedArgs := make([]string, len(q))
	for i, arg := range q {
		quotedArgs[i] = fmt.Sprintf("\\\"%v\\\"", arg)
	}
	// Join the quoted args with spaces
	quotedArgsString := strings.Join(quotedArgs, ",")

	fmt.Printf("args: %v\n\n", quotedArgsString)

	query := fmt.Sprintf(`
	{"query":"{Get {Page (nearText: {concepts: [%v]}){content}}}","variables":{}}`, quotedArgsString)

	fmt.Printf("query: %v\n\n", query)

	url := "http://localhost:8080/v1/graphql"
	resp, err := http.Post(url, "application/json", bytes.NewBuffer([]byte(query)))
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	// Print the response
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	// fmt.Println(string(body))

	// Unmarshal the response
	var result Resp
	err = json.Unmarshal(body, &result)

	if err != nil {
		log.Fatal(err)
	}

	results := result.Data.Get.Page
	// Filter out any result containing a pdf, return the first 3

	out := []string{}

	for i, result := range results {
		if !strings.Contains(result.Content, "PDF") && i < 3 {
			out = append(out, result.Content)
		}
	}

	return out
}

func askQuestion(question string) []string {
	query := fmt.Sprintf(`{"query":"{Get {  Page(ask: {  question: \"%v\",  properties: [\"content\"],  rerank: false }, limit: 5  ) {content _additional {  answer {hasAnswer certainty property result startPosition endPosition  }}  }}  }","variables":{}}`, question)

	fmt.Printf("query: %v\n\n", query)

	url := "http://localhost:8080/v1/graphql"
	resp, err := http.Post(url, "application/json", bytes.NewBuffer([]byte(query)))
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	// Print the response
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	// fmt.Println(string(body))

	// Unmarshal the response
	var result AskResponse
	err = json.Unmarshal(body, &result)

	if err != nil {
		log.Fatal(err)
	}

	results := result.Data.Get.Page
	// Filter out any result containing a pdf, return the first 3

	out := []string{}

	for i, result := range results {
		res := result.Additional.Answer.Result
		cont := result.Content

		if !strings.Contains(cont, "PDF") && i < 3 {
			out = append(out, res)
		}
	}

	return out
}

func httpcall(method, url string, body []byte) (*http.Response, error) {
	// Make io reader from body
	bodyReader := bytes.NewReader(body)
	req, err := http.NewRequest(method, url, bodyReader)
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	client := http.DefaultClient
	return client.Do(req)
}

func doRESTCall(method, url string, body interface{}) []byte {
	// Serialise body
	json, err := json.Marshal(body)
	if err != nil {
		log.Fatal(err)
	}

	// Make REST call with user-supplied method

	resp, err := httpcall(method, url, json)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	// return response body
	rbody, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	return rbody
}

type Class struct {
	Class       string "json:\"class\""
	Description string "json:\"description\""
}

type Classes struct {
	Classes []Class "json:\"classes\""
}

func getClasses() []string {
	body := doRESTCall("GET", url+"schema", nil)
	classes := Classes{}
	err := json.Unmarshal(body, &classes)
	if err != nil {
		log.Fatal(err)
	}
	// Make string list of classes
	classes1 := []string{}
	for _, class := range classes.Classes {
		classes1 = append(classes1, class.Class)
	}
	return classes1
}

func completeClasses() func(string) []string {
	return func(line string) []string {
		classes := getClasses()
		fmt.Print(classes)
		return classes
	}
}

var completer = readline.NewPrefixCompleter(
	readline.PcItem("mode",
		readline.PcItem("vi"),
		readline.PcItem("emacs"),
	),
	readline.PcItem("url"),
	readline.PcItem("delete", readline.PcItemDynamic(completeClasses())),
	readline.PcItem("search"),
	readline.PcItem("ask"),
)

func main() {
	l, err := readline.NewEx(&readline.Config{
		Prompt:          "> ",
		HistoryFile:     "/tmp/readline.tmp",
		AutoComplete:    completer,
		InterruptPrompt: "^C",
		EOFPrompt:       "exit",
	})
	if err != nil {
		panic(err)
	}
	defer l.Close()

	for {
		line, err := l.Readline()
		if err != nil { // io.EOF
			break
		}
		fmt.Println("got", line)

		// Split line into words
		words := strings.Fields(line)

		// Check if the first word is a command
		switch words[0] {
		case "url":
			if len(words) == 2 {
				url = words[1]
			} else {
				fmt.Println(url)
			}
		case "delete":
			if len(words) == 2 {
				// Make REST call
				body := doRESTCall("DELETE", url+"schema/"+words[1], nil)
				fmt.Println(string(body))
			} else {
				fmt.Println("delete requires a single argument")
			}
		case "search":
			if len(words) > 1 {
				results := query(words[1:])
				if len(results) == 0 {
					fmt.Println("No results found")
				} else {
					// Print results
					for _, result := range results {
						fmt.Println(result)
					}
				}
			} else {
				fmt.Println("query requires at least one argument")
			}
		case "ask":
			if len(words) > 1 {
				results := askQuestion(strings.Join(words[1:], " "))
				// Print results
				for _, result := range results {
					fmt.Println(result)
				}
			} else {
				fmt.Println("ask requires at least one argument")
			}

		}
	}
}
