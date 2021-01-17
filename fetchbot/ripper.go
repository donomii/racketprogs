package main

import (
	"bytes"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"golang.org/x/net/html"

	"github.com/PuerkitoBio/fetchbot"
)

func dispatchURLs(urlCh chan string) {
	f := fetchbot.New(fetchbot.HandlerFunc(handler))
	f.DisablePoliteness = true
	queue := f.Start()
	seenURL := map[string]bool{}
	for _url := range urlCh {

		if !seenURL[_url] {
			seenURL[_url] = true
			queue.SendStringGet(_url)
		}
	}
	queue.Close()
}

var urlCh chan string

func main() {

	//flag.StringVar(&gopherType, "gopher_type", defaultGopher, usage)
	//flag.StringVar(&gopherType, "g", defaultGopher, usage+" (shorthand)")
	flag.Parse()
	start := flag.Args()[0]
	urlCh = make(chan string)
	go dispatchURLs(urlCh)
	urlCh <- start
	//urlCh <- "http://www.praeceptamachinae.com/"
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
	fmt.Printf("[%d] %s %s\n", res.StatusCode, ctx.Cmd.Method(), ctx.Cmd.URL())
	url := ctx.Cmd.URL()
	upath := ctx.Cmd.URL().Path

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
	fmt.Printf("%v\n", path)
	dir := filepath.Dir(path)
	os.MkdirAll(dir, 0600)
	var (
		anchorTag = []byte{'a'}
		hrefTag   = []byte("href")
		httpTag   = []byte("http")
		imgTag    = []byte("img")
	)

	bodyR := bytes.NewReader(body)
	//defer bodyR.Close()

	buf, err := ioutil.ReadAll(bodyR)
	if err != nil {
		log.Fatal(err)
	}
	ioutil.WriteFile(path, buf, 0600)
	bodyR = bytes.NewReader(buf)
	tkzer := html.NewTokenizer(bodyR)

	for {
		switch tkzer.Next() {
			log.Println(tkzer.TagName())
		case html.ErrorToken:
			// HANDLE ERROR
			return

		case html.StartTagToken:
			tag, hasAttr := tkzer.TagName()
			if hasAttr && bytes.Equal(imgTag, tag) {
				key, val, _ := tkzer.TagAttr()
				fmt.Printf("%s, %s\n", key, val)
			}
			if hasAttr && bytes.Equal(anchorTag, tag) { // a
				// HANDLE ANCHOR
				key, val, _ := tkzer.TagAttr()

				if bytes.Equal(hrefTag, key) { // href, http(s)
					// HREF TAG
					//fmt.Printf("%s, %s\n", key, val)
					if bytes.HasPrefix(val, httpTag) {
						//Filter here?
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
