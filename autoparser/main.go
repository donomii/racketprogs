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
	r, _, _ := groupify(l, false)
	//Need to split on spaces and merge beforedoing binops
	//s := groupBinops(Node{"", "", r})
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
	//fmt.Println("Comparing ", s[0:1], "with", l[0].Raw)
	if s[0:1] == l[0].Raw {
		return match(s[1:], l[1:])
	}
	return false
}

func groupify(in []Node, strMode bool) ([]Node, []Node, int) {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if strMode {
			switch v.Raw {
			case "\\":
				vv := in[i+1]
				accum = append(accum, Node{"", vv.Raw, nil})
				i = i + 1
			case "\"":
				return accum, in[i+1:], i
			default:

				accum = append(accum, Node{"", v.Raw, nil})
			}
		} else {
			switch v.Raw {
			case "\\":
				vv := in[i+1]

				accum = append(accum, Node{vv.Raw, "", nil})

				i = i + 1
			case "\"":

				var sublist []Node
				sublist, in, i = groupify(in[i+1:], true)
				i = -1
				//i = i + len(sublist) + 1
				accum = append(accum, Node{"\"", joinStr(sublist), nil})

			case "{":
				fallthrough
			case "(":
				var sublist []Node
				sublist, in, i = groupify(in[i+1:], false)

				i = -1
				accum = append(accum, Node{"", "", sublist})
			case "}":
				fallthrough
			case ")":
				return append(output, accum...), in[i+1:], i
			default:

				if match("import", in[i:]) || match("type", in[i:]) || match("func", in[i:]) {
					//There are several different situations here
					// 1.Capture the accumulator (e.g. we are in a list)
					// 2.Capture the next next subtree (or more), join with the current node
					//   e.g. a type or function definition, or aprocedure call
					output = append(output, Node{"", "🛑", accum})
					accum = []Node{}
				}
				accum = append(accum, Node{v.Raw, "", nil})

			}
		}

	}
	return append(output, Node{"", "🛑", accum}), []Node{}, -1
}

func groupBinops(in Node) Node {
	accum := []Node{}
	if in.List == nil {

		return in
	} else {
		for i := 0; i < len(in.List); i++ {
			v := in.List[i]

			if match("==", in.List[i:]) {
				fmt.Printf("Found ==\n")
				first := in.List[i-1]
				second := in.List[i+1]
				firstret := groupBinops(first)
				secondret := groupBinops(second)
				return Node{"", "", []Node{v,
					firstret,
					secondret}}
			}
			accum = append(accum, groupBinops(v))
		}
	}

	return Node{"", "", accum}
}

func loadFile(path string) string {
	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
	return file
}
