# Day 7 Part 1 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc beam-splitting-splits {data} {
	set manifold [lmap line [split [string trim $data] \n] {split $line ""}]
	# Whether there is a tachyon beam proceeding in a particular column
	set beams [lrepeat [llength [lindex $manifold 0]] no]
	set count 0
	foreach line $manifold {
		foreach col $line idx [lseq {[llength $line]}] {
			switch $col {
				S {
					lset beams $idx yes
				}
				^ {
					# If a beam hits a splitter, it's showtime!
					if {[lindex $beams $idx]} {
						lset beams $idx no
						lset beams [expr {$idx - 1}] yes
						lset beams [expr {$idx + 1}] yes
						incr count
					}
				}
			}
		}
	}
	return $count
}

puts [beam-splitting-splits [readfile [lindex $argv 0]]]
