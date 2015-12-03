package Sfera::TCP::Calc;
use DDP;
local $\ = "\n";
use Data::Dumper;

use strict;

sub TYPE_CALC {
	my $pkg = shift;
	my $x = shift();
	$x =~ s/\^/\*\*/g;

	return(eval($x));
}
sub TYPE_NOTATION {
	my $pkg = shift;
	my $x = shift();
	$x =~ s/\*\*/\^/g;
	$x =~ s/([\(\)\+\-\/\*\^])/ $1 /g;
	$x = $x.' |';
	my @l = split(' ', $x);

	for (my $i = 0; $i < $#l; $i++){
		if ($l[$i] eq '-' and ($l[$i - 1] =~ /(\+|-|\*|\/|\^|\()/ or $i == 0)) {
			$l[$i + 1] = '-'.$l[$i + 1];
			splice(@l, $i, 1);
			if ($l[$i] eq '-(') {
				splice(@l, $i, 1);
				splice(@l, $i, 0, '-1', '*', '(');
			}
		}
	}
	@l = reverse @l;

	my @Teh = ('|');
	my @Kal;
	my $cur;

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
			return "Fail";
			last;
		}
	}
	return join(' ', @Kal);
}
sub TYPE_BRACKETCHECK {
	my $pkg = shift;
	if (TYPE_NOTATION($pkg, shift()) == "Fail") {
		return 0;
	}
	return 1;
}

sub pack_header {
	my $pkg = shift;
	my $type = shift;
	my $size = shift;
	#my $ans = unpack "b8", $type;
	#$ans .= unpack "b16", $size;
	#print $ans;
	#return $ans;
	#print pack("i2", $type, $size);
	return pack("i2", $type, $size);
}

sub unpack_header {
	my $pkg = shift;
	my $header = shift;

	#print $header;
	#return pack("b8b16", $header);

	return unpack("i2", $header);
}

sub pack_message {
	my $pkg = shift;
	my $message = shift;
	my $ans = "";

	for my $ch (split //,$message ) {
		$ch = unpack "b*", $ch;
		$ans .= $ch;
	}
	return $ans;
}

sub unpack_message {
	my $pkg = shift;
	my $message = shift;
	my $ans = "";

	for my $ch (unpack ("(A8)*", $message) ) {
		$ans .= pack "b8", $ch;
	}
	return $ans;
}

1;

=head1 NAME
Calc - calculator