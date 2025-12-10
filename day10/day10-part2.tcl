# Day 10 Part 2 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc parse-data {data} {
	lmap line [split [string trim $data] \n] {
		set indicators [string map {\[ "" \] "" . 0 # 1} [lindex $line 0]]
		binary scan [binary format B* [format %-032d [string reverse $indicators]]] I x
		set schematics [lmap s [lrange $line 1 end-1] {
			split [string trim $s ()] ,
		}]
		set joltages [split [lindex $line end] ,]
		list $indicators [string length $indicators] $x $schematics $joltages
	}
}

proc all-zero {joltages} {
	foreach j $joltages {
		if {$j} {return 0}
	}
	return 1
}

proc min-count-presses {schematics joltages n current} {
	if {$current eq $joltages} {return $n}
	incr n
	set minn inf
	set plans {}
	foreach s $schematics {
		set c $current
		foreach idx $s {lset c $idx [expr {[lindex $c $idx] + 1}]}
		set acceptable 1
		set dot 0
		foreach cx $c jx $joltages {
			incr dot [expr {$jx * $cx}]
			if {$cx > $jx} {
				set acceptable 0
				break
			}
		}
		if {!$acceptable} continue
		set dot [expr {$dot / [tcl::mathop::+ 0.0 {*}$c]}]
		lappend plans $c $dot
	}
	set plans [lsort -stride 2 -index 1 -real -decreasing $plans]
	foreach {c -} $plans {
		set candidate [min-count-presses $schematics $joltages $n $c]
		# GREEDY!
		if {$candidate > 0} {return $candidate}
	}
	return 0
}

proc problem {machines} {
	tcl::mathop::+ {*}[lmap m $machines {
		lassign $m - - - sch jol
		min-count-presses $sch $jol 0 [lrepeat [llength $jol] 0]
	}]
}

puts [problem [parse-data [readfile [lindex $argv 0]]]]
