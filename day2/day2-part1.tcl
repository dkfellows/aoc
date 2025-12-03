# Day 2 Part 1 of the Advent of Code 2025

package require Tcl 9.0-
namespace eval aoc {}
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

# Doubled digit sequence test
proc aoc::is-invalid {id} {
	regexp {^(\d+)\1$} $id
}

proc aoc::invalids-range {range} {
	lassign [split [string trim $range] -] from to
	set result {}
	foreach n [lseq $from .. $to] {
		if {[is-invalid $n]} {
			lappend result $n
		}
	}
	return $result
}

proc aoc::invalids-sum {collection} {
	set total 0
	foreach range [split $collection ,] {
		incr total [tcl::mathop::+ {*}[invalids-range $range]]
	}
	return $total
}

puts [aoc::invalids-sum [readfile [lindex $argv 0]]]
