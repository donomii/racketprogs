package xsh

import (
	autoparser "../autoparser"
	"errors"
	"fmt"
	"strconv"
	"strings"
)

func NodeToString(v autoparser.Node) string {
	if v.Raw == "" {
		return v.Str
	} else {
		return v.Raw
	}
}
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

func StringsToList(s []string) autoparser.Node {
	out := []autoparser.Node{}
	for _, v := range s {
		out = append(out, autoparser.Node{Str: v})
	}

	o := EmptyList()
	o.List = out
	return o
}

func ListToStr(l []autoparser.Node) string {
	str, _ := ListToStrings(l)
	out := strings.Join(str, " ")
	return out
}

//This is ridiculous
func atoi(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}

func atof(s string) float64 {
	i, _ := strconv.ParseFloat(s, 64)
	return i
}
func N(s string) autoparser.Node {
	return autoparser.Node{Str: s}
}
