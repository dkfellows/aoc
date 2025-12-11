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
	dict set downstream $source 1
	set this $source
	while {[llength $this]} {
		set nextlayer {}
		foreach item $this {
			set seen [dict getdef $states $item {}]
			lappend nextlayer {*}$seen
		}
		set nextlayer [lsort -unique $nextlayer]
		foreach next $nextlayer {
			dict set downstream $next 1
		}
		set this $nextlayer
	}

	# invert
	dict for {from to} $states {foreach to $to {dict lappend backward $to $from}}

	dict set upstream $target 1
	set this $target
	while {[llength $this]} {
		set nextlayer {}
		foreach item $this {
			set seen [dict getdef $backward $item {}]
			lappend nextlayer {*}$seen
		}
		set nextlayer [lsort -unique $nextlayer]
		foreach next $nextlayer {
			dict set upstream $next 1
		}
		set this $nextlayer
	}

	dict for {from to} $states {
		if {[dict exists $downstream $from] && [dict exists $upstream $from]} {
			dict set relevant $from $to
		}
	}

	return $relevant
}

# Classic graph follower for a NON-LOOPING graph
proc follow-paths {states path target} {
	set count 0
	foreach next [dict getdef $states [lindex $path end] {}] {
		set path1 $path
		lappend path1 $next
		if {$next eq $target} {
			incr count
		} else {
			incr count [follow-paths $states $path1 $target]
		}
	}
	return $count
}

proc problem {states {print 0}} {
	set rel [relevant-subset $states dac out]
	if {$print} {puts rel:[dict size $rel]}
	set dacout [follow-paths $rel dac out]
	if {$print} {puts "dac-out: $dacout"}
	set rel [relevant-subset $states fft dac]
	if {$print} {puts rel:[dict size $rel]}
	set fftdac [follow-paths $rel fft dac]
	if {$print} {puts "fft-dac: $fftdac"}
	set rel [relevant-subset $states svr fft]
	if {$print} {puts rel:[dict size $rel]}
	set svrfft [follow-paths $rel svr fft]
	if {$print} {puts "svr-fft: $svrfft"}
	expr {$dacout * $fftdac * $svrfft}
}

puts [problem [parse-data [readfile [lindex $argv 0]]] {*}[lrange $argv 1 end]]
