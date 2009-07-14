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
			print "# line 1 \"src/$_\"\n";
			open(my $inc, "<", "src/$_");
			print while (<$inc>);
			close($inc);
		}
		print "# line $nextline \"src/Fastgraph.xm\"\n";
	} else {
		print;
	}
}

