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

# Apply removals until there are no more, counting how many there are
proc count-iter-removed {data} {
	set count 0
	while 1 {
		# Find what to remove
		set toRemove {}
		foreach x [lseq [llength $data]] {
			foreach y [lseq [llength [lindex $data $x]]] {
				if {[movable-at $data $x $y]} {
					lappend toRemove $x $y
				}
			}
		}
		# Count and check if we're done
		incr count [llength $toRemove]
		if {![llength $toRemove]} break
		# Apply removals
		foreach {x y} $toRemove {
			lset data $x $y .
		}
	}
	return [expr {$count / 2}]
}

puts [count-iter-removed [prep-data [readfile [lindex $argv 0]]]]
