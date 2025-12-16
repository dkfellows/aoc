# Day 9 Part 1 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc max-area {data} {
	set coords [lmap line [split [string trim $data] \n] {split $line ,}]
	tcl::mathfunc::max {*}[lmap a $coords {
		lassign $a x1 y1
		tcl::mathfunc::max {*}[lmap b $coords {
			lassign $b x2 y2
			expr {(abs($x1 - $x2) + 1) * (abs($y1 - $y2) + 1)}
		}]
	}]
}

puts [max-area [readfile [lindex $argv 0]]]
