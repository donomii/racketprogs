package main
import (
"github.com/donomii/glim"
"fmt"
"strings"
)

func genString(size int, index int) string {

	ret := ""
	colour := glim.RGBA{255,255,255,255}
	str := fmt.Sprintf("%c",index)
	//block := fmt.Sprintf("%c",169)
	gimg, _ := glim.DrawStringRGBA(16,colour,str,"f1.txt")
	img, width, _ := glim.GFormatToImage(gimg, nil, 0, 0)
	//glim.DumpBuff(img, uint(width), uint(height))
	h:=16
	w:=16
	for y:=0; y<h; y++ {

	for x:=0; x<w; x=x+1 {
		if (img[(x + y*width)*4] == 0) {
			ret = ret + " "
		} else {
			ret = ret + "*"
		}
	}
		//ret=ret+"|\n"
}
	//fmt.Println("---")

	return ret
}
func display (l, width int, str string) {
			fmt.Printf("%v: %v pixels\n", l, strings.Count(str, "*"))

		for i:=0; i<width+2; i++ {
			fmt.Print("_")
		}
		fmt.Println("")
		for i:=0; i<width; i++ {
			fmt.Println("|"+str[i*width:i*width+width]+ "|")
		}
		for i:=0; i<width+2; i++ {
			fmt.Print("_")
		}
		fmt.Println("")
	}


func main() {
	//var width, height int
	//var img []uint8
	noChar := "  ***********     ***********     ***********     **       **     **       **     **       **     **       **     **       **     **       **     **       **     **       **     **       **     **       **     **       **     ***********     ***********   "
width:= 16
	for l:= 0; l<0x9FFF; l++ {
		str := genString(width, l)
		if str != noChar {
			//display(l, width, str)
	fmt.Printf("SetLetter(%v, \"%s\")\n", l, str)
}
}
}
