package PriorityList; # TODO: update doc, upload to cpan and change name. and make interface compatible with other mods.

use strict;
use warnings;

sub new {
	return bless {
		queue => [],
		prios => {},     # by payload
	}, shift();
}

sub pop {
	my ($self) = @_;
	if (@{$self->{queue}} == 0) {
		return undef;
	}
	delete($self->{prios}->{$self->{queue}->[0]});
	return shift(@{$self->{queue}});
}

sub insert {
	my ($self, $payload, $priority, $lower, $upper) = @_;
	$lower //= 0;
	$upper //= scalar(@{$self->{queue}}) - 1;

	# first of all, map the payload to the desired priority
	$self->{prios}->{$payload} = $priority;

	# And register the payload in the queue. There are a lot of special
	# cases that can be exploited to save us from doing the relatively
	# expensive binary search.

	# Special case: No items in the queue.  The queue IS the item.
	if (@{$self->{queue}} == 0) {
		push(@{$self->{queue}}, $payload);
		return;
	}

	# Special case: The new item belongs at the end of the queue.
	if ($priority >= $self->{prios}->{$self->{queue}->[-1]}) {
		push(@{$self->{queue}}, $payload);
		return;
	}

	# Special case: The new item belongs at the head of the queue.
	if ($priority < $self->{prios}->{$self->{queue}->[0]}) {
		unshift(@{$self->{queue}}, $payload);
		return;
	}

	# Special case: There are only two items in the queue.  This item
	# naturally belongs between them (as we have excluded the other
	# possible positions before)
	if (@{$self->{queue}} == 2) {
		splice(@{$self->{queue}}, 1, 0, $payload);
		return;
	}

	# And finally we have a nontrivial queue.  Insert the item using a
	# binary seek.
	my $midpoint;
	while (1) {
		$midpoint = ($upper + $lower) >> 1;

		# Upper and lower bounds crossed.  Insert at the lower point.
		if ($upper < $lower) {
			splice(@{$self->{queue}}, $lower, 0, $payload);
			return;
		}

		# We're looking for a priority lower than the one at the midpoint.
		# Set the new upper point to just before the midpoint.
		if ($priority < $self->{prios}->{$self->{queue}->[$midpoint]}) {
			$upper = $midpoint - 1;
			next;
		}

		# We're looking for a priority greater or equal to the one at the
		# midpoint.  The new lower bound is just after the midpoint.
		$lower = $midpoint + 1;
	}
}

sub find_payload_pos {
	my ($self, $payload) = @_;
	my $priority = $self->{prios}->{$payload};

	# Find the item with binary search.
	my $lower = 0;
	my $upper = @{$self->{queue}} - 1;
	my $midpoint;
	while (1) {
		$midpoint = ($upper + $lower) >> 1;

		# bounds crossed. the lower point is aimed at an element with
		# a higher priority than the target
		last if ($upper < $lower);

		# We're looking for a priority lower than the one at the midpoint.
		# Set the new upper point to just before the midpoint.
		if ($priority < $self->{prios}->{$self->{queue}->[$midpoint]}) {
			$upper = $midpoint - 1;
			next;
		}

		# We're looking for a priority greater or equal to the one at the
		# midpoint.  The new lower bound is just after the midpoint.
		$lower = $midpoint + 1;
	}

	# The lower index is now pointing to an element with a priority higher
	# than our target.  Scan backwards until we find the target.
	while ($lower-- >= 0) {
		return $lower if ($self->{queue}->[$lower] eq $payload);
	}
}

sub delete {
	my ($self, $payload) = @_;
	my $pos = $self->find_payload_pos($payload);

	delete($self->{prios}->{$payload});
	splice(@{$self->{queue}}, $pos, 1);

	return $pos;
}

sub update {
	my ($self, $payload, $new_prio) = @_;
	my $old_prio = $self->{prios}->{$payload};
	if (!defined($old_prio)) {
		$self->insert($payload, $new_prio);
		return;
	}

	# delete the old item
	my $old_pos = $self->delete($payload);

	# reinsert the item, limiting the range for the binary search (if needed)
	# a bit by checking how the priority changed.
	my ($upper, $lower);
	if ($new_prio - $old_prio > 0) {
		$upper = @{$self->{queue}};
		$lower = $old_pos;
	} else {
		$upper = $old_pos;
		$lower = 0;
	}
	$self->insert($payload, $new_prio, $lower, $upper);
}

1;

__END__

=head1 NAME

POE::Queue::Array - a high-performance array-based priority queue

=head1 SYNOPSIS

See L<POE::Queue>.

=head1 DESCRIPTION

This class is an implementation of the abstract POE::Queue interface.
As such, its documentation may be found in L<POE::Queue>.

POE::Queue::Array implements a priority queue using Perl arrays,
splice, and copious application of cleverness.

Despite its name, POE::Queue::Array may be used as a stand-alone
priority queue without the rest of POE.

=head1 SEE ALSO

L<POE>, L<POE::Queue>

=head1 BUGS

None known.

=head1 AUTHORS & COPYRIGHTS

Please see L<POE> for more information about authors, contributors,
and POE's licensing.

=cut
# TODO - Edit.
