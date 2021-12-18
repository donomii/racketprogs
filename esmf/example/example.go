package main

//import "log"
import "fmt"
import "github.com/donomii/esmf"

type A struct {
	Greeting string
	Message  string
}

func main() {
	b := A{"Hello", "World"}
	fmt.Printf("Original Message: %v\n", b)
	fmt.Println("Encoded message: " + esmf.ToESMF(b))
	//message := "^^ 01 {{ 47 72 65 65 74 69 6e 67 :: 48 65 6c 6c 6f ,, 4d 65 73 73 61 67 65 :: 57 6f 72 6c 64 }} $$"
	message := esmf.ToESMF(b)
	decoded, err := esmf.FromESMF(message)
	if err == nil {
		fmt.Println("Decoded message: ", decoded)
	} else {
		fmt.Println(err)
	}

	c := []string{"Hello", "World"}
	fmt.Printf("Original Message: %v\n", c)
	fmt.Println("Encoded message: " + esmf.ToESMF(c))
	//message := "^^ 01 {{ 47 72 65 65 74 69 6e 67 :: 48 65 6c 6c 6f ,, 4d 65 73 73 61 67 65 :: 57 6f 72 6c 64 }} $$"
	message = esmf.ToESMF(c)
	decoded, err = esmf.FromESMF(message)
	if err == nil {
		fmt.Println("Decoded message: ", decoded)
	} else {
		fmt.Println(err)
	}
}
