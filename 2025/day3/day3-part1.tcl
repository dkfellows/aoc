# Day 3 Part 1 of the Advent of Code 2025

package require Tcl 9.0-
namespace eval aoc {namespace path tcl::mathop}
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

# The dumb method
proc aoc::max-joltage-battery {batteries} {
	set nb [llength [set batteries [split $batteries ""]]]
	set max 0
	foreach i1 [lseq [llength $batteries]] {
		foreach i2 [lseq [expr {$i1 + 1}] .. [expr {$nb - 1}]] {
			set n [lindex $batteries $i1][lindex $batteries $i2]
			if {$n > $max} {set max $n}
		}
	}
	return $max
}

# Trivial lifting operation
proc aoc::sum-max-joltages-bank {bank} {
	+ {*}[lmap batt $bank {max-joltage-battery $batt}]
}

puts [aoc::sum-max-joltages-bank [readfile [lindex $argv 0]]]
