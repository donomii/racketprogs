puts "2 + 3"
set x [+ 2 3]
puts $x
proc sayHello { name } {
	puts "Hello " name
}
proc returnOne {} { "1" }
puts "Testing return"
puts "Test 1:" [returnOne]
puts [+ [+ 1 2] [saveInterpreter "savefile.cont"] [+ 3 4] ]
#puts "Editing main.go"
#run vim main.go
#puts [loadfile "main.go"]
ls .
sayHello "Jeremy"
proc map  { func alist } { {{} seq seq}
	if [eq [length alist] 0] {
		{"map end"}
        } else { {{} seq seq}
		"Start of else clause"
		puts "Func result:" [cons [func [lindex alist 0]] {"end"}]
		cons [func [lindex alist 0]] [map func [lrange alist 1 end]]
	}
}

puts [dump [map {{a} + 1 a} { 1 2 3 4 5}]]
exit 0


proc fold  { func accum alist } { 
	puts "fold list: " accum alist
	if [eq [length alist] 0] {
		{"end"}
        } else {
		if [eq [length alist] 1] {
			func accum [lindex alist 0]
		} else {
			fold func [func accum [lindex alist 0]] [lrange alist 1 end]
		}
	}
}



proc CR {} { chr 13 }
proc LF {} { chr 10 }


puts "Starting fold"
fold {{a b} [puts "fold:" b] [cons b a]} {"accum"} { 1 2 3 4 5 }


proc reverse {alist} { fold {{accum b} [cons b accum]} {} alist }


puts "Reversed: " [dump [reverse { a b c d } ]]



#proc lambdify { alist } {
#	[cons {} alist]
#}
