// Copyright 2011 marpie. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// This demo program shows a basic example of the MJPEG library.
package main

import (
	"fmt"
	"image"
	"image/jpeg"
	"io"
	"net"
	"os"
)

const URL = "http://user:user@localhost:5050/mjpg/video.mjpg"

// processHttp receives the HTTP data and tries to decodes images. The images
// are sent through a chan for further processing.
func processChan(r io.Reader, nextImg chan *image.Image, quit chan bool) {
	for {
		select {
		case <-quit:
			close(nextImg)
			return
		default:
			img, err := jpeg.Decode(r)
			if err == io.EOF {
				close(nextImg)
				return
			}
			if err != nil {
				//fmt.Println(err)
			}
			if img != nil {
				fmt.Println("Got image!")
				nextImg <- &img
			}
		}
	}
}

// processImage receives images through a chan and prints the dimensions.
func processImage(nextImg chan *image.Image, quit chan bool) {
	for i := 0; i < 10; i++ {
		i, ok := <-nextImg
		if !ok {
			break
		}
		img := *i
		if *i == nil {
			continue
		}
		fmt.Println("New Image:", img.Bounds())
	}
	quit <- true
}

func main() {
	servAddr := "192.168.178.39:1001"
	tcpAddr, err := net.ResolveTCPAddr("tcp", servAddr)
	if err != nil {
		println("ResolveTCPAddr failed:", err.Error())
		os.Exit(1)
	}

	conn, err := net.DialTCP("tcp", nil, tcpAddr)
	if err != nil {
		println("Dial failed:", err.Error())
		os.Exit(1)
	}

	nextImg := make(chan *image.Image, 30)
	quit := make(chan bool)
	fmt.Println("Waiting for images to process...")
	go processImage(nextImg, quit)
	processChan(conn, nextImg, quit)
}
