package Local::PerlCourse::Currency;

use strict;
use warnings;

use Exporter 'import';	
our @EXPORT_OK = qw(set_rate);
	
	my %trans = ();

	sub set_rate
	{
		%trans = (); #А нужно ли теперь очищать хеш при таком присвоении?
		%trans = @_;
	}
	sub AUTOLOAD {
		our $AUTOLOAD;
		my $pk = __PACKAGE__."::";
		$AUTOLOAD =~ s/$pk//;
		my @cur = split('_to_', $AUTOLOAD);

		die "No such currency \"${cur[0]}\"" if (!exists($trans{$cur[0]}));
		die "No such currency \"${cur[1]}\"" if (!exists($trans{$cur[1]}));

		return $_[0] * $trans{$cur[1]} / $trans{$cur[0]};
	}
1;