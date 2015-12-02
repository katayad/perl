package Sfera::TCP::Calc::Server;

use strict;
use IO::Socket;
use Calc;
use POSIX ":sys_wait_h";
use Data::Dumper;

local $\ = "\n";

my $die = 0;
my @procs;
my $queries = 0;
my $connections = 0;
my $time;

$SIG{'USR1'} = sub {
	print "  {";
	print "    Current Connections: ".(scalar @procs);
	print "    Connections: $connections";
	print "    Queries: $queries";
	print "    Time since start: ".(time() - $time);
	print "  }";
};
$SIG{'INT'} = sub { $die = 1; die; }; 

$SIG{CHLD} = \&REAPER;

$SIG{'USR2'} = sub { 
	$queries++;
};


sub start_server {
	my $pkg = shift;
	my $port = shift;

	$time = time();
	
	my $server = IO::Socket::INET->new(
		LocalPort => $port,
		Type => SOCK_STREAM,
		ReuseAddr => 1,
		Listen => 10,
		)
	or die "Server($$):  Can't create server on port $port : $@ $/";

	print "Server($$): started on $port";

	while (!$die) {
		clearProcs();
		my $client = $server->accept();
		
		if (!(defined $client)) {
			print "      !!!!!!caught undef"
		}
		elsif (scalar @procs >= 1) {
			__sendMsg($client, "Server is Busy");
			close( $client );
		}
		else {
			__sendMsg($client, "OK");

			print "Server($$):  Someone connected";
			$connections++;
			my $pid = 0;
			if (!($pid = fork()))
			{
				child($client);
				print "Child($$):    died";
				close( $client );
				exit(1);
			}
			else {
				push @procs, $pid;
				close( $client );
			}
			
		}
		
	}
	close( $server );
	print "Server($$):  stoped";
}

sub child {
	my $client = shift;
	$client->autoflush(1);
	
	while ($client->connected) {
		
		my ($type, $msg) = __getMsg($client);
		
		if ($msg eq "END") {
			__sendMsg($client, "    Child($$):  got END");
			return;
		}

		if ($type == 1) { __sendMsg($client, Sfera::TCP::Calc->TYPE_CALC($msg)); }
		elsif ($type == 2) { __sendMsg($client, Sfera::TCP::Calc->TYPE_BRACKETCHECK($msg)); }
		elsif ($type == 3) { __sendMsg($client, Sfera::TCP::Calc->TYPE_NOTATION($msg)); }
		else { __sendMsg($client, "Unknown type"); }
		
		kill 'USR2', getppid(); 
	}
	#print "out";
}

sub REAPER {
    my $stiff;
    while (($stiff = waitpid(-1, &WNOHANG)) > 0) {
        # do something with $stiff if you want
    }
    $SIG{CHLD} = \&REAPER;                  # install *after* calling waitpid
}

sub clearProcs {
	for (my $i = 0; $i < scalar @procs; $i++) {
		my $exists = kill 0, $procs[$i];
		$exists = kill 0, $procs[$i];
		if ( !$exists ) {
			splice @procs, $i, 1;
			$i--;
		}
	}
}

sub __getMsg {
	my ($client) = shift;
	$client->recv(my $msg, 8);
	my ($type, $size) = Sfera::TCP::Calc->unpack_header($msg);
	$client->recv($msg, $size);

	return ($type, Sfera::TCP::Calc->unpack_message($msg));
}

sub __sendMsg {
	my ($client, $msg) = @_;
	$msg = Sfera::TCP::Calc->pack_message($msg);
	$client->send(Sfera::TCP::Calc->pack_header("1", length $msg));
	$client->send($msg);
}

sub new
{
    my $class = shift;
    return bless {}, $class;
}

1;

