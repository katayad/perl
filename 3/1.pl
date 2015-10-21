use DDP;
use Local::PerlCourse::JSONL qw(
	encode_jsonl
	decode_jsonl
	);

%h = (1 => "h1", 2 => "h2");
%hh = (1 => "h\nh1", 2 => "hh2");

@ar = (\%h, \%hh);
$array_ref = \@ar;


$string = encode_jsonl($array_ref);
$array_ref = decode_jsonl($string);

p $string;
p @{ $array_ref };