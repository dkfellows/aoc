# Day 3 Part 1 of the Advent of Code 2025

package require Tcl 9.0-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

# The dumb method
proc max-joltage-battery {batteries} {
	set batteries [split $batteries ""]
	tcl::mathfunc::max {*}[lmap i [lseq {[llength $batteries] - 1}] {
		string cat [lindex $batteries $i] [tcl::mathfunc::max {*}[lrange $batteries [expr {$i + 1}] end]]
	}]
}

# Trivial lifting operation
proc sum-max-joltages-bank {bank} {
	tcl::mathop::+ {*}[lmap batt $bank {max-joltage-battery $batt}]
}

puts [sum-max-joltages-bank [readfile [lindex $argv 0]]]
