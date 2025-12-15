# Day 8 Part 1 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc circuits {data connectionCount {maxCount 3}} {
	set coords [lmap line [split [string trim $data] \n] {split $line ,}]

	# Get the actions we'll be taking in the order we'll do them
	foreach i [lseq {[llength $coords] - 1}] {
		lassign [lindex $coords $i] x1 y1 z1
		foreach j [lseq {$i + 1} .. {[llength $coords] - 1}] {
			lassign [lindex $coords $j] x2 y2 z2
			lappend info $i $j [expr {sqrt(($x1-$x2)**2 + ($y1-$y2)**2 + ($z1-$z2)**2)}]
		}
	}
	set info [lsort -stride 3 -index 2 -real $info]

	# Union find algorithm

	set groups [lseq {[llength $coords]}]
	set uf [lseq {[llength $coords]}]
	# Now, make the $connectionCount shortest joins
	foreach {i j -} [lrange $info 0 [expr {$connectionCount * 3 - 1}]] {
		# Which groups are the candidates in?
		set ufi [lindex $uf $i]
		set ufj [lindex $uf $j]
		# If already the same group, skip
		if {$ufi == $ufj} continue
		# Determine the group leader
		set k [expr {min($ufi, $ufj)}]
		# Do the union
		set group [list {*}[lindex $groups $ufi] {*}[lindex $groups $ufj]]
		lset groups $k $group
		# Tell all group members what they're members of
		foreach item $group {lset uf $item $k}
	}

	# Convert each group into it's minimum form, get its length, and sort
	set sortedGroupLengths [lsort -decreasing -integer [lmap i [lsort -unique -integer $uf] {
		llength [lindex $groups $i]
	}]]
	tcl::mathop::* {*}[lrange $sortedGroupLengths 0 $maxCount-1]
}

puts [circuits [readfile [lindex $argv 0]] [lindex $argv 1]]
