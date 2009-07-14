#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 11;

use Graph::Fastgraph;

my $g = new Graph::Fastgraph;

is($g->countedges()   , 0, "no edges");
is($g->countvertices(), 0, "no vertices");

# should create missing vertices
$g->addedge("A", "B", 5);
is($g->countedges(),    1, "one edge in graph");
is($g->countvertices(), 2, "two vertices in graph");

# shouldn't delete the vertices but just the edge
$g->deledge("A", "B");
is($g->countedges(),    0, "no edges in graph");
is($g->countvertices(), 2, "still two vertices in graph");

# recreate the edge and a second one in the opposite direction
# - it shouldn't be deleted.
$g->addedge("A", "B", 2);
$g->addedge("B", "A", 3);
$g->deledge("A", "B");
is($g->countedges(),    1, "one edge in graph");
is($g->countvertices(), 2, "two vertices in graph");
# for lack of a better interface, we peek into fastgraph's guts.
is($g->{edges}->[0]->[0], "B", "remaining edge's source vertex is B");
is($g->{edges}->[0]->[1], "A", "remaining edge's destination vertex is A");
is($g->{edges}->[0]->[2],  3 , "remaining edge's weight is 3");
