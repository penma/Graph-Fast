#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 10;

use Graph::Fast;

my $g = Graph::Fast->new();

is($g->count_edges()   , 0, "No edges");
is($g->count_vertices(), 0, "No vertices");

# should create missing vertices
$g->add_edge("A", "B", 5);
is($g->count_edges(),    1, "One edge in graph");
is($g->count_vertices(), 2, "Two vertices in graph");

# shouldn't duplicate
$g->add_edge("A", "C", 3);
is($g->count_edges(),    2, "Two edges in graph");
is($g->count_vertices(), 3, "Three vertices in graph");

# delete a vertex
$g->del_vertex("B");
is($g->count_vertices(), 2, "Only two vertices left in graph");
is($g->count_edges(),    1, "Only one edge left in graph");

is($g->{edges}->[0]->{from}, "A", "Remaining edge comes from vertex A");
is($g->{edges}->[0]->{to}  , "C", "Remaining edge goes to vertex C");

