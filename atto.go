package atto

import (
	"bufio"
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"reflect"
	"strconv"
	"strings"

	"github.com/mattn/go-shellwords"

	_ "embed"
)

//go:embed core.at
var coreFuncs string

type Atto struct {
	Functions map[string][]interface{}
}

func NewAtto() *Atto {
	a := Atto{}
	a.Functions = map[string][]interface{}{}
	return &a
}

func makeFunc(args ...interface{}) []interface{} {
	return args

}

func searchTo(search string, tokens, accum []string) ([]string, []string) {
	if len(tokens) == 0 || search == tokens[0] {
		return accum, tokens
	}
	return searchTo(search, tokens[1:], append(accum, tokens[0]))
}

func eval(expr interface{}, funcsmap map[string][]interface{}, args map[string][]interface{}) interface{} {
	fnlist := expr.([]interface{})
	log.Printf("Evaluating: %+v\n", fnlist)
	fn := fnlist[0].(string)
	switch fn {
	case "if":
		if eval(fnlist[1], funcsmap, args).(bool) {
			return eval(fnlist[2], funcsmap, args)
		} else {
			return eval(fnlist[3], funcsmap, args)
		}
	case "__eq":
		a := eval(fnlist[1], funcsmap, args)
		b := eval(fnlist[2], funcsmap, args)
		return reflect.DeepEqual(a, b)
	case "__add":
		a, _ := strconv.ParseFloat(eval(fnlist[1], funcsmap, args).(string), 64)
		b, _ := strconv.ParseFloat(eval(fnlist[2], funcsmap, args).(string), 64)
		return fmt.Sprintf("%v", a+b)
	case "__neg":
		a, _ := strconv.ParseFloat(eval(fnlist[1], funcsmap, args).(string), 64)
		return fmt.Sprintf("%v", -a)
	case "__mul":
		a, _ := strconv.ParseFloat(eval(fnlist[1], funcsmap, args).(string), 64)
		b, _ := strconv.ParseFloat(eval(fnlist[2], funcsmap, args).(string), 64)
		return fmt.Sprintf("%v", a*b)
	case "__div":
		a, _ := strconv.ParseFloat(eval(fnlist[1], funcsmap, args).(string), 64)
		b, _ := strconv.ParseFloat(eval(fnlist[2], funcsmap, args).(string), 64)
		return fmt.Sprintf("%v", a/b)
	case "__rem":
		a, _ := strconv.ParseInt(eval(fnlist[1], funcsmap, args).(string), 10, 64)
		b, _ := strconv.ParseInt(eval(fnlist[2], funcsmap, args).(string), 10, 64)
		return fmt.Sprintf("%v", a%b)
	case "__less":
		a, _ := strconv.ParseFloat(eval(fnlist[1], funcsmap, args).(string), 64)
		b, _ := strconv.ParseFloat(eval(fnlist[2], funcsmap, args).(string), 64)
		return a < b
	case "__lesseq":
		a, _ := strconv.ParseFloat(eval(fnlist[1], funcsmap, args).(string), 64)
		b, _ := strconv.ParseFloat(eval(fnlist[2], funcsmap, args).(string), 64)
		return a <= b
	case "__head":
		return eval(fnlist[1], funcsmap, args).([]interface{})[0]
	case "__tail":
		return eval(fnlist[1], funcsmap, args).([]interface{})[1:]
	case "__strconcat":
		log.Printf("Concatenating strings: %v, %v\n", fnlist[1], fnlist[2])
		a := eval(fnlist[1], funcsmap, args)
		b := eval(fnlist[2], funcsmap, args)
		out := fmt.Sprintf("%+v%+v", a, b)
		log.Printf("Concatenated string: %v\n", out)
		return out

	case "__str":
		return fmt.Sprintf("%v", fnlist[1])

	case "__print":
		out := fmt.Sprintf("%+v", eval(fnlist[1], funcsmap, args))
		fmt.Printf("%v\n", out)
		return out
	case "__value":
		//Try to resolve a symbol.  If it is defined in the argument list, use that
		val, ok := args[fnlist[1].(string)]
		if !ok {
			//Otherwise check to see if it is defined as a function
			val, ok = funcsmap[fnlist[1].(string)]
			if !ok {
				//If not found at all, use it as a string
				log.Printf("Resolved to %v\n", fnlist[1])
				return fnlist[1]
			}
		}

		log.Printf("Resolved to %v\n", val[2])
		return val[2]

	case "__pair":
		car := eval(fnlist[1], funcsmap, args)
		cdr := eval(fnlist[2], funcsmap, args)
		out := []interface{}{car, cdr}
		return out

	case "__words":
		words, _ := shellwords.Parse(fmt.Sprintf("%v", eval(fnlist[1], funcsmap, args)))
		out := []interface{}{}
		for _, w := range words {
			//out = append(out, []interface{}{"value", w})
			v := []interface{}{w}
			out = append(out, v[0])
		}
		return out
	case "__input":
		val := eval(fnlist[1], funcsmap, args)
		reader := bufio.NewReader(os.Stdin)
		fmt.Print(val)
		text, err := reader.ReadString('\n')
		text = strings.Trim(text, "\n")
		if err != nil {
			panic(err)
		}
		return []interface{}{text}[0]
	}
	userFunc, ok := funcsmap[fn]
	if ok {
		log.Printf("Userfunc: %+v\n", userFunc)
		newFM := map[string][]interface{}{}

		for i, v := range userFunc[1].([]string) {
			//fmt.Printf("(%v) Evalling: %+v for arg %v\n", userFunc, expr.([]interface{})[1+i], v)
			val := eval(expr.([]interface{})[1+i], funcsmap, args)
			log.Printf("(%v) Setting %v to %v\n", userFunc, v, val)
			newFM[v] = []interface{}{v, []string{}, val}
		}
		return eval(userFunc[2], funcsmap, newFM)
	}

	log.Printf("Undefined function: %v\n", fnlist[0])
	os.Exit(1)
	return fnlist[0]
}

