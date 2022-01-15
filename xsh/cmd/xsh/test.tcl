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
proc fold  { func accum alist } { 
	puts "fold list: " alist
	if [eq [length alist] 1] {
		[func accum [lindex alist 0]]
	} else {
		fold func [func accum [lindex alist 0]] [lrange alist 1 end]
	}
}
puts "Starting fold"
fold {{a b} [puts "fold:" b] "retval"} "accum" { 1 2 3 4 5 }
fold puts "accum" { 1 2 3 4 5 }



#proc lambdify { alist } {
#	[cons {} alist]
#}