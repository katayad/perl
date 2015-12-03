package Local::Iterator;

use strict;
use warnings;

sub new {
	my ($class, %params) = @_;
	$params{it} = 0;
	return bless \%params, $class;
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

Local::Iterator - base abstract iterator

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

1;
