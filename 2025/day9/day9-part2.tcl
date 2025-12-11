# Day 9 Part 2 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc is-disjoint-segment {rx1 ry1 rx2 ry2 lx1 ly1 lx2 ly2} {
	# Is rectangle (rx1,ry1),(rx2,ry2) disjoint from line segment (lx1,ly1),(lx2,ly2)?
	# A line segment being on the edge of the rectangle counts as disjoint.

	# NB: Circuit uses only horizontal or vertical lines
	if {$lx1 == $lx2} {
		expr {
			$lx1 <= min($rx1,$rx2) || $lx1 >= max($rx1,$rx2) ||
			min($ly1,$ly2) >= max($ry1,$ry2) || max($ly1,$ly2) <= min($ry1,$ry2)
		}
	} else {
		expr {
			$ly1 <= min($ry1,$ry2) || $ly1 >= max($ry1,$ry2) ||
			min($lx1,$lx2) >= max($rx1,$rx2) || max($lx1,$lx2) <= min($rx1,$rx2)
		}
	}
}

proc is-disjoint {coords x1 y1 x2 y2} {
	# Is rectangle (x1,y1),(x2,y2) disjoint from all line segments?
	foreach idx [lseq [llength $coords]] {
		lassign [lindex $coords $idx] xx1 yy1
		lassign [lindex $coords [expr {($idx + 1) % [llength $coords]}]] xx2 yy2
		if {![is-disjoint-segment $x1 $y1 $x2 $y2 $xx1 $yy1 $xx2 $yy2]} {return false}
	}
	return true
}

proc max-area {data} {
	set coords [lmap line [split [string trim $data] \n] {split $line ,}]
	set max 0
	foreach a $coords idx [lseq [llength $coords]] {
		lassign $a x1 y1
		foreach b [lrange $coords $idx end] {
			lassign $b x2 y2
			set area [expr {(abs($x1-$x2)+1) * (abs($y1-$y2)+1)}]
			if {$area > $max} {
				if {[is-disjoint $coords $x1 $y1 $x2 $y2]} {
					set max $area
				}
			}
		}
	}
	return $max
}

puts [max-area [readfile [lindex $argv 0]]]
