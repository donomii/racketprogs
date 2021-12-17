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
	r, _, _ := treeify(l, false)
	printTree(r)
}

func printTree(t []Node) {
	for _, v := range t {
		switch v.List {

		case nil:
			if v.Str == "" {
				fmt.Print(v.Raw)
			} else {
				fmt.Print("\"|", v.Str, "|\"")
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

func treeify(in []Node, strMode bool) ([]Node, []Node, int) {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		//Move into accum
		if match("import", in[i:]) || match("type", in[i:]) || match("func", in[i:]) {
			output = append(output, Node{"", "🛑", accum})
			accum = []Node{}
			/*
				llist := o
				o = []Node{Node{"", "", llist}}
			*/
		}
		switch v.Raw {
		case "\\":
			vv := in[i+1]
			if strMode {

				accum = append(accum, Node{"", vv.Raw, nil})
			} else {
				accum = append(accum, Node{vv.Raw, "", nil})
			}
			i = i + 1
		case "\"":
			if strMode {
				return accum, in[i+1:], i
			} else {
				var sublist []Node
				sublist, in, i = treeify(in[i+1:], true)
				i = -1
				//i = i + len(sublist) + 1
				accum = append(accum, Node{"\"", joinStr(sublist), nil})
			}
		case "{":
			fallthrough
		case "(":
			var sublist []Node
			sublist, in, i = treeify(in[i+1:], false)

			i = -1
			accum = append(accum, Node{"", "", sublist})
		case "}":
			fallthrough
		case ")":
			return append(output, accum...), in[i+1:], i
		default:
			if strMode {

				accum = append(accum, Node{"", v.Raw, nil})
			} else {
				accum = append(accum, Node{v.Raw, "", nil})
			}
		}

	}
	return append(output, Node{"", "🛑", accum}), []Node{}, -1
}

func loadFile(path string) string {
	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
	return file
}
