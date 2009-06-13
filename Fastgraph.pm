# vim:ft=perl
package Fastgraph;

use strict;
use warnings;

use PriorityList;

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
		$self->{vertices}->{$name} = {
			_name => $name,
			_edges => []
		};
	}
	return $self->{vertices}->{$name};
}

sub addedge {
	my ($self, $from, $to, $weight) = @_;
	my $v_from = $self->addvertex($from);
	my $v_to   = $self->addvertex($to);

	my $edge = {
		from   => $from,
		to     => $to,
		weight => $weight
	};

	push(@{$self->{edges}}, $edge);
	push(@{$v_from->{_edges}}, $edge);
	push(@{$v_to->{_edges}}, $edge);
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
	my $suboptimal = new PriorityList;
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
		foreach my $edge (grep { $_->{from} eq $current } @{$vert->{$current}->{_edges}}) {
			if (($dist{$edge->{to}} == $infinity) ||
			($dist{$edge->{to}} > ($dist{$current} + $edge->{weight}) )) {
				$suboptimal->update(
					$edge->{to},
					$dist{$edge->{to}} = $dist{$current} + $edge->{weight}
				);
			}
		}
	}

	# trace the path from the destination to the start
	my @path = ();
	my $current = $to;
	while ($current ne $from) {
		unshift(@path, $current);
		foreach my $edge (grep { $_->{to} eq $current } @{$vert->{$current}->{_edges}}) {
			if ($dist{$current} == $dist{$edge->{from}} + $edge->{weight}) {
				$current = $edge->{from};
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

