# Day 4 Part 1 of the Advent of Code 2025

package require Tcl 9.0-
namespace eval aoc {namespace path tcl::mathop}
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc aoc::prep-data {input} {
	lmap line [split [string trim $input] "\n"] {
		split [string trim $line] ""
	}
}

# Encodes whether a cell contains a removable roll of paper
proc aoc::movable-at {data x y} {
	if {[lindex $data $x $y] ne "@"} {
		return 0
	}
	set count 0
	foreach {dx dy} {
		-1 -1  -1 0  -1 1
		 0 -1         0 1
		 1 -1   1 0   1 1
	} {
		# NB: out of bounds [lindex] gives an empty space
		incr count [eq [lindex $data [+ $x $dx] [+ $y $dy]] @]
	}
	return [expr {$count < 4}]
}

# Count how many removals of paper rolls are possible
proc aoc::count-movables {data} {
	set count 0
	foreach x [lseq [llength $data]] {
		foreach y [lseq [llength [lindex $data $x]]] {
			incr count [movable-at $data $x $y]
		}
	}
	return $count
}

puts [aoc::count-movables [aoc::prep-data [readfile [lindex $argv 0]]]]
