use Local::JSONPARSE qw(my_decode_json);
use Encode qw(encode decode);
use utf8;
use open ':std', ':encoding(UTF-8)';

use DDP;
use JSON;

use warnings;
use strict;

use Data::Dumper;
use Data::Compare;


my $fh;
open( $fh, '<', 'test.txt');
my $s;
while (<$fh>)
{
	$s .= $_;
}

my @tests = split 'SEPARATOR', $s;

for my $test (@tests) {
	my %myans = %{my_decode_json($test)};
	my %ans = %{JSON->new->decode($test)};
	
	if (Compare(\%myans, \%ans)) {
		print "OK";
	}
	else {
		print "FAIL";
		print Dumper(\%myans);
		print Dumper(\%ans);
	}
}

