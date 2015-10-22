package Local::SomePackage;
use DDP;
use Local::PerlCourse::GetterSetter qw(x y z f);
$\ = "\n";

set_x(50);
print $Local::SomePackage::x; # 50
our $y = 42;
print get_y(); # 42
set_y(11);
set_f(3);
print get_y(); # 11