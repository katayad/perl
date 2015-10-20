use DDP;
use Local::PerlCourse::Currency qw(set_rate);

Local::PerlCourse::Currency::set_rate(
	usd => 1,
	rur => 65.44,
	eur => 0.8
);

p Local::PerlCourse::Currency::rur_to_eur(67);
