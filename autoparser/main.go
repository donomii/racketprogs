package main

import (
	"fmt"
	"io/ioutil"
	"strings"
)

type Node struct {
	Raw  string
	Str  string
	List []Node
}

func main() {
	f := loadFile("main.go")
	fl := strings.Split(f, "")
	l := []Node{}
	for _, v := range fl {
		l = append(l, Node{v, "", nil})
	}
	r, _ := treeify(l, false)
	printTree(r)
}

func printTree(t []Node) {
	for _, v := range t {
		switch v.List {

		case nil:
			if v.Str == "" {
				fmt.Print(v.Raw)
			} else {
				fmt.Print("\"", v.Str, "\"")
			}
		default:

			fmt.Print("「")
			printTree(v.List)
			fmt.Print("」")
		}
	}
}

func joinStr(in []Node) string {
	o := ""
	for _, v := range in {
		o = o + v.Str
	}
	return o
}
func match(s string, l []Node) bool {
	if len(l) == 0 || len(s) == 0 {
		return true
	}
	fmt.Println("Comparing ", s[0:1], "with", l[0].Raw)
	if s[0:1] == l[0].Raw {
		return match(s[1:], l[1:])
	}
	return false
}

func treeify(in []Node, str bool) ([]Node, []Node) {
	o := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if match("import", in[i:]) || match("type", in[i:]) || match("func", in[i:]) {
			o = append(o, Node{"", "🛑", nil})
			/*
				llist := o
				o = []Node{Node{"", "", llist}}
			*/
		}
		switch v.Raw {
		case "\"":
			if str {
				return o, in[i+1:]
			} else {
				sublist, _ := treeify(in[i+1:], true)
				i = i + len(sublist)
				o = append(o, Node{"", joinStr(sublist), nil})
			}
		case "{":
			fallthrough
		case "(":
			sublist, rest := treeify(in[i+1:], false)
			in = rest
			i = -1
			o = append(o, Node{"", "", sublist})
		case "}":
			fallthrough
		case ")":
			return o, in[i+1:]
		default:
			if str {

				o = append(o, Node{"", v.Raw, nil})
			} else {
				o = append(o, Node{v.Raw, "", nil})
			}
		}

	}
	return o, []Node{}
}

func loadFile(path string) string {
	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
	return file
}
