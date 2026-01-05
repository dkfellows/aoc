# **Movie Theater** _aka_ **The Cinema Tiles**
The tricky bit here is determining if a rectilinear line segment intersects with a rectangle; that's not too hard either... except there's a lot of coordinates about and many opportunities to make silly blunders.

The primary optimisation is knowing that "small" rectangles can be ignored without doing a line segment scan, turning a slow O(n<sup>3</sup>) task into a nearly O(n<sup>2</sup>) task in practice (it's still _technically_ O(n<sup>3</sup>) but would require extremely carefully crafted inputs to reach that; we don't have inputs like that).

Note that _all_ solutions today require Tcl 9.
## Code
* [`day9-part1.tcl` &mdash; The solution to the first part; simple max area](day9-part1.tcl)
* [`day9-part2.tcl` &mdash; The solution to the second part; max non-intersecting area](day9-part2.tcl)
## Data
* [the sample data from the first part](day9-example.txt)
* [the actual tile locations to process](day9.txt)
