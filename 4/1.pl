use Local::JSONPARSE qw(my_decode_json);
use Encode qw(encode decode);
use utf8;
use open ':std', ':encoding(UTF-8)';

use DDP;
use JSON;

use warnings;
use strict;

p my_decode_json('{
	"var1\u5315" : "ema\"mple☺",
	"var2" : ["3s", 5.9, ,-0.234],
	"var3" : {
				"b" : [1 , 2, [2, 4]] , 
				"c" : "a"
				},
	"var4" : [ {
				"d" : "d",
				"sdcv\"sd" : ["a\nnew line", "b"]
				}, 
				          2],
	"var5" : "{\"sdvsv\" : 5\n}aa"
}');

=c
my $fh;
open( $fh, '<', 'test.txt');

my $s;

while (<$fh>)
{
	$s .= $_;
}

print $s;

p my_decode_json($s);


=c


=cut

