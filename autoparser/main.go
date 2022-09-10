package autoparser

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"
	"unicode"
)

type Node struct {
	Raw          string
	Str          string
	List         []Node
	Note         string
	Line         int
	Column       int
	ChrPos       int
	File         string
	ScopeBarrier bool
	Kind         string
}

func NewTree(s, filename string) []Node {
	l := []Node{}
	line := 1
	pos := 0
	chrpos := 0
	for _, v := range strings.Split(s, "") {
		pos = pos + 1
		chrpos = chrpos + 1
		if v == "\n" {
			line = line + 1
			pos = 0
		}
		l = append(l, Node{v, "", nil, "", line, pos, chrpos, filename, false, "PARSED"})
	}
	return l
}

func ParseGo(code, filename string) []Node {
	l := NewTree(code, filename)
	// r, _ := Stringify(l, "//", "\n", "\\", "")
	// r, _ = Stringify(r, "\"", "\"", "\\", "")

	r, _ := MultiStringify(l, [][]string{
		{"//", "\n", "\\"},
		{"\"", "\"", "\\"},
		{"/*", "*/", "\\"},
	})
	// PrintTree(r, 0, false)
	r, _, _ = Groupify(r)
	r = KeywordBreak(r, []string{"import", "type", "func", "\n"}, true)
	r = MergeNonWhiteSpace(r)
	r = StripNL(r)
	r = StripWhiteSpace(r)
	// Need to split on spaces and merge before doing binops
	r = GroupBinops(r)
	// PrintTree(r, 0, false)
	return r
	// fmt.Printf("%+v\n", r)
}

func ParseXSH(code, filename string) Node {
	l := NewTree(code, filename)
	// FIXME we need to run both of these in parallel
	r, _ := Stringify(l, "\"", "\"", "\\", "")
	r, _ = Stringify(r, "#", "\n", "\\", "")

	// fmt.Printf("Stringified: ")
	// PrintTree(r, 0, false)
	r, _, _ = Groupify(r)
	r = KeywordBreak(r, []string{"|", "\n"}, true)
	// r = KeywordBreak(r, []string{"|"})
	r = StripNL(r)
	r = MergeNonWhiteSpace(r)

	r = StripWhiteSpace(r)
	StripEmptyLists(r)
	// PrintTree(r, 0, false)
	n := Node{List: r, File: filename, Line: r[0].Line, Column: r[0].Column, ChrPos: r[0].ChrPos}
	return n
	// fmt.Printf("%+v\n", r)
}

func PrintIndent(i int, c string) {
	for j := 0; j < i; j++ {
		fmt.Print(c)
	}
}

// Count the number of (sub)lists in this list of Nodes
func ContainsLists(l []Node, max int) bool {
	count := 0
	for _, v := range l {
		if v.List != nil {
			count = count + 1
		}
	}
	return count > max
}

// Recursively count the number of elements in a tree
func CountTree(t []Node) int {
	count := 0
	for _, v := range t {
		if v.List != nil {
			count = count + CountTree(v.List)
		} else {
			count = count + 1
		}
	}
	return count
}

