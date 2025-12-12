# Day 11 Part 2 of the Advent of Code 2025

package require Tcl 9-
namespace eval aoc {}
proc readfile {name} {
	set f [open $name]
	try {read $f} finally {close $f}
}

proc aoc::parse-data {data} {
	foreach line [split [string trim $data] \n] {
		lassign [split $line :] source destinations
		dict set states $source [split [string trim $destinations]]
	}
	return $states
}

# A node is relevant if it is both downstream of a source and upstream of a target
proc aoc::relevant-subset {states source target} {
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
proc aoc::follow-paths {states path target} {
	global cache; # Memoisation cache; assume one fundamental graph per run
	set count 0
	set me [lindex $path end]
	if {[info exists cache($me,$target)]} {
		return $cache($me,$target)
	}
	foreach next [dict getdef $states $me {}] {
		set path1 $path
		lappend path1 $next
		if {$next eq $target} {
			incr count
		} else {
			incr count [follow-paths $states $path1 $target]
		}
	}
	return [set cache($me,$target) $count]
}

proc aoc::problem {states {print 0}} {
	set rel [relevant-subset $states dac out]
	set dacout [follow-paths $rel dac out]
	if {$print} {puts "dac-out: [dict size $rel] -> $dacout"}
	set rel [relevant-subset $states fft dac]
	set fftdac [follow-paths $rel fft dac]
	if {$print} {puts "fft-dac: [dict size $rel] -> $fftdac"}
	set rel [relevant-subset $states svr fft]
	set svrfft [follow-paths $rel svr fft]
	if {$print} {puts "svr-fft: [dict size $rel] -> $svrfft"}

	set rel [relevant-subset $states fft out]
	set fftout [follow-paths $rel fft out]
	if {$print} {puts "fft-out: [dict size $rel] -> $fftout"}
	set rel [relevant-subset $states dac fft]
	set dacfft [follow-paths $rel dac fft]
	if {$print} {puts "dac-fft: [dict size $rel] -> $dacfft"}
	set rel [relevant-subset $states svr dac]
	set svrdac [follow-paths $rel svr dac]
	if {$print} {puts "svr-dac: [dict size $rel] -> $svrdac"}

	expr {$dacout * $fftdac * $svrfft + $fftout * $dacfft * $svrdac}
}

puts [aoc::problem [aoc::parse-data [readfile [lindex $argv 0]]] {*}[lrange $argv 1 end]]
