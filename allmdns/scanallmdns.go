package main

import (
	"log"
	"time"

	"github.com/donomii/goof"
)

func main() {
	go func() {
		time.Sleep(10 * time.Second)
		goof.AdvertiseMDNS(80, "test._workstation._tcp", "local", "test server", []string{"lalala"}, 120, false)
	}()
	c := goof.StartMDNSscan("_services._dns-sd._udp", "local", -1)
	goof.ScanMDNS(c, "_workstation._tcp", "local", -1)
	goof.ScanMDNS(c, "_udisks-ssh._tcp", "local", -1)
	goof.ScanMDNS(c, "_ssh._tcp", "local", -1)
	goof.ScanMDNS(c, "_tcp", "local", -1)
	goof.ScanMDNS(c, "_udp", "local", -1)
	for x := range c {
		log.Println(x)
	}
}
