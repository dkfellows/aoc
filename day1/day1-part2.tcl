# Day 1 Part 2 of the Advent of Code 2025

package require Tcl 8.6-

namespace eval aoc {}

proc aoc::day1-part2 {contents} {
	set ops {}
	foreach line [split $contents \n] {
		if {[scan $line {%[LR]%d} dir val] == 2} {
			lappend ops $dir $val
		}
	}

	set dial 50
	set zeroes 0
	foreach {dir val} $ops {
		set old $dial
		set dial [expr {$dial + ($dir eq "L" ? -$val : $val)}]
		# Do this one step at a time; ensures we handle edge cases!
		for {set n $dial} {$n != $old} {incr n [expr {$old < $dial ? -1 : 1}]} {
			incr zeroes [expr {$n % 100 == 0}]
		}
	}
	return $zeroes
}

set f [open [lindex $argv 0]]
set contents [read $f]
close $f
puts [aoc::day1-part2 $contents]