func parse_expr(tokens []string, args []string, func_defs map[string][]interface{}) ([]interface{}, []string) {

	if len(tokens) == 0 {
		return nil, tokens
	}
	token := tokens[0]

	log.Printf("Considering %v\n", token)

	if token == "fn" {
		name := tokens[1]
		remainder := tokens[2:]
		args, remainder := searchTo("is", remainder, []string{})

		log.Println("Found args", args)
		remainder = remainder[1:]
		body, remainder := searchTo("fn", remainder, []string{})
		log.Println("Found body", body)
		bodyTree, _ := parse_expr(body, args, func_defs)
		log.Println("Parsed body", bodyTree)
		log.Printf("Registering %v(%v)\n", name, args)

		func_defs[name] = makeFunc("fn", args, bodyTree)
		log.Printf("Registered functions %+v", func_defs)
		return parse_expr(remainder, args, func_defs)
	}

	if token == "if" {
		arg1, remainder := parse_expr(tokens[1:], args, func_defs)
		arg2, remainder := parse_expr(remainder, args, func_defs)
		arg3, remainder := parse_expr(remainder, args, func_defs)
		return makeFunc("if", arg1, arg2, arg3), remainder
	}

	//No arg functions
	for _, builtIn := range []string{} {
		if token == builtIn {
			log.Printf("Function %v(%v)\n", token)
			return []interface{}{builtIn}, tokens
		}
	}

	//Single arg functions
	for _, builtIn := range []string{"__input", "__head", "__tail", "__litr", "__str", "__words", "__print", "__neg"} {
		if token == builtIn {
			arg1, remainder := parse_expr(tokens[1:], args, func_defs)
			log.Printf("Defining function %v(%v)\n", token, arg1)
			return makeFunc(builtIn, arg1), remainder
		}
	}

	for _, builtIn := range []string{"__strconcat", "__fuse", "__pair", "__eq", "__add", "__mul", "__div", "__rem", "__less", "__lesseq"} {
		if token == builtIn {
			arg1, remainder := parse_expr(tokens[1:], args, func_defs)
			arg2, remainder := parse_expr(remainder, args, func_defs)
			log.Printf("Defining function %v(%v,%v)\n", token, arg1, arg2)
			return makeFunc(builtIn, arg1, arg2), remainder
		}
	}

	fn, ok := func_defs[token]
	remainder := tokens[1:]
	if ok {
		log.Printf(
			"%v is a previously defined function,  args: (%+v),\n{%+v}\n",
			token,
			fn[1],
			fn,
		)
		out := []interface{}{}
		out = append(out, token)
		var next interface{}
		for range fn[1].([]string) {
			next, remainder = parse_expr(remainder, args, func_defs)
			out = append(out, next)
		}
		return out, remainder
	}

	//Default: it's a literal value
	log.Println("Literal:", token)
	return makeFunc("__value", token), tokens[1:]
}

