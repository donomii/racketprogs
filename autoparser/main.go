package main

import (
	"flag"
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
	fname := flag.String("f", "main.go", "File to parse")
	flag.Parse()
	f := loadFile(*fname)
	fl := strings.Split(f, "")
	l := []Node{}
	for _, v := range fl {
		l = append(l, Node{v, "", nil})
	}
	r, _, _ := groupify(l, false)
	r = keywordBreak(r, []string{"import", "type", "func", "\n"})
	//Need to split on spaces and merge beforedoing binops
	r = groupBinops(r)
	printTree(r)
}

func printTree(t []Node) {
	for _, v := range t {
		if v.List == nil {
			if v.Str == "" {
				fmt.Print(v.Raw)
			} else {
				fmt.Print("『", v.Str, "』")
			}

		} else {
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

func joinRaw(in []Node) string {
	o := ""
	for _, v := range in {
		o = o + v.Raw
	}
	return o
}
func match(s string, l []Node) bool {
	if len(s) == 0 {
		return true
	}
	if len(l) == 0 {
		return false
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
				accum = append(accum, vv)
				i = i + 1
			case "\"":
				return accum, in[i+1:], i

			default:
				accum = append(accum, v)
			}
		} else {
			switch v.Raw {
			case "\\":
				vv := in[i+1]
				accum = append(accum, vv)
				i = i + 1
			case "\"":
				var sublist []Node
				sublist, in, i = groupify(in[i+1:], true)
				i = -1
				fmt.Printf("Found string: %s\n", joinRaw(sublist))
				n := Node{Str: joinRaw(sublist)}
				fmt.Printf("Found node: %+v\n", n)
				accum = append(accum, n)

			case "[":
				fallthrough
			case "{":
				fallthrough
			case "(":
				var sublist []Node
				sublist, in, i = groupify(in[i+1:], false)
				i = -1
				accum = append(accum, Node{"", "", sublist})
			case "]":
				fallthrough
			case "}":
				fallthrough
			case ")":
				return append(output, accum...), in[i+1:], i

			default:
				accum = append(accum, v)

			}
		}

	}
	return append(output, accum...), []Node{}, -1
}

func keywordBreak(in []Node, keywords []string) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List == nil {
			for _, keyword := range keywords {
				if match(keyword, in[i:]) {
					//There are several different situations here
					// 1.Capture the accumulator (e.g. we are in a list)
					// 2.Capture the next next subtree (or more), join with the current node
					//   e.g. a type or function definition, or aprocedure call
					output = append(output, Node{"", "🛑", accum})
					//accum = []Node{}
					accum = []Node{{"", "🛑", nil}}
					continue
				}
			}
			accum = append(accum, v)
		} else {
			accum = append(accum, Node{"", "", keywordBreak(v.List, keywords)})
		}
	}
	return append(output, accum...)
}

func groupBinops(in []Node) []Node {
	accum := []Node{}

	for i := 0; i < len(in); i++ {
		v := in[i]

		if match(":=", in[i:]) {
			fmt.Printf("Found ==\n")
			first := in[0:i]
			second := in[i+1:] //FIXME need to skip length of match
			firstret := groupBinops(first)
			secondret := groupBinops(second)
			v.Raw = "define"
			return []Node{v,
				{List: firstret},
				{List: secondret},
			}

		}
		if v.List == nil {
			accum = append(accum, v)
		} else {
			accum = append(accum, Node{List: groupBinops(v.List)})
		}
	}

	return accum
}

func loadFile(path string) string {
	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
	return file
}
