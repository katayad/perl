package Local::PerlCourse::GetterSetter;
use DDP;
use feature 'state';
$\ = "\n";

	sub import {

		$pack = caller;
		*{"$pack::GlobalModuleVar"};
		for $var (@_[1..$#_]) {
			no strict 'refs';

			*{"$pack::$var"};

			my $s = $var;

			$f = $pack."::set_".$var;
			*{$f} = sub {
				${"$pack::$s"} = @_[0];
			};

			$f = $pack."::get_".$var;
			*{$f} = sub {
				return ${"$pack::$s"};
			};
		}
	}
1;