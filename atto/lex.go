package atto

// This file adapted from  https://github.com/mattn/go-shellwords
//License: MIT

import (
	"errors"
)

func NewParser() *Parser {
	return &Parser{
		Position: 0,
		Dir:      "",
	}
}

func Parse(line string) ([]string, error) {
	return NewParser().Parse(line)
}

type argType int

const (
	argNo argType = iota
	argSingle
	argQuoted
)

type Parser struct {
	Position int
	Dir      string
}

func isSpace(r rune) bool {
	switch r {
	case ' ', '\t', '\r', '\n':
		return true
	}
	return false
}

func (p *Parser) Parse(line string) ([]string, error) {
	args := []string{}
	buf := ""
	var escaped, doubleQuoted, singleQuoted bool
	backtick := ""

	pos := -1
	got := argNo

	i := -1
	for _, r := range line {
		i++
		if escaped {
			buf += string(r)
			escaped = false
			got = argSingle
			continue
		}

		if r == '\\' {
			if singleQuoted {
				buf += string(r)
			} else {
				escaped = true
			}
			continue
		}

		if isSpace(r) {
			if singleQuoted || doubleQuoted {
				buf += string(r)
				backtick += string(r)
			} else if got != argNo {

				if got == argQuoted {
					args = append(args, "__quote")

				}

				args = append(args, buf)

				buf = ""
				got = argNo
			}
			continue
		}

		switch r {

		case ')':
			if !singleQuoted && !doubleQuoted {

				backtick = ""
			}
		case '(':
			if !singleQuoted && !doubleQuoted {
				buf += "("
				continue
			}
		case '"':
			if !singleQuoted {
				if doubleQuoted {
					got = argQuoted
				}
				doubleQuoted = !doubleQuoted
				continue
			}
		case '\'':
			if !doubleQuoted {
				if singleQuoted {
					got = argQuoted
				}
				singleQuoted = !singleQuoted
				continue
			}
		}

		got = argSingle
		buf += string(r)

	}

	if got != argNo {

		if got == argQuoted {
			args = append(args, "__quote")

		}
		args = append(args, buf)
	}

	if escaped || singleQuoted || doubleQuoted {
		return nil, errors.New("invalid command line string")
	}

	p.Position = pos

	return args, nil
}
