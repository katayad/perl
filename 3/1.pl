use JSON;
use DDP;
use Local::PerlCourse::JSONL qw(
	encode_jsonl
	decode_jsonl
);

%h = (1 => 'dsd', 2 => 'aaaaa');
%hh = (1 => '34', 2 => 'bb');
@ar = (\%h, \%hh);
$s = Local::PerlCourse::JSON::encode_json(\@ar);
p $s;
$sd = "-------------";
p $sd;
p Local::PerlCourse::JSON::decode_json($s);
#Local::PerlCourse::JSON::encode_json(\@ar);
#$string = encode_jsonl($array_ref);
#$array_ref = decode_jsonl($string);