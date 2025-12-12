# Day 10 Part 1 of the Advent of Code 2025

package require Tcl 9-
namespace eval aoc {namespace path tcl::mathop}
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc aoc::parse-data {data} {
	lmap line [split [string trim $data] \n] {
		set indicators [string map {\[ "" \] "" . 0 # 1} [lindex $line 0]]
		binary scan [binary format B* [format %-032d [string reverse $indicators]]] I x
		set schematics [lmap s [lrange $line 1 end-1] {
			| {*}[lmap n [split [string trim $s ()] ,] {expr {1<<$n}}]
		}]
		set joltages [split [lindex $line end] ,]
		list $indicators [string length $indicators] $x $schematics $joltages
	}
}

proc aoc::pick {n collection {picked {}} {first 0}} {
	if {$n < 1} {error "bad n: $n"}
	if {$first >= [llength $collection]} {return {}}
	if {$n == 1} {
		lmap i [lseq $first .. [expr {[llength $collection] - 1}]] {
			lmap j [list {*}$picked $i] {lindex $collection $j}
		}
	} else {
		incr n -1
		set result {}
		foreach i [lseq $first .. [expr {[llength $collection] - 1}]] {
			lappend result {*}[pick $n $collection [list {*}$picked $i] [expr {$i + 1}]]
		}
		return $result
	}
}

proc aoc::min-count-presses {machine} {
	lassign $machine is len tot sch jol
	foreach n [lseq 1 .. [llength $sch]] {
		foreach set [pick $n $sch] {
			if {[^ {*}$set] == $tot} {
				return $n
			}
		}
	}
	error "none possible: $machine"
}

proc aoc::problem {machines} {
	+ {*}[lmap m [parse-data $machines] {min-count-presses $m}]
}

puts [aoc::problem [readfile [lindex $argv 0]]]
