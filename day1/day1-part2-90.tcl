# Day 1 Part 2 of the Advent of Code 2025

package require Tcl 9.0-

namespace eval aoc {namespace path ::tcl::mathop}
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc aoc::day1-part2 {contents} {
	set dial 50
	set zeroes 0
	foreach line [split $contents \n] {
		if {[scan $line {%[LR]%d} dir val] != 2} continue
		set nums [lseq $dial .. [incr dial [expr {$dir eq "L" ? -$val : $val}]]]
		incr zeroes [+ {*}[lmap n [lrange $nums 1 end] {expr {$n % 100 == 0}}]]
	}
	return $zeroes
}

puts [aoc::day1-part2 [readfile [lindex $argv 0]]]
