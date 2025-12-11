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
proc follow-paths {states {path you}} {
	set count 0
	foreach next [dict get $states [lindex $path end]] {
		if {$next eq "out"} {
			incr count
		} else {
			set path1 $path
			lappend path1 $next
			incr count [follow-paths $states $path1]
		}
	}
	return $count
}

puts [follow-paths [parse-data [readfile [lindex $argv 0]]]]
