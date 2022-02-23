#bits of srfi 1
#The classic lisp map

func sayHello { name |
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

func fold { f accum alist |
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

func reverse {alist |
       fold {a b| seq [cons b a]} {} alist 
}

#Add some useful definitions for control codes

func CR {| chr 13 }
func LF {| chr 10 }

func range_rec {start end step accum| if [gt start end] { return accum } else { range_rec [+ start step] end step [cons start accum] } }

#Generate a list
func range {start end step| reverse [range_rec start end step {} ] }

