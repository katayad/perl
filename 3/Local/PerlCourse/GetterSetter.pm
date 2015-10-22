package Local::PerlCourse::GetterSetter;
use DDP;
use strict;
use warnings;
$\ = "\n";

	sub import {
		my $pack = caller;

		for my $var (@_[1..$#_]) {
			no strict 'refs';

			my $s = $var;

			my $f = "${pack}::set_${var}";
			*{$f} = sub {
				${"${pack}::${s}"} = $_[0];
			};

			$f = "${pack}::get_${var}";
			*{$f} = sub {
				return ${"${pack}::${s}"};
			};
		}
	}
1;