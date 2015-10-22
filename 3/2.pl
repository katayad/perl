use DDP;
use Local::PerlCourse::Currency qw(set_rate);

set_rate(#tubricks in dollar
	usd => 1,
	rur => 1.5,
	eur => 0.5,
	tub => 2
);

p Local::PerlCourse::Currency::eur_to_tub(10);
