use Server;
use Client;
use strict;
use warnings;

local $\ = "\n";

my $serverPid;
my @clientPid;

if (!($serverPid = fork())) {

    print " forked server! $$";
    my $server = Sfera::TCP::Calc::Server->new;

    $server->start_server("8097");
    
    exit(1);
}

for my $i (1..3) {
    if (!($clientPid[$i] = fork())) {
        #print " forked client! $$";
        sleep($i);
        my $client = Sfera::TCP::Calc::Client->new;
        my  $serv = $client->set_connect("127.0.0.1", "8097");
        if (!($serv->connected)) {
            exit(1);
        }
        sleep(2);
        print " Client($$):  ".$client->do_request($serv, 1, "$i");
        $client->do_request($serv, 1, "END");
        #$client->closeConnection();
        
        exit(1);
    }
}



sleep(10);

my $client = Sfera::TCP::Calc::Client->new;
my  $serv = $client->set_connect("127.0.0.1", "8097");
print " Client($$):  ".$client->do_request($serv, 1, "55");
$client->do_request($serv, 1, "END");
        #$client->closeConnection();
sleep(2);
print "Hello";
kill 'INT', $serverPid; 


=cut

waitpid($serverPid, 0);
waitpid($clientPid, 0);

print "test finished";

#print $a;