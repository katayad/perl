package Local::Iterator::Concater;

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

	if ($class->{it} >= scalar @{$class->{iterators}}) {
		return (undef, 1);
	}

	my $iterator = $class->{iterators}->[$class->{it}];
	my ($next, $end) = $iterator->next;
	if ($end) {
		$class->{it} += 1;
		return $class->next();
	}
	return ($next, $end); 
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

Local::Iterator::Concater - concater of other iterators

=head1 SYNOPSIS

    my $iterator = Local::Iterator::Concater->new(
        iterators => [
            $another_iterator1,
            $another_iterator2,
        ],
    );

=cut

1;
