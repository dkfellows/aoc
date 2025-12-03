package require Tcl 9
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

# The smart method; 12 is FAR TOO MANY for dumb
proc max-joltage-battery {batteries {select 12}} {
	set nb [llength [set b [split $batteries ""]]]
	set max {}
	set offset 0
	foreach pos [lseq $select] {
		# Find the earlist max value in the valid subrange window
		set maxv -1
		foreach i [lseq $offset .. [expr {$nb - $select + $pos}]] {
			set v [lindex $b $i]
			if {$v > $maxv} {
				set offset $i
				set maxv $v
			}
		}
		# Choose that value; definitely nothing else will be better
		append max [lindex $b $offset]
		incr offset
	}
	return $max
}

# Trivial lifting operation
proc max-joltage-bank {bank} {
	tcl::mathop::+ {*}[lmap batt $bank {max-joltage-battery $batt}]
}

puts [max-joltage-bank [readfile [lindex $argv 0]]]
