package Local::PerlCourse::JSONL;

use strict;
use warnings;

use JSON;
use DDP;

use Exporter 'import';	
our @EXPORT_OK = qw(encode_jsonl decode_jsonl);

	our %trans;

	sub encode_jsonl
	{
		my $ans;
		for my $i (@{$_[0]}) {
			$ans .= JSON::to_json($i)."\n";
		}
		return $ans;
	}

	sub decode_jsonl
	{
		my @in = split("\n", $_[0]);

		our @ans;
		for my $i (@in) {
			push(@ans, JSON::from_json($i));
		}
		return \@ans;		
	}
1;