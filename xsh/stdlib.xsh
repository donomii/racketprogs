#bits of srfi 1
#The classic lisp map

proc sayHello { name } {
	puts "Hello " name
}

proc map  { func alist } {
	if [eq [length alist] 1] {		
			return [func [lindex alist 0]]
        } else {
			cons [func [lindex alist 0]] [map func [lrange alist 1 end]]
	}
}

#The classic lisp map

proc fold { func accum alist } { 
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

proc reverse {alist} {
       fold {a b| seq [cons b a]} {} alist 
}

#Add some useful definitions for control codes

proc CR {} { chr 13 }
proc LF {} { chr 10 }

proc range_rec {start end step accum} { if [gt start end] { return accum } else { range_rec [+ start step] end step [cons start accum] } }

#Generate a list
proc range {start end step} { reverse [range_rec start end step {} ] }

