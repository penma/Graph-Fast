# vim:ft=perl
# This file is (or was) preprocessed using GenerateFastgraph.PL.
# The input files can be found in the src/ directory of the distribution.
# The master file is called src/Fastgraph.xm
package Graph::Fastgraph;
our $VERSION = '0.00';

use strict;
use warnings;

use constant {
	EDGE_FROM => 0, EDGE_TO => 1, EDGE_WEIGHT => 2,
	VERT_NAME => 0, VERT_EDGES => 1,
};

use List::PriorityQueue;

# SUBS GO HERE

1;

