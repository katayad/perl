package Local::Iterator::Aggregator;

use strict;
use warnings;
use Data::Dumper;

sub new {
	my ($class, %params) = @_;
	$params{it} = 0;
	return bless \%params, $class;
}

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

sub all {
	my ($class) = @_;

	my @ar;
	my ($next, $end) = $class->next();
	while (!$end) {
		push @ar, $next;
		($next, $end) = $class->next();
	}
	return \@ar;
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
