package goStringTable

import "testing"
import "fmt"

func TestSym(t *testing.T) {
    s := New()
    n := s.LookupOrCreate("Hello World")
    fmt.Println(s)
    fmt.Println("Lookup: ",n, s.GetString(n))
}
