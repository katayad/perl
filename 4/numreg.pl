local $\ = "\n";

$num1 = qr/-?\d*\.?\d*/x;
$num = qr/[+-]?(\d+\.\d+|\d+\.|\.\d+|\d+)([eE]([+-]?\d+))?/;

$n = '"scs" : 4e9';
$nn = '4';
$str = qr/(?: [^"] | (?<=\\)")+/x;


$new = qr/("$str") \s* : \s* $num/x;

	if ($nn =~ /$num/) {
		print "OK";
		
	}
	else {
		print "FAIL";
	}

	if ($n =~ /$new/) {
		print "OK";
		print $1;
		print $2;
		print $3;
		print $4;
	}
	else {
		print "FAIL2";
	}


