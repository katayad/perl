use Client;
use Data::Dumper;
local $\ = "\n";

my $client = Sfera::TCP::Calc::Client->new;
my $serv = $client->set_connect("127.0.0.1", "8097");
#print Dumper($serv);

print " Client($$):  ".$client->do_request($serv, 1, "1 + 2 * 3");

print " Client($$):  ".$client->do_request($serv, 2, "1 + 2 * 3");
print " Client($$):  ".$client->do_request($serv, 3, "1 + 2 * 3");
print " Client($$):  ".$client->do_request($serv, 3, "1 + 2 * 3");
print " Client($$):  ".$client->do_request($serv, 3, "1 + 2 * 3");
print " Client($$):  ".$client->do_request($serv, 3, "1 + 2 * 3");
print " Client($$):  ".$client->do_request($serv, 4, "1 + 2 * 3");
print " Client($$):  ".$client->do_request($serv, 4, "END");

#kill 'USR1', 12165; 