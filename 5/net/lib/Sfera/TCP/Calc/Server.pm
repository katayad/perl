package Sfera::TCP::Calc::Server;

use strict;
use IO::Socket;
use Sfera::TCP::Calc;
use POSIX ":sys_wait_h";
use Data::Dumper;

local $\ = "\n";

my $die = 0;
my @procs;
my $queries = 0;
my $connections = 0;

$SIG{'USR1'} = sub {
	print "  {";
	print "    Current Connections: ".(scalar @procs);
	print "    Connections: $connections";
	print "    Queries: $queries";
	print "  }";
};
$SIG{'INT'} = sub { 
	
}; 

$SIG{CHLD} = \&REAPER;
sub REAPER {
    my $stiff;
    while (($stiff = waitpid(-1, &WNOHANG)) > 0) {
        # do something with $stiff if you want
    }
    $SIG{CHLD} = \&REAPER;                  # install *after* calling waitpid
}


sub new
{
    my $class = shift;
    
    return bless {}, $class;
}

sub clearProcs {
	for (my $i = 0; $i < scalar @procs; $i++) {
		#print "trying to kill, ".$procs[$i];
		my $exists = kill 0, $procs[$i];
		$exists = kill 0, $procs[$i];
		if ( !$exists ) {
			#print "trying to splice, ".$procs[$i];
			splice @procs, $i, 1;
			$i--;
		}
	}
}

sub start_server {
	my $pkg = shift;
	my $port = shift;
	
	my $server = IO::Socket::INET->new(
		LocalPort => $port,
		Type => SOCK_STREAM,
		ReuseAddr => 1,
		Listen => 5,
		)
	or die "Server($$):  Can't create server on port $port : $@ $/";

	while (!$die and my $client = $server->accept()) {
		clearProcs();
		
		
		if (!(defined $client)) {
			#print "      !!!!!!caught undef"
			last;
		}
		elsif (scalar @procs >= 5) {
			#print "Server($$):  Server is busy";
			close( $client );
		}
		else {
			#print "Server($$):  Someone connected";
			my $pid = 0;
			if (!($pid = fork()))
			{
				child($client);
				#print "Child($$):    died";
				exit(1);
			}
			elsif ($pid) {
				push @procs, $pid;
			}

			close( $client );
		}
		#print @procs;
		
	}
	close( $server );
	print "Server($$):  stoped";
}

sub child {
	$connections++;

	my $client = shift;
	$client->autoflush(1);
	
	
	while ($client->connected) {
		$client->recv(my $msg, 8);
		my ($type, $size) = Sfera::TCP::Calc->unpack_header($msg);
		$client->recv($msg, $size);

		$msg = Sfera::TCP::Calc->unpack_message($msg);
		
		if ($msg eq "END") {
			#print "Child($$):  got END";
			close( $client );
			last;
		}

		if ($type == 1) {
			$msg = Sfera::TCP::Calc->pack_message(Sfera::TCP::Calc->TYPE_CALC($msg));
		}
		elsif ($type == 2) {
			$msg = Sfera::TCP::Calc->pack_message(Sfera::TCP::Calc->TYPE_BRACKETCHECK($msg));
		}
		elsif ($type == 3) {
			$msg = Sfera::TCP::Calc->pack_message(Sfera::TCP::Calc->TYPE_NOTATION($msg));
		}
		else {
			$msg = Sfera::TCP::Calc->pack_message("Unknown type");
		}

		open(my $fh, ">>", "deb.txt");
		print $fh $type."\n";
		print $fh $msg."\n";
		print $fh "\n";
		close($fh);

		#print "Child($$):  sending $msg";
		$client->send(Sfera::TCP::Calc->pack_header($type, length $msg));
		$client->send($msg);
		$queries++;
	}
	
}

#start_server(undef, "8082");

1;

