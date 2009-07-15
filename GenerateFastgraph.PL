#!/usr/bin/perl
use strict;
use warnings;

open(my $master, "<", "src/Fastgraph.xm");
open(STDOUT, ">", "lib/Graph/Fastgraph.pm");
while (<$master>) {
	if ($_ =~ /^# SUBS GO HERE/) {
		my $nextline = $. + 1;
		opendir(my $dir, "src");
		foreach (grep { /\.xf$/ } readdir($dir)) {
			if ($ENV{FASTGRAPH_DEBUG} eq "1") {
				print "# line 1 \"src/$_\"\n";
			} else {
				print "# line 1 \"src/$_ (Graph::Fastgraph)\"\n";
			}
			open(my $inc, "<", "src/$_");
			print while (<$inc>);
			close($inc);
		}
		print "# line $nextline \"src/Fastgraph.xm\"\n";
	} else {
		print;
	}
}

