package main

import (
    "time"
    "github.com/BurntSushi/toml"
    "errors"
    "github.com/shanna/sexp"
    "io/ioutil"
     "encoding/json"
    "strings"
    "reflect"
    "fmt"
    "github.com/beego/goyaml2"
    "os"
)

func nodeToMap(node interface{}) map[string]interface{} {
    m, ok := node.(map[string]interface{})
    if !ok {
        panic(fmt.Sprintf("%v is not of type map", node))
    }
    return m
}

func nodeToList(node interface{}) []interface{} {
    m, ok := node.([]interface{})
    if !ok {
        panic(fmt.Sprintf("%v is not of type list", node))
    }
    return m
}

func i2s(indent int) string {
    return strings.Repeat(" ", indent)
}

func walkTree(parsed interface{}, indent int) string {
switch parsed.(type) {
    case time.Time:
        return fmt.Sprintf("\"%v\"",parsed.(time.Time))
    case bool:
        return fmt.Sprintf("%v",parsed.(bool))
    case int:
        return fmt.Sprintf("%v",parsed.(int))
    case int64:
        return fmt.Sprintf("%v",parsed.(int64))
    case []int8:
        return fmt.Sprintf("%v",parsed.([]int8))  //FIXME
    case string:
        return fmt.Sprintf(parsed.(string))
    case float64:
        return fmt.Sprintln(parsed.(float64))
    case map[string]interface{}:
        accum := ""
        accum += fmt.Sprintf("\n%v(", i2s(indent))
        val := parsed.(map[string]interface{})
        for k,v := range val {
        accum += fmt.Sprintf("\n%v(", i2s(indent+1))
            accum += fmt.Sprintf("%v: ",k)
            accum += walkTree(v, indent+1)
            accum += fmt.Sprintf(")")
        }
        accum += fmt.Sprintf(")")
        return accum
        //fmt.Println(parsed.(map[string]interface{}))
    case []interface{}:
        accum := fmt.Sprintf("\n%v(", i2s(indent))
        val := parsed.([]interface{})
        for _,v := range val {
            //fmt.Println(i)
            accum += fmt.Sprintf("\n%v", i2s(indent))
            accum += walkTree(v, indent+1)
            //accum += fmt.Sprintf(" ")
        }
        accum += fmt.Sprintf(")")
        return accum
        //fmt.Println(parsed.([]interface{}))
    default:
        panic(fmt.Sprintf("type not understood: %v\n", reflect.TypeOf(parsed).String()))
}
}

func jsonWalkTree(parsed interface{}, indent int) string {
switch parsed.(type) {
    case time.Time:
        return fmt.Sprintf("\"%v\"",parsed.(time.Time))
    case bool:
        return fmt.Sprintf("%v",parsed.(bool))
    case int:
        return fmt.Sprintf("%v",parsed.(int))
    case int64:
        return fmt.Sprintf("%v",parsed.(int64))
    case []uint8:
        return fmt.Sprintf("\"%v\"",string(parsed.([]uint8)))  //FIXME
    case string:
        return fmt.Sprintf("\"%v\"", parsed.(string))
    case float64:
        return fmt.Sprintln(parsed.(float64))
    case map[string]interface{}:
        accum := ""
        accum += fmt.Sprintf("%v{", i2s(indent))
        val := parsed.(map[string]interface{})
        for k,v := range val {
        accum += fmt.Sprintf("\n%v", i2s(indent+1))
            accum += fmt.Sprintf("\"%v\" : ",k)
            accum += jsonWalkTree(v, indent+1)
        }
        accum += fmt.Sprintf("}")
        return accum
        //fmt.Println(parsed.(map[string]interface{}))
    case []interface{}:
        accum := fmt.Sprintf("\n%v(", i2s(indent))
        val := parsed.([]interface{})
        for _,v := range val {
            //fmt.Println(i)
            accum += fmt.Sprintf("\n%v", i2s(indent))
            accum += jsonWalkTree(v, indent+1)
            //accum += fmt.Sprintf(" ")
        }
        accum += fmt.Sprintf(")")
        return accum
        //fmt.Println(parsed.([]interface{}))
    default:
        panic(fmt.Sprintf("type not understood: %v\n", reflect.TypeOf(parsed).String()))
}
}

func unmarshalSexp(data []byte) (object interface{}, err error) {
        defer func() {
        if r := recover(); r != nil {
            err = errors.New(fmt.Sprintf("%v",r))
        }
    }()
    object, err = sexp.Unmarshal(data)
    return object, err
}

func unmarshalToml(data []byte) (object interface{}, err error) {
        defer func() {
        if r := recover(); r != nil {
            err = errors.New(fmt.Sprintf("%v",r))
        }
    }()
    err = toml.Unmarshal(data, &object)
    return object, err
}

func unmarshalJson(data []byte) (object interface{}, err error) {
        defer func() {
        if r := recover(); r != nil {
            err = errors.New(fmt.Sprintf("%v",r))
        }
    }()
    err = json.Unmarshal(data, &object)
    return object, err
}


func main() {
    filename := os.Args[1]
    file, err := os.Open(filename)
    if err != nil {
        panic(err)
    }
    var object interface{}
    data, err := ioutil.ReadFile(filename)
    if err != nil {
        panic("Unable to read " + filename)
    } else {
        object, err = unmarshalJson(data)
    if err != nil {
        object, err = unmarshalSexp(data)
    if err != nil {
        object, err = unmarshalToml(data)
    if err != nil {
        object, err = goyaml2.Read(file)
    if err != nil {
        panic(err)
    }}}}}
    fmt.Println(jsonWalkTree(object, 0))
}
