use DDP;
use Local::PerlCourse::JSONL qw(
	encode_jsonl
	decode_jsonl
	);

%a = (1 => "ростест а1", 2 => "a2");
%b = (1 => "b1 \n test endl", 2 => "b2");

@ar = (\%a, \%b);
$array_ref = \@ar;


$string = encode_jsonl($array_ref);
$array_ref = decode_jsonl($string);

p $string;
p @{ $array_ref };

print "TEST OK\n" if @{ $array_ref } eq @ar;