// lalala))) ululu
func PrintTree(t []Node, indent int, newlines bool) {
	for _, v := range t {
		if v.List == nil {
			if v.Str == "" {
				// fmt.Print(".")
				fmt.Print(v.Raw, " ")
			} else {
				fmt.Print("『", v.Str, "』")
			}
		} else {
			if len(v.List) == 0 && (v.Note == "\n" || v.Note == "artifact") {
				print("\n")
				PrintIndent(indent, "_")
				continue
			}
			// If the current expression contains 3 or more sub expressions, break it across lines
			if ContainsLists(v.List, 3) {
				if CountTree(v.List) > 50 {

					fmt.Print("\n")
					PrintIndent(indent+1, "_")
				}
				fmt.Print("(")

				PrintTree(v.List, indent+2, true)
				print("\n")
				PrintIndent(indent, "_")
				fmt.Print(")\n")
			} else {
				fmt.Print("(")
				// fmt.Print(v.Note, "current length: ",len(v.List))
				PrintTree(v.List, indent+2, false)
				fmt.Print(")")

			}
		}
		if newlines {
			fmt.Print("\n")
			PrintIndent(indent, "_")
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

func matchList(ss []string, l []Node) bool {
	for _, s := range ss {
		if match(s, l) {
			return true
		}
	}
	return false
}

func returnMatchList(ss []string, l []Node) string {
	for _, s := range ss {
		if match(s, l) {
			return s
		}
	}
	return ""
}

func match(s string, l []Node) bool {
	if len(s) == 0 {
		return true
	}
	if len(l) == 0 {
		return false
	}
	// fmt.Println("Comparing ", s[0:1], "with", l[0].Raw)
	if s[0:1] == l[0].Raw {
		return match(s[1:], l[1:])
	}
	return false
}

// Searches through a list of nodes for a node that matches one of the start strings, then gathers the following nodes into a string node.
// This routine correctly handles strings that contain the start strings from other strings.
func MultiStringify(in []Node, stringDelimiters [][]string) ([]Node, []Node) {
	accum := []Node{}
	// Walk through in, looking for string starts
	for i := 0; i < len(in); i++ {
		v := in[i]
		log.Printf("Examinging %+v at %v\n", v, i)
		if v.List != nil {
			// Recurse down the tree, stringifying every branch we find
			var ret []Node
			ret, in = MultiStringify(v.List, stringDelimiters)
			i = -1
			accum = append(accum, Node{Note: v.Raw, List: ret, Line: v.Line, Column: v.Column, ChrPos: v.ChrPos, Kind: "String"})
		} else {

			// Build a list of all possible string start characters
			startChars := []string{}
			var strMode []string
			for _, v := range stringDelimiters {
				startChars = append(startChars, v[0])
			}
			switch {
			case matchList(startChars, in[i:]):
				matchedStr := returnMatchList(startChars, in[i:])
				// Locate the delimiters for matchedStr
				for _, v := range stringDelimiters {
					if v[0] == matchedStr {
						strMode = v
						break
					}
				}

				startChar := (strMode)[0]
				endChar := (strMode)[1]
				escapeChar := (strMode)[2]

				var sublist []Node
				sublist, in = Stringify(in[i+len(startChar):], startChar, endChar, escapeChar, endChar)
				i = -1
				if len(sublist) > 0 {
					n := Node{Str: joinRaw(sublist), Note: startChar, File: sublist[0].File, Line: sublist[0].Line, Column: sublist[0].Column, ChrPos: sublist[0].ChrPos, Kind: "String"}
					// fmt.Printf("Found node: %+v\n", n)
					accum = append(accum, n)
				} else {
					n := Node{Str: "", Note: startChar, File: v.File, Line: v.Line, Column: v.Column, ChrPos: v.ChrPos, Kind: "String"}
					accum = append(accum, n)
				}

			default:
				accum = append(accum, v)
			}

		}
	}
	return accum, in
}

// Searches through a list of nodes for a start string.  It collects the following nodes together until it finds the end string
func Stringify(in []Node, start, end, escape, strMode string) ([]Node, []Node) {
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List != nil {
			var ret []Node
			ret, in = Stringify(v.List, start, end, escape, strMode)
			i = -1
			accum = append(accum, Node{List: ret, Str: "", Note: start, File: v.File, Line: v.Line, Column: v.Column, ChrPos: v.ChrPos, Kind: "List"})
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
					sublist, in = Stringify(in[i+len(start):], start, end, escape, end)
					i = -1
					fmt.Printf("Found string: %s\n", joinRaw(sublist))
					if len(sublist) > 0 {
						n := Node{Str: joinRaw(sublist), Note: start, File: sublist[0].File, Line: sublist[0].Line, Column: sublist[0].Column, ChrPos: sublist[0].ChrPos}
						// fmt.Printf("Found node: %+v\n", n)
						accum = append(accum, n)
					} else {
						n := Node{Str: "", Note: start, File: v.File, Line: v.Line, Column: v.Column, ChrPos: v.ChrPos}
						accum = append(accum, n)
					}

				default:
					accum = append(accum, v)
				}
			}
		}
	}
	return accum, []Node{}
}

