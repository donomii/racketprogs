package xsh

import (
	autoparser "../autoparser"
	"errors"
	"fmt"
	"strconv"
	"strings"
)

//Extracts the string/raw value of a node. Does not handle lists.
func NodeToString(v autoparser.Node) string {
	if v.Raw == "" {
		return v.Str
	} else {
		return v.Raw
	}
}

//Converts a list of nodes to a list of strings.  All the nodes must be string/raw type.  Does not handle sublists.
func ListToStrings(l []autoparser.Node) ([]string, error) {
	out := []string{}
	for _, v := range l {
		if v.List != nil {
			return nil, errors.New(fmt.Sprintf("ListToArray: List cannot be converted to string array: %+v\n", l))
		} else {
			out = append(out, NodeToString(v))
		}
	}
	return out, nil
}

//Converts a list of go strings into a list of nodes
func StringsToList(s []string, sourceNode autoparser.Node) autoparser.Node {
	out := []autoparser.Node{}
	for _, v := range s {
		out = append(out, autoparser.Node{Str: v, File: sourceNode.File, Line: sourceNode.Line, Column: sourceNode.Column, ChrPos: sourceNode.ChrPos})
	}

	o := EmptyList(sourceNode)
	o.List = out
	return o
}

//As ListToStrings, combines them into one string
func ListToStr(l []autoparser.Node) string {
	str, _ := ListToStrings(l)
	out := strings.Join(str, " ")
	return out
}

//String to int
func atoi(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}

//String to float
func atof(s string) float64 {
	i, _ := strconv.ParseFloat(s, 64)
	return i
}

//Converts a go string into a string node
func N(s string) autoparser.Node {
	return autoparser.Node{Str: s}
}

//Converts a go bool into a bool node
func Bool(s bool) autoparser.Node {
	if s {
		return autoparser.Node{Str: "1"}
	} else {
		return autoparser.Node{Str: "0"}
	}
}

//Extracts the string/raw value of a node. Does not handle lists.
func S(n autoparser.Node) string {
	return NodeToString(n)
}
