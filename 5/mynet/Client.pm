package Sfera::TCP::Calc::Client;

use strict;
use Data::Dumper;
use IO::Socket;
use Calc;

local $\ = "\n";

sub set_connect {
	my $pkg = shift;
	my $ip = shift;
	my $port = shift;

	my $server = IO::Socket::INET->new(
		PeerAddr => $ip,
		PeerPort => $port,
		Proto => "tcp",
		Type => SOCK_STREAM
	)
	or die " Client($$): Can`t connect to $ip $/";

	my $m = __getMsg($server);
	#my $m = "OK";
	if ($m eq "OK") { 
		warn " Client($$): connected to $ip";
	}
	else {
		die " Client($$): server $ip is busy"
	}

	return $server;
}

sub do_request {
	my ($pck, $server, $type, $msg) = @_;
	my $m = $msg;

	__sendMsg($server, $msg, $type);
	$msg = __getMsg($server);

	if ($m eq "END") {
		close($server);
	}

	return $msg;
}


sub __getMsg {
	my ($client) = shift;
	$client->recv(my $msg, 8);
	my ($type, $size) = Sfera::TCP::Calc->unpack_header($msg);
	$client->recv($msg, $size);

	return Sfera::TCP::Calc->unpack_message($msg);
}

sub __sendMsg {
	my ($client, $msg, $type) = @_;
	$msg = Sfera::TCP::Calc->pack_message($msg);
	$client->send(Sfera::TCP::Calc->pack_header($type, length $msg));
	$client->send($msg);
}

sub new
{
    my $class = shift;
    return bless {}, $class;
}
1;

