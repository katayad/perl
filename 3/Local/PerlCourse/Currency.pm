package Local::PerlCourse::Currency;

	our %trans;

	sub set_rate
	{
		for ($i = 0; $i < $#_; $i += 2) {
			$trans{$_[$i]} = $_[$i + 1];
		}
	}
	sub AUTOLOAD {
		our $AUTOLOAD;
		my $pk = __PACKAGE__."::";
		$AUTOLOAD =~ s/$pk//;
		my @cur = split('_to_', $AUTOLOAD);
		return $_[0] * $trans{$cur[1]} / $trans{$cur[0]};
	}
1;