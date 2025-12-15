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
		set schv [lmap s $schematics {tcl::mathop::| {*}[lmap n $s {expr {1 << $n}}]}]
		set joltages [split [lindex $line end] ,]
		list $indicators [string length $indicators] $x $schematics $schv $joltages
	}
}

#
# Solver based on https://github.com/RussellDash332/advent-of-code/blob/main/aoc-2025%2FDay-10%2FPython%2Fmain.py
#
# I hate writing complex solvers! Elegant pseudo-geometric methods don't work.
#

# First, some helpers for finding the minimum element of a list according to some auxiliary function
# including the case where the comparison is by way of an ordered pair.

proc cmp-pair {p1 p2} {
	lassign $p1 a1 b1
	lassign $p2 a2 b2
	expr {
		$a1 < $a2 || ($a1 == $a2 && $b1 < $b2)
	}
}

proc select-minimum-pair {values x keyscript} {
	upvar 1 $x val
	set min {inf inf}
	set mindex end
	foreach val $values i [lseq {[llength $values]}] {
		set v [uplevel 1 $keyscript]
		if {[cmp-pair $v $min]} {
			set min $v
			set mindex $i
		}
	}
	return $mindex
}

proc select-minimum {values x keyscript} {
	upvar 1 $x val
	set min inf
	set mindex end
	foreach val $values i [lseq {[llength $values]}] {
		set v [uplevel 1 $keyscript]
		if {$v < $min} {
			set min $v
			set mindex $i
		}
	}
	return $mindex
}

set EPS 1e-9

# A simplex solver, as an object for my ease of scope handling.
oo::class create Simplex {
	variable A C D B N m n

	method Pivot {r s} {
		set k [expr {1.0 / [lindex $D $r $s]}]
		foreach i [lseq {$m + 2}] {
			if {$i == $r} {
				continue
			}
			lset D $i [lmap dij [set di [lindex $D $i]] j [lseq {[llength $di]}] {expr {
				$j == $s ? $dij : $dij - [lindex $D $r $j] * [lindex $D $i $s] * $k
			}}]
		}
		lset D $r [lmap dri [lindex $D $r] {expr {$dri * $k}}]
		foreach i [lseq {$m + 2}] {
			lset D $i $s [expr {[lindex $D $i $s] * -$k}]
		}
		lset D $r $s $k
		# swap
		set tmp [lindex $B $r]
		lset B $r [lindex $N $s]
		lset N $s $tmp
	}

	method Find {p} {
		global EPS
        while 1 {
			set s [select-minimum-pair [lseq {$n + 1}] i {
				if {!$p && [lindex $N $i] == -1} {
					continue
				}
				list [lindex $D [expr {$m + $p}] $i] [lindex $N $i]
			}]
			if {[lindex $D [expr {$m + $p}] $s] > -$EPS} {
				return 1
			}
			set r [select-minimum-pair [lseq {$m}] i {
				if {[set dis [lindex $D $i $s]] <= $EPS} {
					continue
				}
				list [expr {[lindex $D $i end] / double($dis)}] [lindex $B $i]
			}]
			if {$r == -1} {
				return 0
			}
			my Pivot $r $s
		}
	}

	constructor {a c} {
		set A $a
		set C $c
		set m [llength $A]
		set n [expr {[llength [lindex $A 0]] - 1}]
		set N [list {*}[lseq {$n}] -1]
		set B [lseq {$n} count {$m}]
		set D [lmap i [lseq {$m}] {list {*}[lindex $A $i] -1}]
		lappend D [list {*}$C 0 0] [lrepeat [expr {$n + 2}] 0]

		foreach i [lseq {$m}] {
			# swap
			set tmp [lindex $D $i end-1]
			lset D $i end-1 [lindex $D $i end]
			lset D $i end $tmp
		}
	}

	method solve {} {
		global EPS
		lset D end $n 1
		set r [select-minimum [lseq {$m}] i {
			lindex $D $i end
		}]

		if {[lindex $D $r end] < -$EPS} {
			my Pivot $r $n
			if {![my Find 1] || [lindex $D end end] < -$EPS} {
				return {-inf {}}
			}
		}

		foreach i [lseq {$m}] {
			if {[lindex $B $i] == -1} {
				set k [select-minimum-pair [lseq {$n}] ii {
					list [lindex $D $i $ii] [lindex $N $ii]
				}]
				my Pivot $i $k
			}
		}

		if {![my Find 0]} {
			return {-inf {}}
		}

		set x [lrepeat $n 0]
		foreach i [lseq {$m}] {
			if {0 <= [lindex $B $i] && [lindex $B $i] < $n} {
				lset x [lindex $B $i] [lindex $D $i end]
			}
		}
		return [list [tcl::mathop::+ {*}[lmap cc $C xx $x {expr {$cc * $xx}}]] $x]
	}
}

# A simplex solver, as an object for my ease of scope handling.
# The input to the constructor is a suitably conditioned machine descriptor.
oo::class create MachineSolver {
	variable A n bval bsol

	constructor {a} {
		set A $a
		set n [expr {[llength [lindex $A 0]] - 1}]
		set bval inf
		set bsol {}
	}

	method Branch a {
		global EPS
		set simplex [Simplex new $a [lrepeat $n 1]]
		lassign [$simplex solve] val x
		$simplex destroy
        if {$val + $EPS >= $bval || $val == -inf} {
			return
		}

		foreach i [lseq {[llength $x]}] e $x {
			if {abs($e - round($e)) > $EPS} {
				set v [expr {int($e)}]
				set aa [list {*}$a [list {*}[lrepeat $n 0] $v]]
				lset aa end $i 1
				my Branch $aa
				lset aa end end [expr {~$v}]
				lset aa end $i -1
				my Branch $aa
				return
			}
		}
		if {$val + $EPS < $bval} {
			set bval $val
			set bsol [lmap xx $x {expr {round($xx)}}]
		}
	}

	method solve {} {
		my Branch $A
		return [expr {round($bval)}]
	}
}

# This handles conditioning the machine descriptor
proc solve-machine {m} {
	lassign $m - - - sch p jol
	set n [llength $jol]
	set A [lrepeat [expr {2 * $n + [llength $p]}] [lrepeat [expr {[llength $p] + 1}] 0]]
	foreach i [lseq {[llength $p]}] {
		lset A [expr {[llength $A] - $i - 1}] $i -1
		foreach e [lindex $sch $i] {
			lset A $e $i 1
			lset A [expr {$e + $n}] $i -1
		}
	}
	foreach i [lseq {$n}] j $jol {
		lset A $i end $j
		lset A [expr {$i + $n}] end [expr {-$j}]
	}
	set solver [MachineSolver new $A]
	try {
		return [$solver solve]
	} finally {
		$solver destroy
	}
}

# Extend everything over the whole problem set
proc problem {machines} {
	tcl::mathop::+ {*}[lmap m $machines {
		solve-machine $m
	}]
}

puts [problem [parse-data [readfile [lindex $argv 0]]]]
