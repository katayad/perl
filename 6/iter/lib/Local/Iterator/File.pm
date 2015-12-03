package Local::Iterator::File;
use base Local::Iterator;

use strict;
use warnings;
use Data::Dumper;

sub new { #Здесь, я так понимаю, большого смысла наследовать нет
	my ($class, %params) = @_;
	if (defined $params{filename}) {
		open($params{fh}, "<", $params{filename}) or die "$!";
	}
	return bless \%params, $class;
}

sub next {
	my ($class) = @_;
	my $fh = $class->{fh};
	my $line = <$fh>;
	if (!$line) {
		return (undef, 1);
	}
	chomp($line);
	return ($line, 0); 
}
sub DESTROY {
	my ($class) = @_;
	close($class->{fh});
}

=encoding utf8

=head1 NAME

Local::Iterator::File - file-based iterator

=head1 SYNOPSIS

    my $iterator1 = Local::Iterator::File->new(file => '/tmp/file');

    open(my $fh, '<', '/tmp/file2');
    my $iterator2 = Local::Iterator::File->new(fh => $fh);

=cut

1;
