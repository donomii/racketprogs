puts "2 + 3"
set x [+ 2 3]
puts $x
puts [+ [+ 1 2] [saveInterpreter "savefile.cont"] [+ 3 4] ]
#puts "Editing main.go"
#run vim main.go
#puts [loadfile "main.go"]
ls .
