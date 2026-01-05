# **Lobby** _aka_ **The Battery Banks**
For the second part, note that there is, for the _N_'th battery, a _range of positions_ it could be located within (from just after the preceding battery to the location that leaves just enough batteries left for all remaining digits), that you want the _maximum_ value in that range, and that you also want the _earliest_ location with that maximum within the range (later equal values can be handled by the following digits). 

Note that _all_ solutions today require Tcl 9.
## Code
* [`day3-part1.tcl` &mdash; The solution to the first part; brute force and ignorance!](day3-part1.tcl)
* [`day3-part2.tcl` &mdash; The solution to the second part; smarter...](day3-part2.tcl)
## Data
* [the sample data from the first part](day3-example.txt)
* [the actual battery banks to process](day3.txt)
