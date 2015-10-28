package Local::JSONPARSE;
use utf8;
use DDP;

use Perl::Unsafe::Signals;
use Encode qw(encode decode);

use warnings;
use strict;

$SIG{ALRM} = sub { print "Timeout; It seems the input is invalid"; die };

use Exporter 'import';	
our @EXPORT_OK = qw(my_decode_json);
$\ = "\n";
my $arr;
my $js;
my $str;
my $num;

my $hasLastComma;
my $key;
my $value;

my $newJsonElement;
my $newArrElement;

$arr = qr/ (?:[^\[\]]+ | \[ (??{ $arr }) \] )* /x;
#my $json = qr/^\s*\{[^p]*\}\s*$/;
$js = qr/ (?:[^{}]+ | \{ (??{ $js    }) \} )*  /x;
$str = qr/(?: [^"] | (?<=\\)")+/x;
$num = qr/-?\d*\.?\d*/x;

$hasLastComma = qr/,\s*(?: \} | \] )\s*$/;
$key = qr/"$str"/x;
$value = qr/ (?: \{$js\} | \[$arr\] | "$str" | $num) /x;

$newJsonElement = qr/($key) \s* : \s* ($value) ,*/x;
$newArrElement = qr/($value) \s*,/x;

my $t ='op';

my $temp = "ans";

sub stringCrutch
{
	if (${$_[0]} =~ m/"$str"/) {
		${$_[0]} =~ s/\"$//; 
		${$_[0]} =~ s/^\"//; 
		${$_[0]} =~ s/\\"/"/g;
		${$_[0]} =~ s/\\n/\n/g;
		${$_[0]} =~ s/\\u(....)/chr(hex($1))/eg;
	}
}

sub my_decode_json {
	my $s = shift();
	if (!utf8::is_utf8($s)) {
		$s = encode("utf-8", $s);
	}
	
	alarm(3);
	my $jsRes;
	"a" =~ /a/; 
    UNSAFE_SIGNALS {
		$s =~ /^\s*\{($js)\}\s*$/;
		$jsRes = $1;
	};
	if ($jsRes)
	{
		$s = $jsRes;
		my %ans;
		if (!($s =~ /$hasLastComma/)) {
			$s =~ s/\}\s*$/,\}/;
		}
		
		while ($s =~ /$newJsonElement/g) {
			my $cur1 = $1;
			my $cur2 = $2;
			stringCrutch(\$cur1);
			stringCrutch(\$cur2);
			
			$ans{$cur1} = my_decode_json($cur2);
		}

		return \%ans;
	}
	my $arrRes;
	"a" =~ /a/; 
	
	UNSAFE_SIGNALS {
		$s =~ /\[($arr)\]/;
		$arrRes = $1;
	};
	if ($arrRes)
	{	
		if (!($arrRes =~ m/,\s*$/)) {
			$arrRes .= ",";
		}
		$s = $arrRes;
		my @ans;
		while ($s =~ /$newArrElement/g) {
			my $cur1 = $1;
			stringCrutch(\$cur1);
			push @ans, my_decode_json($cur1);
		}
		return \@ans;
	}
	return $s;
}
