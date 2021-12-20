package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"strings"
	"unicode"
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
	//fmt.Println("Parsing file:", f)
	fl := strings.Split(f, "")
	l := []Node{}
	for _, v := range fl {
		l = append(l, Node{v, "", nil})
	}
	r, _ := stringify(l, "//", "\n", "\\", "")
	printTree(r, 0, false)
	r, _, _ = groupify(r, "")
	r = keywordBreak(r, []string{"import", "type", "func", "\n"})
	r = mergeNonWhiteSpace(r)
	r = stripNL(r)
	r = stripWhiteSpace(r)
	//Need to split on spaces and merge before doing binops
	r = groupBinops(r)
	printTree(r, 0, false)
	//fmt.Printf("%+v\n", r)
}

func printIndent(i int, c string) {
	for j := 0; j < i; j++ {
		fmt.Print(c)
	}
}

func containsLists(l []Node, max int) bool {
	count := 0
	for _, v := range l {
		if v.List != nil {
			count = count + 1
		}
	}
	return count > max
}

//Count the number of elements in a tree
func countTree(t []Node) int {
	count := 0
	for _, v := range t {
		if v.List != nil {
			count = count + countTree(v.List)
		} else {
			count = count + 1
		}
	}
	return count
}

//)))
func printTree(t []Node, indent int, newlines bool) {
	for _, v := range t {
		if v.List == nil {
			if v.Str == "" {
				//fmt.Print(".")
				fmt.Print(v.Raw, " ")

			} else {

				fmt.Print("『", v.Str, "』")
			}

		} else {
			if containsLists(v.List, 3) {
				if countTree(v.List) > 50 {

					fmt.Print("\n")
					printIndent(indent+1, "_")
				}
				fmt.Print("(")
				printTree(v.List, indent+2, true)
				print("\n")
				printIndent(indent, "_")
				fmt.Print(")\n")
			} else {
				fmt.Print("(")
				printTree(v.List, indent+2, false)
				fmt.Print(")")

			}
		}
		if newlines {
			fmt.Print("\n")
			printIndent(indent, "_")
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
func stringify(in []Node, start, end, escape, strMode string) ([]Node, []Node) {
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List != nil {
			var ret []Node
			ret, in = stringify(v.List, start, end, escape, strMode)
			i = -1
			accum = append(accum, Node{List: ret})
		} else {
			if strMode != "" {
				switch {
				case match(escape, in[i:]):
					vv := in[i+len(escape)]
					accum = append(accum, vv)
					i = i + len(escape)
				case match(end, in[i:]):
					return accum, in[i+len(end):]

				default:
					accum = append(accum, v)
				}
			} else {
				switch {
				case match(start, in[i:]):
					var sublist []Node
					sublist, in = stringify(in[i+len(start):], start, end, escape, end)
					i = -1
					//fmt.Printf("Found string: %s\n", joinRaw(sublist))
					n := Node{Str: joinRaw(sublist)}
					//fmt.Printf("Found node: %+v\n", n)
					accum = append(accum, n)

				default:
					accum = append(accum, v)
				}
			}
		}
	}
	return accum, []Node{}
}
func groupify(in []Node, strMode string) ([]Node, []Node, int) {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if strMode != "" {
			switch v.Raw {
			case "\\":
				vv := in[i+1]
				accum = append(accum, vv)
				i = i + 1
			case strMode:
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
				sublist, in, i = groupify(in[i+1:], "\"")
				i = -1
				//fmt.Printf("Found string: %s\n", joinRaw(sublist))
				n := Node{Str: joinRaw(sublist)}
				//fmt.Printf("Found node: %+v\n", n)
				accum = append(accum, n)

			case "[":
				fallthrough
			case "{":
				fallthrough
			case "(":
				var sublist []Node
				sublist, in, i = groupify(in[i+1:], strMode)
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
					accum = []Node{}
					//accum = []Node{{"", "🛑", nil}}
					break
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
			//fmt.Printf("Found ==\n")
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

func isWhiteSpace(s string) bool {
	if s == "" {
		return false
	}
	r := []rune(s)
	return unicode.IsSpace(r[0]) || s[:1] == "\n" || s[:1] == "\t" || s[:1] == "\r" || s[:1] == " "
}

func mergeNonWhiteSpace(in []Node) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List == nil {
			if i == 0 {
				accum = append(accum, v)
			} else {
				if !isWhiteSpace(v.Raw) && !isWhiteSpace(in[i-1].Raw) {
					accum[len(accum)-1].Raw = accum[len(accum)-1].Raw + v.Raw
				} else {
					accum = append(accum, v)
				}
			}
		} else {
			accum = append(accum, Node{"", "", mergeNonWhiteSpace(v.List)})
		}
	}

	return append(output, accum...)
}

func stripNL(in []Node) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List == nil {
			//fmt.Printf("Comparing %s to %s\n", v.Raw, "\n")
			if v.Raw == "\n" {
				//fmt.Printf("Found NL %v\n", v)
			} else {
				accum = append(accum, v)
			}
		} else {
			accum = append(accum, Node{"", "", stripNL(v.List)})
		}
	}
	return append(output, accum...)
}

func stripWhiteSpace(in []Node) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List == nil {
			//fmt.Printf("Comparing %s to %s\n", v.Raw, "\n")
			if isWhiteSpace(v.Raw) {
				//fmt.Printf("Found NL %v\n", v)
			} else {
				accum = append(accum, v)
			}
		} else {
			accum = append(accum, Node{"", "", stripWhiteSpace(v.List)})
		}
	}
	return append(output, accum...)
}
func loadFile(path string) string {
	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
	return file
}
