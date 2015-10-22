use DDP;
use Local::PerlCourse::JSONL qw(
	encode_jsonl
	decode_jsonl
	);
use strict;
use warnings;

my %a = (1 => "ростест а1", 2 => [1, 2]);
my %b = (1 => "b1 \n test endl", 2 => "b2");

my @ar = (\%a, \%b);
my $array_ref = \@ar;


my $string = encode_jsonl($array_ref);
$array_ref = decode_jsonl($string);

p $string;
p @{ $array_ref };

print "TEST OK\n" if @{ $array_ref } eq @ar;