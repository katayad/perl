use JSON;
use DDP;
package Local::PerlCourse::JSON;

	our %trans;

	sub encode_json
	{
		my @in = @{$_[0]};
		#DDP::p @in;
		my $ans;
		for $i (@in) {
			$ans .= JSON::to_json($i)."\n";
		}
		return $ans;
	}

	sub decode_json
	{
		my @in = split('\n', $_[0]);
		our @ans;
		for $i (@in) {
			push(@ans, JSON::from_json($i));
		}
		return \@ans;		
	}
1;