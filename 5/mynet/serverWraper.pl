use Server;
local $\ = "\n";

my $server = Sfera::TCP::Calc::Server->new;
$server->start_server("8097");
    