# Day 6 Part 1 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc op-cols {data} {
	set lines [split [string trim $data \n] \n]
	set grandTotal 0
	foreach index [lseq {[llength [lindex $lines end]]}] {
		# Pick out the column of words
		set column [lmap line $lines {lindex $line $index}]
		# Get the op and apply it
		set op [lindex $column end]
		if {$op in {+ *}} {
			incr grandTotal [tcl::mathop::$op {*}[lrange $column 0 end-1]]
		}
	}
	return $grandTotal
}

puts [op-cols [readfile [lindex $argv 0]]]
