use strict;
use warnings;
use Data::Dumper;
#use Test::More tests => 5;

local $\ = "\n";

use Iterator::Array;
use Iterator::Concater;

my $iterator = Local::Iterator::Concater->new(
    iterators => [
        Local::Iterator::Array->new(array => []),
        Local::Iterator::Array->new(array => [3, 4]),
        Local::Iterator::Array->new(array => []),
        Local::Iterator::Array->new(array => [7, 8])
    ],
);

my ($next, $end);

($next, $end) = $iterator->next();
print "$next $end";
#is($next, 1, 'next value');
#ok(!$end, 'not end');

print Dumper($iterator->all());

($next, $end) = $iterator->next();
print "$next $end";
#is($next, undef, 'no value');
#ok($end, 'end');
