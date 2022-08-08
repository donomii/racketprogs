puts "2 + 3"
set x [+ 2 3]
puts $x
func sayHello {name|
	puts "Hello " name
}
func returnOne {| "1" }
puts "Testing return"
puts "Test 1:" [returnOne]
puts [+ [+ 1 2] [saveInterpreter "savefile.cont"] [+ 3 4] ]
#puts "Editing main.go"
#run vim main.go
#puts [loadfile "main.go"]
ls .
sayHello "Jeremy"
func map {func alist|
	if [eq [length alist] 0] {
		{"map end"}
        } else {
		cons [func [lindex alist 0]] [map func [lrange alist 1 end]]
	}
}

puts [dump [map {a| + 1 a} { 1 2 3 4 5}]]


func fold { func accum alist|
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


func CR {| chr 13 }
func LF {| chr 10 }


puts "Starting fold"
puts [fold {a b| seq [cons b a]} {"accumstart"} { 1 2 3 4 5 }]


func reverse {alist|
       fold {a b| seq [cons b a]} {} alist 
}


puts "Reversed: " [dump [reverse { a b c d } ]]

func countdown {n|
	puts n
	if [gt n 0] {
	       	countdown [- n 1]
	}
}

countdown 5

func thr {count threes|
	if [eq count threes] {
		puts "fizz"
		+ 3 threes
	} else {
		return threes 
	}
}

func fiv { count fives|
	if [eq count fives] {
		puts "buzz"
		+ 5 fives
	} else {
		return fives
	}
}

func do_fizzbuzz {count threes fives|
	if [and [eq count threes] [eq count fives]] {
		puts "fizzbuzz"
		do_fizzbuzz [+ 1 count ] [+ 3 threes] [+ 5 fives]
	} else {
		if [eq count threes] {
			puts "fizz"
			do_fizzbuzz [+ 1 count] [+ 3 threes] fives
		} else {
			if [eq count fives] {
				puts "buzz"
				do_fizzbuzz [+ 1 count] threes [+ 5 fives]
			} else {
				puts count
				do_fizzbuzz [+ 1 count] threes fives
			}
		}
	}
}

func fizzbuzz {| do_fizzbuzz 1 3 5}

#fizzbuzz

{a b c|
        puts c
        puts [+ a b]
     } 1 2 "Result:"

{a b c|
        puts c
        puts [+ a b]
     } 1 2 "Result:"


#Test that "dontreplace" contains the correct values after scope substitution
with {testscope} = { {dontreplace| puts dontreplace} } {
with {x y z dontreplace lambdacopy} = {1 2 3 fail testscope} {
	 puts "x:"  x  " y:"  y  " z:"  z
	 testscope "Scope working"
	 puts testscope "testscope"
	 lambdacopy "lambdacopy"
}
}

#Test evaluation in assignment block
with {sum} = {[+ 2 3]} {
	puts "Sum:" sum
}