func lex(code string) []string {
	tokens, _ := Parse(code)
	return tokens
}

func LoadFile(fname string, a *Atto) {
	code, err := ioutil.ReadFile(fname)
	if err != nil {
		panic(err)
	}

	log.Println("Loaded", string(code))
	LoadString(string(code), a)
}

func LoadString(code string, a *Atto) {
	lexed := lex(coreFuncs + (string(code)))

	//Parse twice to pick up forwards declarations.  The first pass parses the function args correctly,
	//but can't resolve any functions that are defined later in the file.
	//At the start of the second pass, we know the number of arguments for every function, so now we can
	//parse the bodies correctly
	parse_expr(lexed, []string{}, a.Functions) //First pass picks up function names
	parse_expr(lexed, []string{}, a.Functions) //Second pass gets function bodies correctly
}
func RunFunc(f string, a *Atto) interface{} {
	main, ok := a.Functions[f]
	//log.Printf("Registered functions %+v", funcs)
	var ret interface{}
	if ok {
		ret = eval(main[2], a.Functions, nil)
	} else {
		fmt.Printf("Function %v not found\n", f)
	}
	return ret
}

// based on https://github.com/mattn/go-shellwords
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
	var escaped, doubleQuoted, singleQuoted, backQuote, dollarQuote bool
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
			if singleQuoted || doubleQuoted || backQuote || dollarQuote {
				buf += string(r)
				backtick += string(r)
			} else if got != argNo {

				args = append(args, buf)

				buf = ""
				got = argNo
			}
			continue
		}

		switch r {

		case ')':
			if !singleQuoted && !doubleQuoted && !backQuote {

				backtick = ""
				dollarQuote = !dollarQuote
			}
		case '(':
			if !singleQuoted && !doubleQuoted && !backQuote {
				if !dollarQuote && strings.HasSuffix(buf, "$") {
					dollarQuote = true
					buf += "("
					continue
				} else {
					return nil, errors.New("invalid command line string")
				}
			}
		case '"':
			if !singleQuoted && !dollarQuote {
				if doubleQuoted {
					got = argQuoted
				}
				doubleQuoted = !doubleQuoted
				continue
			}
		case '\'':
			if !doubleQuoted && !dollarQuote {
				if singleQuoted {
					got = argQuoted
				}
				singleQuoted = !singleQuoted
				continue
			}
		}

		got = argSingle
		buf += string(r)
		if backQuote || dollarQuote {
			backtick += string(r)
		}
	}

	if got != argNo {

		args = append(args, buf)

	}

	if escaped || singleQuoted || doubleQuoted || backQuote || dollarQuote {
		return nil, errors.New("invalid command line string")
	}

	p.Position = pos

	return args, nil
}
