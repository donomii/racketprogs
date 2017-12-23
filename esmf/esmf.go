package main

import "bytes"
import "strings"
import "errors"
import "reflect"
import "io"
import "log"
import "fmt"
import "encoding/hex"

type A struct {
	Greeting string
	Message  string
}

func EncodeString (s string) string {
	l := len(s)
	out := []string{}
	for i:=0;i<l;i++ {
		h := hex.EncodeToString([]byte(s[i:i+1]))
		out = append(out, h)
	}
	return strings.Join(out, " ")
}

func translate(obj interface{}, buff *bytes.Buffer) {
	// Wrap the original in a reflect.Value
	original := reflect.ValueOf(obj)

	buff.WriteString("^^ 01 ")
	translateRecursive(original, buff)
	buff.WriteString(" $$")

}

var out io.Writer

func translateRecursive(original reflect.Value, buff *bytes.Buffer) {
	switch original.Kind() {
	// The first cases handle nested structures and translate them recursively

	// If it is a pointer we need to unwrap and call once again
	case reflect.Ptr:
		// To get the actual value of the original we have to call Elem()
		// At the same time this unwraps the pointer so we don't end up in
		// an infinite recursion
		originalValue := original.Elem()
		// Check if the pointer is nil
		if !originalValue.IsValid() {
			return
		}
		// Unwrap the newly created pointer
		translateRecursive(originalValue, buff)

	// If it is an interface (which is very similar to a pointer), do basically the
	// same as for the pointer. Though a pointer is not the same as an interface so
	// note that we have to call Elem() after creating a new object because otherwise
	// we would end up with an actual pointer
	case reflect.Interface:
		// Get rid of the wrapping interface
		originalValue := original.Elem()
		// Create a new object. Now new gives us a pointer, but we want the value it
		// points to, so we have to call Elem() to unwrap it
		translateRecursive(originalValue, buff)

	// If it is a struct we translate each field
	case reflect.Struct:
		//log.Println("struct")
		buff.WriteString("{{ ")
		for i := 0; i < original.NumField(); i += 1 {
			if i != 0 { buff.WriteString(" ,, ") }
			f := original.Field(i)
			fname := original.Type().Field(i).Name
			//log.Println(fmt.Sprintf("%v", original.Field(i).Name))
			buff.WriteString(fmt.Sprintf("%v ,: ", EncodeString(fname)))
			//log.Println(EncodeString(fmt.Sprintf("%v", original.Field(i).Name)))
			translateRecursive(f, buff)
		}
		buff.WriteString(" }}")

	// If it is a slice we create a new slice and translate each element
	case reflect.Slice:
		for i := 0; i < original.Len(); i += 1 {
			translateRecursive(original.Index(i), buff)
		}

	// If it is a map we create a new map and translate each value
	case reflect.Map:
		log.Println("map")
		for _, key := range original.MapKeys() {
			originalValue := original.MapIndex(key)
			// New gives us a pointer, but again we want the value
			translateRecursive(originalValue, buff)
		}

	// Otherwise we cannot traverse anywhere so this finishes the the recursion
	// And everything else will simply be taken from the original
	default:
		//log.Println(fmt.Sprintf("%v", original))
		buff.WriteString(EncodeString(fmt.Sprintf("%v", original)))
	}
}

func toESMF (obj interface{}) string {
var buff bytes.Buffer
translate(obj, &buff)
return string(buff.Bytes())
}

func decodeString(s string) (byte, error) {
	b, err := hex.DecodeString(s)
	if err == nil {
		return b[0], err
	} else {
		return byte(0), err
	}
}

type byteString []byte
func decodeBasic(s string) ([]byteString, error) {
	codes := strings.Split(s, " ")
	var out []byteString
	if codes[0] != "^^" { return []byteString{}, errors.New("Missing ^^ at start of message, invalid format")}
	if codes[len(codes)-1] != "$$" { return []byteString{}, errors.New("Missing $$ at start of message, invalid format")}
	for _, v := range codes {
		b, err := decodeString(v)
		if err != nil{
			//It might be a control code
			out = append(out, []byte(v))
		} else {
			out = append(out, byteString{b})
		}
	}

	return out, nil
}

