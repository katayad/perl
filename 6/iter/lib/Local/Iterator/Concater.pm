package Local::Iterator::Concater;
use base Local::Iterator;

use strict;
use warnings;
use Data::Dumper;

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
