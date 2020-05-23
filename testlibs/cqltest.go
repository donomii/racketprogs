package main

import (
    "fmt"
    "time"
   

    "github.com/gocql"
)

func main() {
    // connect to the cluster
    cluster := gocql.NewCluster( "xxx.xxx.xxx.xxx", "yyy.yyy.yyy.yyy")
    //cluster.Keyspace = "jtk"
    cluster.Timeout = 5 * time.Second
    //cluster.SocketKeepalive  = 6* time.Second
    //cluster.DiscoverHosts    = true
    //cluster.Compressor :=gocql.SnappyCompressor
    cluster.Consistency = gocql.Quorum
    
 

    
    //var id gocql.UUID


    
  m:= map[string]interface{}{}

   for i:=0;i<100;i++ {
     session, ok := cluster.CreateSession()
     if ok==nil {
		defer session.Close()
	    iter := session.Query(`select value from jtk.test`).Iter()
	    for iter.Scan(&m) {
		fmt.Println("row:", m["id"])
	  }
	  if err := iter.Close(); err != nil {
		fmt.Println(err)
	    }
     }
}}