func joinByteStrings (b []byteString) byteString {
	var out byteString
	for _,v := range  b {
		out = append(out, v...)
	}
	return out
}

func buildTokens(s []byteString) []byteString{
	if  len(s) == 0 { return []byteString{} }
	fmt.Println("Builtoken from: ", s[0])
	if len(s[0]) ==1 {
		i:=0
		for i=0; i<len(s) && len(s[i]) ==1; i=i {
			i=i+1
		}
		str := joinByteStrings(s[0:i])
		return append([]byteString{str}, buildTokens(s[i:])...)
	}
	return append([]byteString{s[0]}, buildTokens(s[1:])...)
}

func buildHash (b []byteString) (map[string]interface{}, []byteString) {
	var h map[string]interface{} = map[string]interface{}{}
	//Fucking unbelievable
	first := string(b[0])
	if first !=  "{{" {return h, b}
	i:=0
	for i=0; string(b[i]) != "}}"; i=i {
		key := b[i+1]
		var val interface{}
		val = b[i+3]
		bval := b[i+1]
		if string(bval) == "[[" || string(bval) == "{{" {
			val, b = buildStruct(b[i+1:])
			i=0
		} else {
			i=i+4
		}
		h[string(key)] = val
	}
	return h, b[i+1:]
}


func buildArray (b []byteString) (map[string]interface{}, []byteString) {
	var h map[string]interface{} = map[string]interface{}{}
	if string(b[0]) !=  "[[" {return h, b}
	i:=0
	for i=0; string(b[i]) != "]]"; i=i {
		if i> 0 && string(b[i]) != ",," { panic ("Expected ,, got " + string(b[i])) }
		key := fmt.Sprintf("%v", i)
		var val interface{}
		val = b[i+1]
		bval := b[i+1]
		fmt.Println("bval is ", string(bval))
		if string(bval) == "[[" || string(bval) == "{{" {
			val, b = buildStruct(b[i+1:])
			i = 0
		} else {
			i=i+2
		}

		h[key] = val
	}
	return h, b[i+1:]
}

func fromESMF (s string) (map[string]interface{}, error){
	b,_ := decodeBasic(s)
	fmt.Println(b)
	c := buildTokens(b)
	fmt.Println(c)
	for _,v := range c {
		fmt.Println(string(v))
	}
	d,_ := buildStruct(c[2:])
	fmt.Println(d)
	return d, nil
}

func buildStruct(b []byteString) (map[string]interface{}, []byteString) {
	c:= b[0]
	var v map[string]interface{}
	fmt.Println("Building struct for: ", string(c))
	if string(c)=="[[" {
		fmt.Println("Building array")
		v, b = buildArray(b)
	} else{
		if string(c)=="{{" {
			fmt.Println("Building hash")
			v, b = buildHash(b)
		}
	}
	return v, b
}

func main () {
	b := A{ "Hello", "World"}
	fmt.Println(toESMF(b))
	//message := "^^ 01 {{ 47 72 65 65 74 69 6e 67 :: 48 65 6c 6c 6f ,, 4d 65 73 73 61 67 65 :: 57 6f 72 6c 64 }} $$"
	message := "^^ 01 [[ {{ 47 72 65 65 74 69 6e 67 :: 48 65 6c 6c 6f ,, 4d 65 73 73 61 67 65 :: 57 6f 72 6c 64 }} ,, {{ 47 72 65 65 74 69 6e 67 :: 48 65 6c 6c 6f ,, 4d 65 73 73 61 67 65 :: 57 6f 72 6c 64 }} ]] $$"
	decoded, err := fromESMF(message)
	if err == nil {
		fmt.Println(decoded)
	} else {
		fmt.Println(err)
	}
}
