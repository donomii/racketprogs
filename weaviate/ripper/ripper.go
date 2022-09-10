package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"path/filepath"
	"strings"
	"time"

	"github.com/k3a/html2text"
	"golang.org/x/net/html"

	"github.com/PuerkitoBio/fetchbot"
)

var matchUrl = ""

func dispatchURLs(urlCh chan string) {
	f := fetchbot.New(fetchbot.HandlerFunc(handler))
	f.DisablePoliteness = true
	queue := f.Start()
	seenURL := map[string]bool{}
	for _url := range urlCh {
		if !seenURL[_url] {
			seenURL[_url] = true
			if matchUrl != "" && !strings.Contains(_url, matchUrl) {
			} else {
				queue.SendStringGet(_url)
			}
		}
	}
	queue.Close()
}

var urlCh chan string

type Objects struct {
	Objects []Object
}

type Object struct {
	Class      string                 "json:\"class\""
	Properties map[string]interface{} "json:\"properties\""
}

func insertPage(title, content string) {
	objects := Objects{
		Objects: []Object{
			{
				Class: "Page",
				Properties: map[string]interface{}{
					"title":   title,
					"content": content,
				},
			},
		},
	}

	url := "http://localhost:8080/v1/batch/objects"
	json, err := json.Marshal(objects)
	if err != nil {
		log.Fatal(err)
	}
	// Upload the objects using a HTTP POST request
	resp, err := http.Post(url, "application/json", bytes.NewBuffer(json))
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	/*
		// Read the response
		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			log.Fatal(err)
		}
	*/
	// fmt.Println(string(body))
}

func main() {
	// flag.StringVar(&gopherType, "gopher_type", defaultGopher, usage)
	flag.StringVar(&matchUrl, "match-url", matchUrl, "URL to match")
	flag.Parse()
	start := flag.Args()[0]
	urlCh = make(chan string)
	go dispatchURLs(urlCh)
	urlCh <- start
	for {
		time.Sleep(1 * time.Second)
	}
}

func handler(ctx *fetchbot.Context, res *http.Response, err error) {
	if err != nil {
		fmt.Printf("error: %s\n", err)
		return
	}
	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	fmt.Printf("fetched: [%v] %v\n", string(res.StatusCode), string(ctx.Cmd.URL().String()))
	url := ctx.Cmd.URL()
	upath := ctx.Cmd.URL().Path

	if matchUrl != "" && !strings.Contains(url.String(), matchUrl) {
		return
	}
	if upath == "" {
		upath = upath + "/index.html"
	}
	if upath == "." {
		upath = upath + "index.html"
	}
	if strings.HasSuffix(upath, "/") {
		upath = upath + "index.html"
	}
	path := filepath.Clean(upath)
	path = "rip/" + url.Hostname() + "/" + path
	fmt.Printf("path: %v\n", path)
	// dir := filepath.Dir(path)
	// os.MkdirAll(dir, 0755)
	var (
		anchorTag = []byte{'a'}
		hrefTag   = []byte("href")
		httpTag   = []byte("http")
		imgTag    = []byte("img")
	)

	bodyR := bytes.NewReader(body)
	// defer bodyR.Close()

	buf, err := ioutil.ReadAll(bodyR)
	if err != nil {
		log.Fatal(err)
	}
	// ioutil.WriteFile(path, buf, 0644)
	plain := html2text.HTML2Text(string(buf))
	insertPage(url.String(), plain)
	// fmt.Println("Inserted:", plain)

	bodyR = bytes.NewReader(buf)
	tkzer := html.NewTokenizer(bodyR)

	for {
		// log.Println(tkzer.TagName())
		switch tkzer.Next() {
		case html.ErrorToken:
			// HANDLE ERROR
			return

		case html.StartTagToken:
			tag, hasAttr := tkzer.TagName()
			if hasAttr && bytes.Equal(imgTag, tag) {
				// key, val, _ := tkzer.TagAttr()
				// fmt.Printf("%s, %s\n", key, val)
			}
			if hasAttr && bytes.Equal(anchorTag, tag) { // a
				// HANDLE ANCHOR
				key, val, _ := tkzer.TagAttr()

				if bytes.Equal(hrefTag, key) { // href, http(s)
					// HREF TAG
					// fmt.Printf("%s, %s\n", key, val)
					if bytes.HasPrefix(val, httpTag) {
						// Filter here?
						urlCh <- fmt.Sprintf("%s", val)
					} else {
						fuck, err := url.Parse(string(val))
						if err == nil {
							urlCh <- ctx.Cmd.URL().ResolveReference(fuck).String()
						} else {
							fmt.Printf("Cannot parse: %s\n", err)
						}
					}
				}

			}
		}
	}
}
