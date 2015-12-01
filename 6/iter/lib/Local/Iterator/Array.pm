package Local::Iterator::Array;

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
	if ($class->{it} >= scalar @{$class->{array}}) {
		return (undef, 1);
	}
	$class->{it} += 1;
	return ($class->{array}[$class->{it} - 1], 0); 
}
sub all {
	my ($class) = @_;

	my @ar = @{$class->{array}};
	@ar = @ar[$class->{it}..(scalar @ar - 1)];
	$class->{it} = scalar @{$class->{array}};
	return \@ar;
}
=encoding utf8

=head1 NAME

Local::Iterator::Array - array-based iterator

=head1 SYNOPSIS

    my $iterator = Local::Iterator::Array->new(array => [1, 2, 3]);

=cut

1;
