package main

import (
	"bytes"
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
	urlCh = make(chan string)
	go dispatchURLs(urlCh)
	//urlCh <- "https://www.reddit.com/"
	urlCh <- "http://www.praeceptamachinae.com/"
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
	//url := ctx.Cmd.URL().String()
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
	path = "rip/" + path
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
						if strings.Contains(string(val), "reddit") {
							urlCh <- fmt.Sprintf("%s", val)
						}
					} else {
						urlCh <- fmt.Sprintf("%s/%s", ctx.Cmd.URL(), val)
					}
				}

			}
		}
	}

}
