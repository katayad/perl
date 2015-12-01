package Sfera::TCP::Calc::Client;

use strict;
use Data::Dumper;
use IO::Socket;
use Sfera::TCP::Calc;

local $\ = "\n";


sub new
{
    my $class = shift;
    return bless {}, $class;
}

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
	return $server;
}

sub do_request {
	my $pck = shift;
	my $server = shift;
	my $type = shift;

	my $msg = Sfera::TCP::Calc->pack_message(shift);
 	$server->send(Sfera::TCP::Calc->pack_header($type, length $msg));
	$server->send($msg);

	$server->recv($msg, 8);

	my ($type, $size) = Sfera::TCP::Calc->unpack_header($msg);
	$server->recv($msg, $size);
	$msg = Sfera::TCP::Calc->pack_message($msg);
	#print "msg: $msg";
	return $msg;
}
sub closeConnection {
	#\close($server);
	print " CLient($$): stoped";
}
1;

