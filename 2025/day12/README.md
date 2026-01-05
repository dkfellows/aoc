# **Christmas Tree Farm** _aka_ **The Trees! NOT THE TREES!** 
It's a bit of a gift this one! In general, the problem is terribly difficult, but the actual problems aren't. Sorting the inputs into three piles works:
 1. The _trivially easy_ to pack (where the total area is more than large enough to hold the bounding boxes of the presents)
 2. The _trivially impossible_ to pack (where you clearly need more space than you actually have; pigeonhole principle, etc.)
 3. The _difficult_ cases (which happen to not actually turn up in the real input)

Also, a bit of work was needed to parse the input data. It's not difficult, but it's a bit more complex than most preceding days. (If doing this yourself, _split by paragraphs first_. Then you can parse each paragraph much more simply.)
## Code
* [`day12-part1.tcl` &mdash; The solution to the first part; a very basic sanity check](day12-part1.tcl)
* There is no Zuul. Or rather this one is passed by officially passing every other puzzle; no _direct_ code required.
## Data
* [the example data, in case you're mad enough to try it](day12-example.txt)
* [the actual presents and trees to process](day12.txt)
