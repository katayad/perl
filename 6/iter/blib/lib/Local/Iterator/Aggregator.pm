package Local::Iterator::Aggregator;
use base Local::Iterator;

use strict;
use warnings;
use Data::Dumper;

sub next {
	my ($class) = @_;

	my @ar;
	my ($next, $end, $i);
	for $i (1..$class->{chunk_length}) {
		($next, $end) = $class->{iterator}->next();
		if ($end) {
			if ($i != 1) {
				$end = 0;
			}
			last;
		}
		push @ar, $next;
	}
	if ($end == 1) {
		return (undef, 1);
	}
	return (\@ar, $end);
}



=encoding utf8

=head1 NAME

Local::Iterator::Aggregator - aggregator of iterator

=head1 SYNOPSIS

    my $iterator = Local::Iterator::Aggregator->new(
        chunk_length => 2,
        iterator => $another_iterator,
    );

=cut

1;
