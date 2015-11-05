package Local::JSONPARSE;
use utf8;
use DDP;
use Data::Dumper;

use Encode qw(encode decode);

use warnings;
use strict;



use Exporter 'import';	
our @EXPORT_OK = qw(my_decode_json);

#----------------------------------------------------
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

$js = qr/ (?:[^{}]+ | \{ (??{ $js    }) \} )*  /x;
$str = qr/(?: [^"] | (?<=\\)")+/x;
#$num = qr/-?\d*\.?\d*/x;
$num = qr/([+-]?(?:\d+\.\d+|\d+\.|\.\d+|\d+))([eE]([+-]?\d+))?/;

$hasLastComma = qr/,\s*(?: \} | \] )\s*$/;
$key = qr/"$str"/x;
$value = qr/ (?: \{$js\} | \[$arr\] | "$str" | $num) /x;

$newJsonElement = qr/($key) \s* : \s* ($value) ,*/x;
$newArrElement = qr/($value) \s*,/x;

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

	local $SIG{ALRM} = sub { print "Timeout; just limit in case of error"; die };

	my $s = shift();
	if (!utf8::is_utf8($s)) {
		$s = decode("utf-8", $s);
	}
	
	alarm(3);

	if ($s =~ /^\s*\{($js)\}\s*$/)
	{
		$s = $1;
		my %ans;
		if (!($s =~ /$hasLastComma/)) {
			$s =~ s/\}\s*$/,\}/;
		}
		
		while ($s =~ /$newJsonElement/g) {
			my $cur1 = $1;
			my $cur2 = $2;

			stringCrutch(\$cur1);
			
			$ans{$cur1} = my_decode_json($cur2);
		}

		return \%ans;
	}
	
	if ($s =~ /\[($arr)\]/)
	{	
		my $arrRes = $1;
		if (!($arrRes =~ m/,\s*$/)) {
			$arrRes .= ",";
		}
		$s = $arrRes;
		my @ans;
		while ($s =~ /$newArrElement/g) {
			my $cur1 = $1;
			push @ans, my_decode_json($cur1);
		}
		return \@ans;
	}
	if ($s =~ m/"$str"/)
	{
		stringCrutch(\$s);
	}
	elsif ($s =~ /$num/) {
		$s = $1;
		if (defined $3) {
			$s *= 10 ** $3;
		}
		$s += 0;
	}
	else
	{
		print "!!!!!";
		return "";
	}
	return $s;
}
