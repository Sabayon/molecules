#!/usr/bin/perl

use Getopt::Std;
use Socket;

#my @HOSTNAME = ("host", "host");
#my @HOSTNAME = ("localhost", "localhost");
#my $PORTNO = "4242";
#my $PREFIX = "PREFIX";

sub funambol_udp_push {
	my $MSGTOSEND = shift;
	my @HOSTNAME = @{shift()};
	my $PORTNO = shift;
	my $PREFIX = shift;
	socket(SOCKET, PF_INET, SOCK_DGRAM, getprotobyname("udp")) or do{print "Cannot make a socket: $!\n"; exit(0); };

	for ($i = 0; $i <= $#HOSTNAME; $i++) {
		if ($portaddr = sockaddr_in($PORTNO, inet_aton($HOSTNAME[$i]))) {
			send(SOCKET, $MSGTOSEND, 0, $portaddr) == length($MSGTOSEND)
			or do{print "Cannot send to $HOSTNAME[$i]($PORTNO): $!\n";};
		}
	}
	return 0;
}

my %options = ();
getopts("f:d:h:p:P:",\%options);

my $MSG = $PREFIX.$options{d}.pack("c","04");
my @HOSTNAME = split(',', $options{h});
my $PORTNO = $options{p};
my $PREFIX = $options{P};

if (($PORTNO eq undef) or ($PREFIX eq undef) or ($MSG eq undef) or ($#HOSTNAME eq 0)) {
	print "bad arguments";
	print "PORTNO:".$PORTNO;
	print "PREFIX:".$PREFIX;
	print "MSG:".$MSG;
	for ($i = 0; $i <= $#HOSTNAME; $i++) {
		print "HOSTNAME[$i]:".$HOSTNAME[$i];
	}
	exit(1);
}

chop($MSG);

my $exitcode = funambol_udp_push($MSG, \@HOSTNAME, $PORTNO, $PREFIX);

if($exitcode eq 0){
	print "UDP Notification sent correctly.\n";
}

exit($exitcode);


