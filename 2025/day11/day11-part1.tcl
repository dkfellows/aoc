# Day 11 Part 1 of the Advent of Code 2025

package require Tcl 8.6-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc parse-data {data} {
	foreach line [split [string trim $data] \n] {
		lassign [split $line :] source destinations
		dict set states $source [split [string trim $destinations]]
	}
	return $states
}

# Classic graph follower for a NON-LOOPING graph
proc follow-paths {states {me you}} {
	if {$me eq "out"} {
		return 1
	}
	set count 0
	foreach next [dict get $states $me] {
		incr count [follow-paths $states $next]
	}
	return $count
}

puts [follow-paths [parse-data [readfile [lindex $argv 0]]]]
