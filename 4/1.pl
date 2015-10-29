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

=t
#Dumper(JSON->new->decode
print Dumper(my_decode_json('{
	"var1\u5315" : "ema\"mple☺",
	"var2" : ["3s", 5.9, null, -0.234],
	"var3" : {
				"b" : [1 , 2, [2, 4]] , 
				"c" : "a"
				},
	"var4" : [ {
				"d" : "d",
				"sdcv\"sd" : ["a\nnew line", "b"]
				}, 
				          2],
	"var5" : "{\"sdvsv\" : 5}aa"
}'));

=cut


my $fh;
open( $fh, '<', 'test.txt');

my $s;

while (<$fh>)
{
	#chomp($_);
	$s .= $_;
}

#print $s;
my @tests = split 'SEPARATOR', $s;
#print Dumper(\@tests);


for my $test (@tests) {
	my %myans = %{my_decode_json($test)};
	my %ans = %{JSON->new->decode($test)};
	#print Dumper(\%ans1);
	#print Dumper(\%ans2);
	if (Compare(\%myans, \%ans)) {
		print "OK";
	}
	else {
		print "FAIL";
		print Dumper(\%myans);
		print Dumper(\%ans);
	}
}

