#!/usr/bin/env perl
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
	module_name => 'Graph::Fast',
	dist_author => 'Lars Stoltenow <penma.cpan@penma.de>',
	license     => 'unrestricted',
	recursive_test_files => 1,
);
$build->create_build_script;
