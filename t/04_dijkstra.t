#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 7;

use Graph::Fastgraph;

my $g = new Graph::Fastgraph;

# if there's one possible path then that one should obviously be returned.
$g->addedge("A", "B", 5);
is_deeply([$g->dijkstra("A", "B")], ["A", "B"], "only one possible path returned");

# add a third, unrelated vertex. the path should not change.
$g->addedge("A", "C", 1);
is_deeply([$g->dijkstra("A", "B")], ["A", "B"], "correct path returned after adding unrelated vertex");

# add a second path from A to B, using D. this one is longer than the existing
# and shouldn't be used therefore.
$g->addedge("A", "D", 10);
$g->addedge("D", "B", 10);
is_deeply([$g->dijkstra("A", "B")], ["A", "B"], "shorter path returned even if there's a longer one");

# now add a third path over E that is faster.
$g->addedge("A", "E", 2);
$g->addedge("E", "B", 2);
is_deeply([$g->dijkstra("A", "B")], ["A", "E", "B"], "new shortest path taken");

# how about we go find a way between two nodes that are unreachable, due
# to directionality?
ok(!defined($g->dijkstra("B", "A")), "returns undef when there is no path");

# and between nodes that don't exist?
ok(!defined($g->dijkstra("B", "X")), "returns undef for unknown nodes pt. 1");
ok(!defined($g->dijkstra("X", "B")), "returns undef for unknown nodes pt. 2");
