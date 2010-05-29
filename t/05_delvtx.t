#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 17;

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

# count edges in graph
is($g->count_vertices(), 2, "Only two vertices left in graph");
is($g->count_edges(),    1, "Only one edge left in graph");

is($g->{edges}->[0]->{from}, "A", "Remaining edge comes from vertex A");
is($g->{edges}->[0]->{to}  , "C", "Remaining edge goes to vertex C");

# count edges of A
is(scalar keys %{$g->{vertices}->{A}->{edges_in }}, 0, "No incoming edges as seen by A");
is(scalar keys %{$g->{vertices}->{A}->{edges_out}}, 1, "One outgoing edge as seen by A");
is((keys(%{$g->{vertices}->{A}->{edges_out}}))[0], "C", "A's only outgoing edge goes to C");

# count edges of C
is(scalar keys %{$g->{vertices}->{C}->{edges_out}}, 0, "No outgoing edges as seen by C");
is(scalar keys %{$g->{vertices}->{C}->{edges_in }}, 1, "One incoming edge as seen by C");
is((keys(%{$g->{vertices}->{C}->{edges_in}}))[0], "A", "C's only incoming edge comes from A");

# compare remaining edge for referential equality.
is($g->{vertices}->{A}->{edges_out}->{C}, $g->{edges}->[0], "Only remaining edge is same reference in both the graph's list and in A's list");
