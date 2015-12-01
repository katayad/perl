use strict;
use warnings;

use Iterator::Array;
use Iterator::Aggregator;
use Data::Dumper;

my $iterator = Local::Iterator::Aggregator->new(
    iterator => Local::Iterator::Array->new(array => [1, 2, 3, 4, 5, 6, 7]),
    chunk_length => 2,
);

my ($next, $end);

($next, $end) = $iterator->next();
print Dumper($next);
print "$end\n";

print Dumper($iterator->all());

($next, $end) = $iterator->next();
print Dumper($next);
print "$end\n";
