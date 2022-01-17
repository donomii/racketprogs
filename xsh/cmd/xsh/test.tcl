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
proc map  { func alist } {
	if [eq [length alist] 0] {
		{"map end"}
        } else {
		cons [func [lindex alist 0]] [map func [lrange alist 1 end]]
	}
}

puts [dump [map {a| + 1 a} { 1 2 3 4 5}]]


proc fold { func accum alist } { 
	#puts "fold list: " alist "accum:" accum
	if [eq [length alist] 0] {
		accum
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
puts [fold {a b| seq [cons b a]} {"accumstart"} { 1 2 3 4 5 }]


proc reverse {alist} {
       fold {a b| seq [cons b a]} {} alist 
}


puts "Reversed: " [dump [reverse { a b c d } ]]

proc countdown { n } { 
	puts n
	if [gt n 0] {
	       	countdown [- n 1]
	}
}

countdown 5

#proc lambdify { alist } {
#	[cons {} alist]
#}
