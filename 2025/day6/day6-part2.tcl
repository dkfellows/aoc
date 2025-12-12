# Day 6 Part 2 of the Advent of Code 2025

package require Tcl 9-
namespace eval aoc {namespace path {tcl::mathop tcl::mathfunc}}
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc aoc::op-cols {data} {
	set lines [split [string trim $data \n] \n]
	set grandTotal 0
	# Get line length, suspiciously
	set strlen [max {*}[lmap line $lines {string length $line}]]
	foreach index [lseq $strlen .. 0] {
		# Pick out the column of characters
		set column [lmap line $lines {string index $line $index}]
		# Empty columns reset for the next problem
		if {[string trim [join $column ""]] eq ""} {
			set current {}
			continue
		}
		# Collect the number from the column and extract the op
		lappend current [join [lrange $column 0 end-1] ""]
		set op [string trim [lindex $column end]]
		# If the op is real, apply it and collect the result
		if {$op in {+ *}} {
			incr grandTotal [$op {*}$current]
		}
	}
	return $grandTotal
}

puts [aoc::op-cols [readfile [lindex $argv 0]]]
