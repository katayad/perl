package Local::SomePackage;

	sub AUTOLOAD {
		$\ = "\n";
		$s = $AUTOLOAD;
		my $pk = __PACKAGE__."::";
		$s =~ s/$pk//;
		@s = split("", $s);
		if ($s[0] eq 's') {
			$s = join "", @s[4..$#s];
			#print "1".$s;
			${ $s } = $_[0];
		}
		else {
			$s = join "", @s[4..$#s];
			#print "2".$s;
			return ${ $s };
		}
		#@in = $AUTOLOAD.split('_');
		#print $AUTOLOAD;
		
	}
1;