func Groupify(in []Node) ([]Node, []Node, int) {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]

		switch v.Raw {
		case "[":
			var sublist []Node
			sublist, in, i = Groupify(in[i+1:])
			i = -1
			accum = append(accum, Node{v.Raw, v.Str, sublist, "[", v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"}) // Use the opening parenthesis to identify the list
		case "{":
			var sublist []Node
			sublist, in, i = Groupify(in[i+1:])
			i = -1
			accum = append(accum, Node{v.Raw, v.Str, sublist, "{", v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"}) // Use the opening parenthesis to identify the list
		case "(":
			var sublist []Node
			sublist, in, i = Groupify(in[i+1:])
			i = -1
			accum = append(accum, Node{v.Raw, v.Str, sublist, "(", v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"}) // Use the opening parenthesis to identify the list
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

	return append(output, accum...), []Node{}, -1
}

// Starts a new sublist for each detected keyword.  Typically useful for e.g. function declarations.  If preserveKeyword is false, it throws
// away the keyword, which makes it useful for lists (see CSV example)
func KeywordBreak(in []Node, keywords []string, preserveKeyword bool) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		skipKeyword := false
		if v.List == nil {
			for _, keyword := range keywords {
				if match(keyword, in[i:]) {
					// We want to
					// 1.Capture the accumulator (e.g. we are in a list)
					// 2.Capture the next next subtree (or more), join with the current node
					//   e.g. a type or function definition, or a procedure call
					if len(accum) > 0 {
						output = append(output, Node{keyword, v.Str, accum, "artifact", v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"})
					} else {
						output = append(output, Node{keyword, v.Str, accum, "artifact", v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"})
					}

					if !preserveKeyword {
						fmt.Printf("Found keyword: %v at %v, next is %v\n", keyword, i, in[i+len(keyword)])
						i = i + len(keyword) - 1
						skipKeyword = true
					}
					accum = []Node{}
					// accum = []Node{{"", "🛑", nil}}
					break
				}
			}
			if !skipKeyword {
				accum = append(accum, v)
			}
		} else {
			accum = append(accum, Node{v.Raw, v.Str, KeywordBreak(v.List, keywords, preserveKeyword), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"})
		}
	}
	return append(output, accum...)
}

func GroupBinops(in []Node) []Node {
	accum := []Node{}

	for i := 0; i < len(in); i++ {
		v := in[i]

		if match(":=", in[i:]) {
			// fmt.Printf("Found ==\n")
			first := in[0:i]
			second := in[i+1:] // FIXME need to skip length of match
			firstret := GroupBinops(first)
			secondret := GroupBinops(second)
			v.Raw = "define"
			return []Node{
				v,
				{List: firstret},
				{List: secondret},
			}

		}
		if v.List == nil {
			accum = append(accum, v)
		} else {
			accum = append(accum, Node{v.Raw, v.Str, GroupBinops(v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"})
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

func MergeNonWhiteSpace(in []Node) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List == nil {
			if i == 0 {
				accum = append(accum, v)
			} else {
				if !(v.Raw == "") && (accum[len(accum)-1].Raw != "") && !isWhiteSpace(v.Raw) && !isWhiteSpace(in[i-1].Raw) {
					accum[len(accum)-1].Raw = accum[len(accum)-1].Raw + v.Raw
				} else {
					accum = append(accum, v)
				}
			}
		} else {
			accum = append(accum, Node{v.Raw, v.Str, MergeNonWhiteSpace(v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"})
		}
	}

	return append(output, accum...)
}

func StripNL(in []Node) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List == nil {
			// fmt.Printf("Comparing %s to %s\n", v.Raw, "\n")
			if v.Raw == "\n" {
				// fmt.Printf("Found NL %v\n", v)
			} else {
				accum = append(accum, v)
			}
		} else {
			accum = append(accum, Node{v.Raw, v.Str, StripNL(v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"})
		}
	}
	return append(output, accum...)
}

func StripEmptyLists(in []Node) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List == nil {
			accum = append(accum, v)
		} else {
			if len(v.List) == 0 {
			} else {
				accum = append(accum, Node{v.Raw, v.Str, StripNL(v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"})
			}
		}
	}
	return append(output, accum...)
}

func StripWhiteSpace(in []Node) []Node {
	output := []Node{}
	accum := []Node{}
	for i := 0; i < len(in); i++ {
		v := in[i]
		if v.List == nil {
			// fmt.Printf("Comparing %s to %s\n", v.Raw, "\n")
			if isWhiteSpace(v.Raw) {
				// fmt.Printf("Found NL %v\n", v)
			} else {
				accum = append(accum, v)
			}
		} else {
			accum = append(accum, Node{v.Raw, v.Str, StripWhiteSpace(v.List), v.Note, v.Line, v.Column, v.ChrPos, v.File, v.ScopeBarrier, "List"})
		}
	}
	return append(output, accum...)
}

func LoadFile(path string) string {
	fileb, _ := ioutil.ReadFile(path)
	file := string(fileb)
	// log.Println("Loaded file:", path, file)
	return file
}
