package okdb

import (
	"fmt"
	"log"

	"github.com/recoilme/okdb/api"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

var f = "db/1.db"
var conn *grpc.ClientConn
var client api.OkdbClient
var err error

func Connect(server string) {

	conn, err = grpc.Dial(server, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %s", err)
	}
	defer conn.Close()

	client = api.NewOkdbClient(conn)

	// SayOk
	response, err := client.SayOk(context.Background(), &api.Empty{})
	if err != nil {
		log.Fatalf("Error when calling SayHello: %s", err)
	}
	log.Printf("Response from server: %s", response.Message)
}

func Set(key string, val []byte) {
	// Set
	_, err = client.Set(context.Background(), &api.CmdSet{File: f, Key: []byte(key), Val: []byte(val)})
	if err != nil {
		log.Println(err)
	}

}

func Get(key string) []byte {
	// Get
	b, err := client.Get(context.Background(), &api.CmdGet{File: f, Key: []byte(key)})
	if err != nil {
		log.Println(err)
	}
	fmt.Println("b:", b.Bytes, "str:", string(b.Bytes))
	return b.Bytes
}

/*

	// Keys
	cmdKeys := &api.CmdKeys{File: f2, From: nil, Limit: 2, Offset: 0, Asc: false}
	keys, err := client.Keys(context.Background(), cmdKeys)
	if err != nil {
		log.Println(err)
	}
	fmt.Printf("keys:%+v\n", keys.Keys)
	for i, key := range keys.Keys {
		fmt.Println(i, binary.BigEndian.Uint32(key))
	}



	func Sets(key string, val []byte){
	//Sets
	var a [][]byte = [][]byte{val}
	for i := 0; i < 10; i++ {
		bs := make([]byte, 4)
		binary.BigEndian.PutUint32(bs, uint32(i))
		a = append(a, bs)
		a = append(a, bs)
	}
	_, err = client.Sets(context.Background(), &api.CmdSets{File: f2, Keys: a})
	if err != nil {
		log.Println(err)
	}
}
	// Gets
	resPairs, err := client.Gets(context.Background(), &api.CmdGets{File: f2, Keys: keys.Keys})
	if err != nil {
		log.Println(err)
	}
	for k, v := range resPairs.Pairs {
		if k%2 == 0 {
			//key
			fmt.Println("Key:", v)
		} else {
			//val
			fmt.Println("Val:", v)
		}
	}
}
*/
