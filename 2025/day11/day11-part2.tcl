# Day 11 Part 2 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

oo::class create PathFollower {
	variable s src tgt cache

	# Find what states are reachable in a particular direction
	method Reachable {*table states start} {
		upvar 1 ${*table} table
		array default set table 0
		set table($start) 1
		set layer [list $start]
		while {[llength $layer]} {
			set nextlayer {}
			foreach item $layer {
				lappend nextlayer {*}[dict getdef $states $item {}]
			}
			set layer [lsort -unique $nextlayer]
			foreach next $layer {set table($next) 1}
		}
	}

	# A node is relevant if it is both downstream of a source and upstream of a target
	constructor {states source target} {
		set src $source
		set tgt $target
		array set cache {}; # Memoisation cache

		my Reachable downstream $states $source
		# invert the flow
		dict for {from to} $states {foreach to $to {dict lappend backward $to $from}}
		my Reachable upstream $backward $target

		# Remove all entries not both downstream and upstream marked to make working subgraph
		set s [dict map {from to} $states {
			if {$downstream($from) && $upstream($from)} {set to} continue
		}]
	}

	# Classic graph follower for a NON-LOOPING graph
	method Count-paths {me} {
		if {[info exists cache($me)]} {
			return $cache($me)
		}
		set cache($me) [tcl::mathop::+ {*}[lmap next [dict getdef $s $me {}] {
			expr {$next eq $tgt ? 1 : [my Count-paths $next]}
		}]]
	}
	method count-paths {} {
		tailcall my Count-paths $src
	}

	self method gc {} {
		foreach o [info class instances [self]] {$o destroy}
	}
}

proc problem {data} {
	foreach line [split [string trim $data] \n] {
		lassign [split $line :] source destinations
		dict set states $source [split [string trim $destinations]]
	}

	# Path could go in either order; compute both

	# Path: svr ---> fft ---> dac ---> out
	set svrfft [[PathFollower new $states svr fft] count-paths]
	set fftdac [[PathFollower new $states fft dac] count-paths]
	set dacout [[PathFollower new $states dac out] count-paths]

	# Path: svr ---> dac ---> fft ---> out
	set svrdac [[PathFollower new $states svr dac] count-paths]
	set dacfft [[PathFollower new $states dac fft] count-paths]
	set fftout [[PathFollower new $states fft out] count-paths]

	PathFollower gc

	return [expr {$dacout * $fftdac * $svrfft + $fftout * $dacfft * $svrdac}]
}

puts [problem [readfile [lindex $argv 0]]]
