# Day 1 Part 1 of the Advent of Code 2025

package require Tcl 8.6-

namespace eval aoc {}

proc aoc::day1-part1 {contents} {
	set ops {}
	foreach line [split $contents \n] {
		if {[scan $line {%[LR]%d} dir val] == 2} {
			lappend ops $dir $val
		}
	}

	set dial 50
	set zeroes 0
	foreach {dir val} $ops {
		set dial [expr {($dial + ($dir eq "L" ? -$val : $val)) % 100}]
		incr zeroes [expr {$dial == 0}]
	}
	return $zeroes
}

set f [open day1.txt]
set contents [read $f]
close $f
puts [aoc::day1-part1 $contents]
