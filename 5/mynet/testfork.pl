

$a = 5;
$aAdr = \$a;
$$aAdr++;
if (!fork) {
	$$aAdr = 0;
	exit(1);
}
sleep(1);
print $$aAdr;
