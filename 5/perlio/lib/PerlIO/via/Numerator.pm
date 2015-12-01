package PerlIO::via::Numerator;

use Fcntl 'SEEK_CUR';
use Data::Dumper;
use strict;
use warnings;

sub OPEN
{
    my ($obj, $name) = @_;

    $obj->{name} = $name;
    $obj->{it} = 0;
    $obj->{buf} = "";

    if ($obj->{mode} ne ">" and $obj->{mode} ne "+>") {
        my $cnt = 1;
        open(my $fh2, '<', $name);
        
        while (<$fh2>) {
            $_ =~ s/^\d+\s//;
            $obj->{buf} .= $_;
        }
        close($fh2);
    }

    if ($obj->{mode} eq ">>") {
        $obj->{it} = length $obj->{buf};
    }

    open(my $fh, $obj->{mode}, $name);
    $obj->{fh} = $fh;
}

sub PUSHED
{
    my ($class,$mode) = @_;
    my $obj = {fh => undef, mode => undef, buf => undef, it => undef, name => undef, cnt => 1};
    if ($mode eq 'w') {
        $obj->{mode} = '>';
    } 
    elsif ($mode eq 'r') {
        $obj->{mode} = '<';
    } 
    elsif ($mode eq 'w+') {
        $obj->{mode} = '+>';
    } 
    elsif ($mode eq 'r+') {
        $obj->{mode} = '+<';
    } 
    elsif ($mode eq 'a') {
        $obj->{mode} = '>>';
    } 
    else {
        die $mode." not supported in PerlIO::via::Numerator";
    }
    return bless $obj, $class;
}
sub FILL
{
    my ($obj,$fh) = @_;
    $fh = $obj->{fh};

    if ($obj->{cnt} and $obj->{it} < length $obj->{buf}) {

        my $in = index($obj->{buf}, "\n", $obj->{it});
        if ($in == -1) {
            $in = length $obj->{buf};
        }
        my $line = substr $obj->{buf}, $obj->{it}, $in  - $obj->{it} + 1;
        $obj->{it} += (length $line);

        if ($line eq "") {
            return undef;
        }
        return $line;
    }
    else {
        return undef;
    }
}
sub WRITE
{
    my ($obj,$buf,$fh) = @_;

    my $in = index($obj->{buf}, "\n", $obj->{it});
    if ($in == -1) {
        $in = length $obj->{buf};
    }
    elsif ($obj->{mode} eq ">") {
        $in++; #Erase newline
    }

    $obj->{buf} = substr($obj->{buf}, 0, $obj->{it}).$buf.substr($obj->{buf}, $in);
    
    $obj->{it} += length $buf;
    $buf = $obj->{buf};
    
    $buf = "1 ".$buf;
    my $cnt = 2;
    while ($buf =~ s/\n(?!\d+)/\n$cnt /) {
        $cnt++;
    }

    open(my $fh2, ">", $obj->{name});
    print $fh2 $buf;
    close($fh2);
    return length($buf);
}

sub SEEK 
{
    my ($obj, $posn, $whence, $fh) = @_;
    if ($whence == 0) {
        $obj->{it} = $posn;
    }
    elsif ($whence == 1) {
        $obj->{it} += $posn;
    }
    else {
        $obj->{it} = (length $obj->{buf}) + $posn;
    }
}

1;