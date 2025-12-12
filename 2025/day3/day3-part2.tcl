# Day 3 Part 2 of the Advent of Code 2025

package require Tcl 9.0-
namespace eval aoc {namespace path tcl::mathop}
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

# The smart method; 12 is FAR TOO MANY for dumb
proc aoc::max-joltage-battery {batteries {select 12}} {
	set nb [llength [set b [split $batteries ""]]]
	set max {}
	set offset 0
	foreach pos [lseq $select] {
		# Find the earlist max value in the valid subrange window
		set maxv -1
		foreach i [lseq $offset .. [expr {$nb - $select + $pos}]] {
			set v [lindex $b $i]
			if {$v > $maxv} {
				set offset $i
				set maxv $v
			}
		}
		# Choose that value; definitely nothing else will be better
		append max [lindex $b $offset]
		incr offset
	}
	return $max
}

# Trivial lifting operation
proc aoc::sum-max-joltages-bank {bank} {
	+ {*}[lmap batt $bank {max-joltage-battery $batt}]
}

puts [aoc::sum-max-joltages-bank [readfile [lindex $argv 0]]]
