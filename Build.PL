#!/usr/bin/env perl
use strict;
use warnings;
use Module::Build;

# to get a file with $VERSION
system("./GenerateFastgraph.PL");

my $build = Module::Build->new(
	module_name => 'Graph::Fastgraph',
	dist_author => 'Lars Stoltenow <penma.cpan@penma.de>',
	license     => 'unrestricted',
	PL_files    => { 'GenerateFastgraph.PL' => ['/nonexistant'] }, # to run this everytime
	recursive_test_files => 1,
);
$build->create_build_script;
