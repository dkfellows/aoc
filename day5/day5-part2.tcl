# Day 5 Part 2 of the Advent of Code 2025

package require Tcl 8.6-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

# Easiest to represent ranges as objects
oo::class create Range {
	variable from to
	constructor line {
		scan $line "%lld-%lld" from to
	}
	method from {} {return $from}
	method to {} {return $to}
	method length {} {expr {$to - $from + 1}}
	method contains val {expr {$val >= $from && $val <= $to}}
	method overlapping range {
		expr {!($from > [$range to] || $to < [$range from])}
	}
	method merge range {
		set from [expr {min($from, [$range from])}]
		set to [expr {max($to, [$range to])}]
		$range destroy
	}
}

proc parse-data {contents} {
	set state 0
	set freshRanges {}
	set items {}
	foreach line [split $contents \n] {
		if {$line eq ""} {
			incr state
		} elseif {$state == 0} {
			lappend freshRanges [Range new $line]
		} elseif {$state == 1} {
			lappend items $line
		}
	}
	return [list $freshRanges $items]
}

proc count-fresh {parsed} {
	lassign $parsed freshRanges items
	# Merge all the ranges; be careful, as adding a range can merge many previously distinct ones
	set known {}
	foreach fresh $freshRanges {
		foreach r $known[set known {}] {
			if {[$fresh overlapping $r]} {
				$fresh merge $r
			} else {
				lappend known $r
			}
		}
		lappend known $fresh
	}
	tcl::mathop::+ {*}[lmap range $known {$range length}]
}

puts [count-fresh [parse-data [readfile [lindex $argv 0]]]]
