package Local::PerlCourse::GetterSetter;
use DDP;
use feature 'state';
$\ = "\n";

	sub import {
		$Local::SomePackage::test = sub {return 0;};

		$pack = caller;
		*{"$pack::GlobalModuleVar"};
		for $var (@_[1..$#_]) {
			no strict 'refs';

			${"$pack::GlobalModuleVar"} = "$pack::$var";
			$f = $pack."::set_".$var;

			*{$f} = sub {
				state $v = ${"$pack::GlobalModuleVar"};
				${$v} = @_[0];
			};
			$f->(${"$pack::$var"});

			$f = $pack."::get_".$var;
			*{$f} = sub {
				state $v = ${"$pack::GlobalModuleVar"};
				#print $v;
				return ${$v};
			};
			$f->();
		}
	}
1;