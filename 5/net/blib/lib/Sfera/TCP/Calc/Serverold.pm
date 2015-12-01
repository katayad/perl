package Sfera::TCP::Calc::Server;

use strict;
use IO::Socket;
use Sfera::TCP::Calc;

sub start_server {

	my $pkg = shift;
	my $port = shift;
	
	my $server = IO::Socket::INET->new(
		LocalPort => $port,
		Type => SOCK_STREAM,
		ReuseAddr => 1,
		Listen => 10
		)
	or die "Can't create server on port $port : $@ $/";

	print "hellovadvdfvadvd df df d ffa d faf af \n";

	my $cnt = 0;
	while (my $client = $server->accept()) {
		$cnt++;
		if ($cnt <= 5 && !fork())
		{
			$client->autoflush(1);
			$client->recv(my $msg, 8);
			

			my ($type, $size) = Sfera::TCP::Calc->unpack_header($msg);
			$client->recv($msg, $size);
			$msg = Sfera::TCP::Calc->unpack_message($msg);
			print "got: ".$msg;

			if ($type == 1) {
				$msg = Sfera::TCP::Calc->pack_message(Sfera::TCP::Calc->TYPE_CALC($msg));
			}
			elsif ($type == 2) {
				$msg = Sfera::TCP::Calc->pack_message(Sfera::TCP::Calc->TYPE_BRACKETCHECK($msg));
			}
			elsif ($type == 3) {
				#print "nuka".Sfera::TCP::Calc->TYPE_NOTATION($msg);
				$msg = Sfera::TCP::Calc->pack_message(Sfera::TCP::Calc->TYPE_NOTATION($msg));
			}
			$client->send(Sfera::TCP::Calc->pack_header($type, length $msg));
			$client->send($msg);
			exit(0);
		}

		close( $client );
		
	}
	
	close( $server );

	#init server
	#accept connection
	#fork
	#receive 
	#Sfera::TCP::Calc->unpack_header(...)
	#Sfera::TCP::Calc->unpack_message(...)
	#process
	#Sfera::TCP::Calc->pack_header(...)
	#Sfera::TCP::Calc->pack_message(...)
	#response
}


1;

