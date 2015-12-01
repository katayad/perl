package Sfera::TCP::Calc::Client;

use strict;
use IO::Socket;
use Sfera::TCP::Calc;

use Data::Dumper;

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
	or die "Can`t connect to ipp: $ip $/";
}

sub do_request {
	my $pkg = shift;
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

1;

