#bits of srfi 1
#The classic lisp map

proc sayHello { name } {
	puts "Hello " name
}

func map  { f alist |
	if [eq [length alist] 1] {		
			return [f [lindex alist 0]]
        } else {
			cons [f [lindex alist 0]] [map f [lrange alist 1 end]]
	}
}

#The classic lisp map

proc fold { f accum alist } { 
	if [eq [length alist] 0] {
		accum
        } else {
		if [eq [length alist] 1] {
			f accum [lindex alist 0]
		} else {
			fold f [f accum [lindex alist 0]] [lrange alist 1 end]
		}
	}
}

proc reverse {alist} {
       fold {a b| seq [cons b a]} {} alist 
}

#Add some useful definitions for control codes

proc CR {} { chr 13 }
proc LF {} { chr 10 }

proc range_rec {start end step accum} { if [gt start end] { return accum } else { range_rec [+ start step] end step [cons start accum] } }

#Generate a list
proc range {start end step} { reverse [range_rec start end step {} ] }

