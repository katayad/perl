package PerlIO::via::Numerator;

use strict;
use Fcntl 'SEEK_CUR';
use Data::Dumper;

sub OPEN
{
    my ($obj, $name) = @_;

    if ($obj->{mode} eq ">>") {
        open(my $fh2, '<', $name);
        my $cnt = 1;
        open(my $fh2, '<', $name);
        
        while (<$fh2>) {
            $cnt++;
        }
        close($fh2);
        $obj->{cnt} = $cnt;
    }

    open(my $fh, $obj->{mode}, $name);
    $obj->{fh} = $fh;

    
}

sub PUSHED
{
    my ($class,$mode) = @_;
    my $obj = {fh => undef, mode => undef, cnt => 1};
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
    my $line = <$fh>;

    if (defined $line) {
        $line =~ s/^\d+\s//;
    }
    return $line;
}
sub WRITE
{
    my ($obj,$buf,$fh) = @_;
    $fh = $obj->{fh};
    
    if ($obj->{cnt} == 1)
    {
       $buf = "1 ".$buf;
       $obj->{cnt}++;
    }
    while ($buf =~ s/\n(?!\d+)/\n$obj->{cnt} /g) {
        $obj->{cnt}++;
    }   

    print $fh $buf;
    return length($buf);
}

sub SEEK 
{
    my ($obj, $posn, $whence, $fh) = @_;
    #print Dumper(\@_);
    $fh = $obj->{fh};
    #print tell $fh, "\n";
    #print "  ".$whence."\n";
    seek($fh, 0, $whence);
    #print tell $fh, "\n";

    if ($posn >= 0) {
        my $s;
        
        while ($posn) {
            my $begining = 0;
            if (tell $fh == 0) {
                $begining = 1;
            }
            read $fh, $s, 1;
            if ($s eq "\n" or $begining) {
                unless ($s eq " ") {
                    read $fh, $s, 1;
                }
            }
            else {
                $posn--;
            }
            
        }
    }
    else {
        my $s;
        my $lastSpace = -1;
        $posn *= -1;
        FSTART:
        while ($posn) {
            my $begining = 0;
            if (tell $fh == 0) {
                #print "d";
                return -1;
            }

            seek($fh, -1, 1);
            read $fh, $s, 1;
            seek($fh, -1, 1);
            #print " s = $s\n";

            if (tell $fh == 0) {
                $begining = 1;
            }

            if ($s eq " ") {
                $lastSpace = tell $fh;
            }

            if ($s eq "\n") {
                $posn += $lastSpace - (tell $fh) + 1;
            }
            else {
                $posn--;
            }
            #print "posn = $posn\n";
            
        }

        my $cur = tell $fh;
        my $s = ".";
        while ($s ne "\n" and $s ne " ") {
            my $begining = 0;
            if (tell $fh == 0) {
                #print "FUCKTHISSHIT";
                return -1;
            }

            seek($fh, -1, 1);
            read $fh, $s, 1;
            seek($fh, -1, 1);
        }
        if ($s eq " ") {
            seek($fh, $cur, 0);
        }
        else {
            #print ' !!\n';
            #print "$lastSpace - $cur + 1;";
            $posn += $lastSpace - $cur;
            goto FSTART;
        }
    }


    return 0;
}

1;