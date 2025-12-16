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
		foreach p [set ps [lrange $line 1 end]] i [lseq {[llength $ps]}] {
			lappend selector {*}[lrepeat $p $i]
		}
		lappend config $x $y $selector
	}
	return [list $presents $config]
}

# A basic check for sanity (claus)
proc check-basic-area {data} {
	lassign $data presents config

	# Discover which configurations are trivially easy
	foreach present [dict values $presents] {
		lappend pxs [string length [lindex $present 0]]
		lappend pys [llength $present]
	}
	if {[llength [set pxs [lsort -unique -integer $pxs]]] != 1} {error "non-unique X size: $pxs"}
	set px [lindex $pxs 0]
	if {[llength [set pys [lsort -unique -integer $pys]]] != 1} {error "non-unique Y size: $pys"}
	set py [lindex $pys 0]
	set definitelySucceeded [lmap {x y selector} $config {
		if {[llength $selector] > ($x / $px) * ($y / $py)} continue
		string cat $x , $y
	}]

	# Discover which configurations are trivially impossible
	set sizes [dict map {idx pdata} $presents {regexp -all # $pdata}]
	set definitelyFailed [lmap {x y selector} $config {
		if {
			[tcl::mathop::+ {*}[lmap idx $selector {
				dict get $sizes $idx
			}]] <= $x*$y
		} continue
		string cat $x , $y
	}]

	# Tricky cases are ones that are neither trivial or impossible
	foreach {x y -} $config {dict set tricky $x,$y ok}
	foreach xy $definitelySucceeded {dict unset tricky $xy}
	foreach xy $definitelyFailed {dict unset tricky $xy}
	set tricky [dict keys $tricky]

	return easy:[llength $definitelySucceeded],impossible:[llength $definitelyFailed],tricky:[llength $tricky]
}

puts [check-basic-area [parse-data [readfile [lindex $argv 0]]]]
