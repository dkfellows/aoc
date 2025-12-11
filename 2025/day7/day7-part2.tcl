# Day 7 Part 1 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc beam-splitting-paths {data} {
	set manifold [lmap line [split [string trim $data] \n] {split $line ""}]
	# The number of (potential) tachyon beams proceeding in a particular column
	set beams [lrepeat [llength [lindex $manifold 0]] 0]
	foreach line $manifold {
		foreach col $line idx [lseq [llength $line]] {
			switch $col {
				S {
					lset beams $idx 1
				}
				^ {
					# If a beam hits a splitter, it's showtime!
					if {[set n [lindex $beams $idx]]} {
						lset beams $idx 0
						lset beams [expr {$idx - 1}] [expr {[lindex $beams [expr {$idx - 1}]] + $n}]
						lset beams [expr {$idx + 1}] [expr {[lindex $beams [expr {$idx + 1}]] + $n}]
					}
				}
			}
		}
	}
	return [tcl::mathop::+ {*}$beams]
}

puts [beam-splitting-paths [readfile [lindex $argv 0]]]
