package Local::Iterator::File;

use strict;
use warnings;
use Data::Dumper;

sub new {
	my ($class, %params) = @_;
	$params{it} = 0;
	$params{end} = 0;
	if (defined $params{filename}) {
		open($params{fh}, "<", $params{filename});
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
sub all {
	my ($class) = @_;
	my $fh = $class->{fh};
	my @ans;
	while (<$fh>) {
		chomp $_;
		push @ans, $_;
	}
	return \@ans; 
}
sub DESTROY {
	my ($class) = @_;
	my $fh = $class->{fh};
	close($fh);
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
