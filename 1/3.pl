use Data::Dumper;
use DDP;

while (<>) {
	chomp($_);
	push(@arr, [split(':', $_)]);
}

print Data::Dumper::Dumper(\@arr); 
p @arr
