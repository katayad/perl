use DDP;
$\ = "\n";

my $x = <STDIN>;
$x =~ s/\^/\*\*/g;

print(eval($x));

$x =~ s/\*\*/\^/g;
$x =~ s/(\D)/ $1 /g;
$x = $x.' |';
my @l = split(' ', $x);

for (my $i = 0; $i < $#l; $i++){
	if ($l[$i] eq '-' and ($l[$i - 1] =~ /(\+|-|\*|\/|\^)/ or $i == 0)) {
		$l[$i + 1] = '-'.$l[$i + 1];
		splice(@l, $i, 1);
		if ($l[$i] eq '-(') {
			splice(@l, $i, 1);
			splice(@l, $i, 0, '-1', '*', '(');
		}
	}
}

@l = reverse @l;

my @Teh = ('|'), @Kal, $cur;

my @map = (
	#|  +  -  *  /  ^  (  )
	[4, 1, 1, 1, 1, 1, 1, 5], # |
	[2, 2, 2, 1, 1, 1, 1, 2], # +
	[2, 2, 2, 1, 1, 1, 1, 2], # -
	[2, 2, 2, 2, 2, 1, 1, 2], # *
	[2, 2, 2, 2, 2, 1, 1, 2], # /
	[2, 2, 2, 2, 2, 2, 1, 2], # ^
	[5, 1, 1, 1, 1, 1, 1, 3], # (
	) ;

my %trans = (
		'|' => 0,
		'+' => 1,
		'-' => 2,
		'*' => 3,
		'/' => 4,
		'^' => 5,
		'(' => 6,
		')' => 7
	);

sub Trans{
	if(exists($trans{$_[0]})) {
		return $trans{$_[0]};
	}
	return -1;
}

while (1) {
	$cur = $l[-1];
	my $num = $map[Trans($Teh[-1])][Trans($cur)];
	
	if (Trans($cur) == -1) {
		push(@Kal, pop(@l));
	}
	elsif ($num == 1) {
		push(@Teh, pop(@l));
	}
	elsif ($num == 2) {
		push(@Kal, pop(@Teh));
	}
	elsif ($num == 3) {
		pop(@Teh);
		pop(@l);
	}
	elsif ($num == 4) {
		last;
	}
	elsif ($num == 5) {
		print "Fail";
		last;
	}
}

print join(' ', @Kal);
