# Day 9 Part 1 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc max-area {data} {
	set coords [lmap line [split [string trim $data] \n] {split $line ,}]
	set max 0
	foreach a $coords {
		lassign $a x1 y1
		foreach b $coords {
			lassign $b x2 y2
			set area [expr {(abs($x1-$x2)+1) * (abs($y1-$y2)+1)}]
			if {$area > $max} {set max $area}
		}
	}
	return $max
}

puts [max-area [readfile [lindex $argv 0]]]
