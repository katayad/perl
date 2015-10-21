package Local::PerlCourse::JSONL;

use JSON;
use DDP;

use Exporter 'import';	
@EXPORT_OK = qw(encode_jsonl decode_jsonl);

	our %trans;

	sub encode_jsonl
	{
		my @in = @{$_[0]};
		#p @in;
		my $ans;
		for $i (@in) {
			$ans .= JSON::to_json($i)."\n";
		}
		return $ans;
	}

	sub decode_jsonl
	{
		my @in = split("\n", $_[0]);
		#p @in;
		our @ans;
		for $i (@in) {
			push(@ans, JSON::from_json($i));
		}
		return \@ans;		
	}
1;