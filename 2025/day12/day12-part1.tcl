# Day 12 Part 1 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc parse-data {data} {
	set paras [split [string map [list \n\n \u0000] $data] \u0000]
	foreach presentData [lrange $paras 0 end-1] {
		set lines [split [string trim $presentData] \n]
		set pIdx [string trim [lindex $lines 0] :]
		dict set presents $pIdx [lrange $lines 1 end]
	}
	foreach line [split [string trim [lindex $paras end]] \n] {
		scan [lindex $line 0] %dx%d: x y
		set selector {}
		foreach p [set ps [lrange $line 1 end]] i [lseq [llength $ps]] {
			foreach _ [lseq $p] {lappend selector $i}
		}
		lappend config $x $y $selector
	}
	return [list $presents $config]
}

# A basic check for sanity (claus)
proc check-basic-area {data} {
	lassign $data presents config
	set sizes [dict map {idx pdata} $presents {regexp -all # $pdata}]
	set basicPass 0
	foreach {x y selector} $config {
		incr basicPass [expr {
			[tcl::mathop::+ {*}[lmap idx $selector {
				dict get $sizes $idx
			}]] <= $x*$y
		}]
	}
	return $basicPass
}

puts [check-basic-area [parse-data [readfile [lindex $argv 0]]]]
