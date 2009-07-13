#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 6;

use Graph::Fastgraph;

my $g = new Graph::Fastgraph;

is($g->countedges()   , 0, "No edges");
is($g->countvertices(), 0, "No vertices");

# should create missing vertices
$g->addedge("A", "B", 5);
is($g->countedges(),    1, "One edge in graph");
is($g->countvertices(), 2, "Two vertices in graph");

# shouldn't duplicate
$g->addedge("A", "C", 3);
is($g->countedges(),    2, "Two edges in graph");
is($g->countvertices(), 3, "Three vertices in graph");

