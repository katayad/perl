package Local::Iterator::Array;
use base Local::Iterator;

use strict;
use warnings;
use Data::Dumper;

sub next {
	my ($class) = @_;
	if ($class->{it} >= scalar @{$class->{array}}) {
		return (undef, 1);
	}
	$class->{it} += 1;
	return ($class->{array}[$class->{it} - 1], 0); 
}

=encoding utf8

=head1 NAME

Local::Iterator::Array - array-based iterator

=head1 SYNOPSIS

    my $iterator = Local::Iterator::Array->new(array => [1, 2, 3]);

=cut

1;
