package main

import (
	//"fmt"
	"fmt"
	. "fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"path/filepath"
	"strings"

	"github.com/armon/go-radix"
	"github.com/tchap/go-patricia/patricia"
)

var (
	trie *patricia.Trie
	max  = 10
	tr   *radix.Tree
)

func Min(a, b int) int {
	if a > b {
		return b
	}
	return a
}

func main() {
	trie = patricia.NewTrie()
	tr = radix.New()
	filepath.Walk(os.Args[2], func(path string, info os.FileInfo, err error) error {
		Println("Ingesting", path)
		if err != nil {
			fmt.Printf("prevent panic by handling failure accessing a path %q: %v\n", path, err)
			return nil
		}
		if info.IsDir() {
			return nil
		}
		if filepath.Ext(path) == os.Args[1] {
			ingest(path)
		}
		return nil
	})

	printItem := func(prefix patricia.Prefix, item patricia.Item) error {
		count := interface{}(item).(int)
		if count > max {
			max = count
		}
		if count > 5 {
			fmt.Printf("%v: %q\n", item, prefix)
		}
		return nil
	}

	trie.Visit(printItem)

	pi := func(s string, v interface{}) bool {
		count := v.(int)
		if count > max {
			max = count
		}
		if count > 5 {
			fmt.Printf("%v: %q\n", v.(int), s)
		}
		return false
	}
	tr.Walk(pi)

}

func ingest(path string) {
	// Create a new default trie (using the default parameter values).
	Println("Ingesting", path)
	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
	file = strings.ReplaceAll(file, "\n\n", "\n")
	file = strings.ReplaceAll(file, "\n", " NEWLINE ")
	file = strings.ReplaceAll(file, "\t", " ")
	file = strings.ReplaceAll(file, "\r", " ")

	file = strings.ReplaceAll(file, "  ", " ")
	file = strings.ReplaceAll(file, "  ", " ")
	file = strings.ReplaceAll(file, "  ", " ")
	keys := strings.Split(file, " ")
	//Println(keys)

	l := Min(len(keys), 100)
	for i := 1; i < l-1; i = i + 1 {
		//m := Min(l, i+10)
		//for j := i; j < m; j = j + 1 {
		in := strings.Join(keys[:i], " ") + " *** " + keys[i+1] //+ strings.Join(keys[j:], " ")
		//Println("* Importing", i, j, in)
		valitem := trie.Get(patricia.Prefix(in))
		val := 0
		if valitem == nil {
			val = 0
		} else {
			val = interface{}(valitem).(int)
		}
		//trie.Set(patricia.Prefix(in), val+1)

		vi, found := tr.Get(in)
		if !found {
			val = 0
		} else {
			val = vi.(int)
		}
		tr.Insert(in, val+1)

		//}
	}

	printItem := func(prefix patricia.Prefix, item patricia.Item) error {
		count := interface{}(item).(int)
		if count > max {
			max = count
		}
		if count > max/10 {
			fmt.Printf("%v: %q\n", item, prefix)
		}
		return nil
	}

	pi := func(s string, v interface{}) bool {
		count := v.(int)
		if count > max {
			max = count
		}
		if count > max/10 {
			fmt.Printf("%v: %q\n", v.(int), s)
		}
		return false
	}
	if rand.Float64() < 0.01 {
		trie.Visit(printItem)
		tr.Walk(pi)
	}

}
