// lzw
package main

import (
	"bytes"
	"fmt"
)

func newDict() (map[string]int, []string, int) {
	lastInd := 255
	dict := make(map[string]int)
	sym := make([]string, 10000)
	for i := 0; i < lastInd+1; i++ {
		newstr := fmt.Sprintf("%c", rune(i))
		dict[string([]byte{byte(i)})] = i
		sym[i] = newstr
	}
	return dict, sym, lastInd
}

func encode(input []byte) ([]int, []string) {
	out := []int{}
	dict, sym, lastInd := newDict()

	w := ""
	for i, _ := range input {
		c := string(input[i : i+1])
		newKey := w + c
		if _, ok := dict[newKey]; ok {
			w = newKey
		} else {
			out = append(out, dict[w])
			lastInd = lastInd + 1
			dict[newKey] = lastInd
			sym[lastInd] = newKey
			w = c
		}

	}
	if w != "" {
		out = append(out, dict[w])
	}

	return out, sym[0:lastInd]
}

func decode(input []int) []byte {
	out := []byte{}
	_, sym, lastInd := newDict()
	OLD := sym[input[0]]
	out = append(out, OLD...)

	for _, v := range input[1:] {
		str := ""

		if v <= lastInd {
			str = sym[v]
		} else {
			if v == lastInd+1 {
				str = OLD + OLD[0:1]
			} else {
				panic("!!!!!")
			}
		}

		out = append(out, []byte(str)...)
		firstChar := string(str[0:1])
		lastInd = lastInd + 1
		sym[lastInd] = OLD + firstChar
		OLD = str

	}
	return out
}

func main() {
	input := []byte("TOBEORNOTTOBEORTOBEORNOT")
	compressed, _ := encode(input)
	fmt.Println(compressed)
	//b2 := []int{84, 79, 66, 69, 79, 82, 78, 79, 84, 256, 258, 260, 265, 259, 261, 263}
	decompressed := (decode(compressed))
	if bytes.Equal(input, decompressed) {
		fmt.Println("Test passed")
	} else {
		fmt.Println("Test failed")
	}
}
