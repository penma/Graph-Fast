package Graph::Fastgraph;

use strict;
use warnings;

use constant {
	EDGE_FROM => 0, EDGE_TO => 1, EDGE_WEIGHT => 2,
	VERT_NAME => 0, VERT_EDGES => 1,
};

use List::PriorityQueue;

sub new {
	my ($class) = @_;
	return bless({
		vertices => {},
		edges => [],
	}, $class);
}

sub addvertex {
	my ($self, $name) = @_;

	if (!exists($self->{vertices}->{$name})) {
		$self->{vertices}->{$name} = [ $name, [] ];
	}
	return $self->{vertices}->{$name};
}

sub addedge {
	# my ($self, $from, $to, $weight) = @_;
	my $v = $_[0]->{vertices};
	my $v_from = $v->{$_[1]} // $_[0]->addvertex($_[1]);
	my $v_to   = $v->{$_[2]} // $_[0]->addvertex($_[2]);

	my $edge = [ $_[1], $_[2], $_[3] ];

	push(@{$_[0]->{edges}}, $edge);
	push(@{$v_from->[VERT_EDGES]}, $edge);
	push(@{$v_to->[VERT_EDGES]}, $edge);
}

sub dijkstra {
	my ($self, $from, $to) = @_;

	return undef if (!exists($self->{vertices}->{$to}));

	my $vert = $self->{vertices};
	my %dist;                       # distance from start node
	# nodes that have never been touched (where dist == infinity,
	# NOT nodes that just are not optimal yet.)
	my @unvisited = grep { $_ ne $from } keys(%{$vert});
	my $infinity = -1;
	my $suboptimal = new List::PriorityQueue;
	$suboptimal->insert($from, 0);

	$dist{$_} = $infinity foreach (@unvisited);
	$dist{$from} = 0;

	while (1) {
		# find the smallest unvisited node
		my $current = $suboptimal->pop();
		if (!defined($current)) {
			$current = pop(@unvisited);
		}
		last if (!defined($current));

		# update all neighbors
		foreach my $edge (grep { $_->[EDGE_FROM] eq $current } @{$vert->{$current}->[VERT_EDGES]}) {
			if (($dist{$edge->[EDGE_TO]} == $infinity) ||
			($dist{$edge->[EDGE_TO]} > ($dist{$current} + $edge->[EDGE_WEIGHT]) )) {
				$suboptimal->update(
					$edge->[EDGE_TO],
					$dist{$edge->[EDGE_TO]} = $dist{$current} + $edge->[EDGE_WEIGHT]
				);
			}
		}
	}

	# trace the path from the destination to the start
	my @path = ();
	my $current = $to;
	while ($current ne $from) {
		unshift(@path, $current);
		foreach my $edge (grep { $_->[EDGE_TO] eq $current } @{$vert->{$current}->[VERT_EDGES]}) {
			if ($dist{$current} == $dist{$edge->[EDGE_FROM]} + $edge->[EDGE_WEIGHT]) {
				$current = $edge->[EDGE_FROM];
				last;
			}
		}
	}
	unshift(@path, $from);

	return @path;
}

sub countvertices {
	my ($self) = @_;
	return scalar(keys(%{$self->{vertices}}));
}

sub countedges {
	my ($self) = @_;
	return scalar(@{$self->{edges}});
}

# Graph.pm compatiblity routines
*add_weighted_edge = \&addedge;

sub add_edge {
	$_[0]->addedge($_[1], $_[2], 1);
}

*SP_Dijkstra = \&dijkstra;

1;

__END__

=head1 NAME

Graph::Fastgraph - 

=head1 SYNOPSIS

 # todo

=head1 DESCRIPTION

This module does something weird. It's written in pure
Perl.

Available functions are:

=head2 B<new>()

Obvious.

=head2 B<unchecked_insert>(I<$payload>, I<$priority>)

=head2 B<unchecked_update>(I<$payload>, I<$new_priority>)

=head1 BUGS

Maybe.

=head1 SEE ALSO

=head1 AUTHORS & COPYRIGHTS

Made 2009 by Lars Stoltenow. No rights reserved. Do what the fuck you want.
(Credit is appreciated, though)

=cut
