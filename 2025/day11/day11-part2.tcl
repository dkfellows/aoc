# Day 11 Part 2 of the Advent of Code 2025

package require Tcl 9-
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc parse-data {data} {
	foreach line [split [string trim $data] \n] {
		lassign [split $line :] source destinations
		dict set states $source [split [string trim $destinations]]
	}
	return $states
}

# A node is relevant if it is both downstream of a source and upstream of a target
proc relevant-subset {states source target} {
	array default set downstream 0
	array default set upstream 0

	set downstream($source) 1
	set this $source
	while {[llength $this]} {
		set nextlayer {}
		foreach item $this {
			set seen [dict getdef $states $item {}]
			lappend nextlayer {*}$seen
		}
		set nextlayer [lsort -unique $nextlayer]
		foreach next $nextlayer {
			set downstream($next) 1
		}
		set this $nextlayer
	}

	# invert the flow
	dict for {from to} $states {foreach to $to {dict lappend backward $to $from}}

	set upstream($target) 1
	set this $target
	while {[llength $this]} {
		set nextlayer {}
		foreach item $this {
			set seen [dict getdef $backward $item {}]
			lappend nextlayer {*}$seen
		}
		set nextlayer [lsort -unique $nextlayer]
		foreach next $nextlayer {
			set upstream($next) 1
		}
		set this $nextlayer
	}

	# Remove all entries not both downstream and upstream marked
	dict map {from to} $states {
		if {!$downstream($from) || !$upstream($from)} continue
		set to
	}
}

# Classic graph follower for a NON-LOOPING graph
proc follow-paths {states me target} {
	global cache; # Memoisation cache; assume one fundamental graph per run
	set count 0
	if {[info exists cache($me,$target)]} {
		return $cache($me,$target)
	}
	foreach next [dict getdef $states $me {}] {
		if {$next eq $target} {
			incr count
		} else {
			incr count [follow-paths $states $next $target]
		}
	}
	return [set cache($me,$target) $count]
}

proc problem {states {print 0}} {
	# Calculations for svr -> fft -> dac -> out
	set svrfft [follow-paths [relevant-subset $states svr fft] svr fft]
	set fftdac [follow-paths [relevant-subset $states fft dac] fft dac]
	set dacout [follow-paths [relevant-subset $states dac out] dac out]

	# Calculations for svr -> dac -> fft -> out
	set svrdac [follow-paths [relevant-subset $states svr dac] svr dac]
	set dacfft [follow-paths [relevant-subset $states dac fft] dac fft]
	set fftout [follow-paths [relevant-subset $states fft out] fft out]

	# Combine into final result
	expr {$dacout * $fftdac * $svrfft + $fftout * $dacfft * $svrdac}
}

puts [problem [parse-data [readfile [lindex $argv 0]]] {*}[lrange $argv 1 end]]
