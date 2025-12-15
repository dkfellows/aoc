# Day 4 Part 1 of the Advent of Code 2025

package require Tcl 9.0-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}
proc prep-data {input} {
	lmap line [split [string trim $input] "\n"] {
		split [string trim $line] ""
	}
}

# Encodes whether a cell contains a removable roll of paper
proc movable-at {data x y} {
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
		incr count [expr {[lindex $data [expr {$x + $dx}] [expr {$y + $dy}]] eq "@"}]
	}
	return [expr {$count < 4}]
}

# Count how many removals of paper rolls are possible
proc count-movables {data} {
	set count 0
	foreach x [lseq {[llength $data]}] {
		foreach y [lseq {[llength [lindex $data $x]]}] {
			incr count [movable-at $data $x $y]
		}
	}
	return $count
}

puts [count-movables [prep-data [readfile [lindex $argv 0]]]]
