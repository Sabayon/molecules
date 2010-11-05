#!/usr/bin/perl
# author rgiannetto@babel.it, rpolli@babel.it
#
# create the ldif file used to initialize Fedora Directory Server 
# with Mailware Collaboration Suite
#
# specify by command line the following arguments:
#  first administator domain (ex. babel.it )
#  dn          (the base dn ex. $dn)
#  username	- the username of the SA
#  password	- the password of the SA
#  aisle	- the name of the mail aisle 
use Getopt::Std;
our %opt;
our $domain, $dn, $user, $password, $isola, $addressbooks, $mailAlternateAddress;

my $numArgs = $#ARGV + 1;

if($numArgs < 10) {
	printf(STDERR "Usage: mcs-ldapinit.pl -d [dominio] -b [basedn] -s [sa user] -p [sa password] -a [aisle name] [-B addressbook basedn ] [-f output file]]\n");
 printf(STDERR "
  specify by command line the following arguments:
  -d first administator domain (ex. babel.it )
  -b dn          (the base dn ex. $dn)
  -s username     - the username of the SA
  -p password     - the password of the SA
  -a aisle        - the name of the mail aisle
  -B \"db1,db2\" - the databases to create under your server
  -f filename.ldif - the output file

  EXAMPLE:
	# mcs-ldapinit.pl babel.it \"$dn\" sa secret node1 -f base.ldif
	# ldapmodify -a -D \"cn=directory manager\" -W -f base.ldif
");
	exit(0);
}
getopts('vd:b:s:p:a:B:f:', \%opt);  # options as above. Values in %opts
$domain = $opt{'d'};
$dn =$opt{'b'};
$user = $opt{'s'};
$password = $opt{'p'};
$isola = $opt{'a'};
$addressbooks = $opt{'B'};
$mailAlternateAddress = $opt{'m'};
$ldifFileName = $opt{'f'};

if ($opt{'v'}) {
  print STDERR "parameters $domain\n$dn\n$user\n$password\n$isola\n$addressbooks\n";
}

sub create_calendar_ldif() {
  open (FH, ">>$ldifFileName")
	 or  die("Cannot create $ldifFileName: ".$!);

  printf(FH "dn: uid=caladmin,ou=People,$dn\n");
  printf(FH "changetype: add\n");
  printf(FH "businessCategory: sa\n");
  printf(FH "userPassword: $password\n");
  printf(FH "mail: caladmin\n");
  printf(FH "uid: caladmin\n");
  printf(FH "givenName: caladmin\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: person\n");
  printf(FH "objectClass: organizationalPerson\n");
  printf(FH "objectClass: inetorgperson\n");
  printf(FH "objectClass: mailrecipient\n");
  printf(FH "objectClass: babmware\n");
  printf(FH "objectClass: babmwcompany\n");
  printf(FH "sn: caladmin\n");
  printf(FH "cn: caladmin caladmin\n");
  printf(FH "\n");
  printf(FH "\n");
  printf(FH "dn: uid=public-user,ou=People,$dn\n");
  printf(FH "changetype: add\n");
  printf(FH "mail: public-user\n");
  printf(FH "uid: public-user\n");
  printf(FH "givenName: public\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: person\n");
  printf(FH "objectClass: organizationalPerson\n");
  printf(FH "objectClass: inetorgperson\n");
  printf(FH "sn: user\n");
  printf(FH "cn: public user\n");
  printf(FH "\n");
  printf(FH "dn: uid=realtime01,ou=People,$dn\n");
  printf(FH "changetype: add\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: person\n");
  printf(FH "objectClass: organizationalPerson\n");
  printf(FH "objectClass: inetOrgPerson\n");
  printf(FH "objectClass: babmwcompany\n");
  printf(FH "mail: realtime01\n");
  printf(FH "givenName: realtime01\n");
  printf(FH "uid: realtime01\n");
  printf(FH "sn: realtime01\n");
  printf(FH "cn: realtime01\n");
  printf(FH "businessCategory: sa\n");
  printf(FH "\n");

  close(FH);
}

sub create_ldif() {
  open (FH, ">$ldifFileName")
	 or  die("Cannot create $ldifFileName: ".$!);
  printf(FH "# Service Administrators \n");
  printf(FH "#  the tree of the MCS administration\n");
  printf(FH "dn: ou=Service Administrators,$dn\n");
  printf(FH "changetype: add\n");
  printf(FH "description: Tree containing all Service Administrators\n");
  printf(FH "ou: Service Administrators\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: organizationalunit\n");
  printf(FH "\n");

  printf(FH "# The first administrator\n");
  printf(FH "# $user, Service Administrators, $domain\n");
  printf(FH "dn: uid=$user,ou=Service Administrators,$dn\n");
  printf(FH "changetype: add\n");
  printf(FH "mail: $user\@$domain\n");
  printf(FH "uid: $user\n");
  printf(FH "givenName: Service\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: person\n");
  printf(FH "objectClass: organizationalPerson\n");
  printf(FH "objectClass: inetorgperson\n");
  printf(FH "objectClass: babmwcompany\n");
  printf(FH "sn: Administrator\n");
  printf(FH "cn: Service Administrator\n");
  printf(FH "userPassword: $password\n");
  printf(FH "businessCategory: sa\n");
  # !!! DOESN'T WORK !!!
  #  printf(FH "mailAlternateAddress: $mailAlternateAddress\n");
  printf(FH "\n");

  printf(FH "# sa role, $domain\n");
  printf(FH "dn: cn=sa role,$dn\n");
  printf(FH "changetype: add\n");
  printf(FH "nsRoleFilter: (&(businesscategory=sa)(objectclass=inetorgperson)(objectclass=babmwcompany))\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: ldapsubentry\n");
  printf(FH "objectClass: nsroledefinition\n");
  printf(FH "objectClass: nscomplexroledefinition\n");
  printf(FH "objectClass: nsfilteredroledefinition\n");
  printf(FH "cn: sa role\n");
  printf(FH "\n");

  printf(FH "# sa role, aci\n");
  printf(FH "dn: $dn\n");
  printf(FH "changetype: modify\n");
  printf(FH "add: aci\n");
  printf(FH "ACI: (targetattr = \"*\") (version 3.0;acl \"SA administration\";allow (all)(roledn = \"ldap:///cn=SA role,$dn\");)\n");
  printf(FH "\n");

  printf(FH "# isola-mcs, $domain\n");
  printf(FH "dn: node=$isola, $dn\n");
  printf(FH "changetype: add\n");
  printf(FH "node: $isola\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: babmwcompany\n");
  printf(FH "\n");

  if (defined $addressbooks) {
	 foreach my $i   (split(/[, ]+/, $addressbooks)) {
		printf(FH "# Create database and BackendInstance for storing personal contacts\n");
		printf(FH "dn: cn=Addressbook%s,cn=ldbm database,cn=plugins,cn=config\n", $i);
		printf(FH "changetype: add\n");
		printf(FH "objectclass: extensibleObject\n");
		printf(FH "objectclass: nsBackendInstance\n");
		printf(FH "nsslapd-suffix: o=%s\n", $i);
		printf(FH "\n");
		printf(FH "dn: cn=\"o=%s\",cn=mapping tree,cn=config\n", $i);
		printf(FH "changetype: add\n");
		printf(FH "objectclass: top\n");
		printf(FH "objectclass: extensibleObject\n");
		printf(FH "objectclass: nsMappingTree\n");
		printf(FH "nsslapd-state: backend\n");
		printf(FH "nsslapd-backend: Addressbook%s\n", $i);
		printf(FH "cn: \"o=%s\"\n", $i);
		printf(FH "\n");
		printf(FH "dn: o=%s\n",$i);
		printf(FH "changetype: add\n");
		printf(FH "objectclass: top\n");
		printf(FH "objectclass: organization\n");
		printf(FH "o: %s\n", $i);
		printf(FH "\n");
	 }
  }

  printf(FH "dn: o=example,node=$isola, $dn\n");
  printf(FH "changetype: add\n");
  printf(FH "maxusers: 1000\n");
  printf(FH "aci: (targetattr=cn||userpassword||skypename||mailforwardingaddress||secretary||vacationstatus||vacationmessage||l||st||postalcode||postaladdress||telephonenumber||facsimiletelephonenumber||newuser||pwdreminderquestion||pwdreminderanswer)(version 3.0; acl \"SelfWrite\"; allow (read,write)(userdn=\"ldap:///self\");)\n");
  printf(FH "aci: (targetattr = \"subschemaSubentry || companyUsedQuota\") (version 3.0;acl \"admin update used quota\";allow (read,compare,search,write)(roledn = \"ldap:///cn=admin role,o=example,node=$isola, $dn\");)\n");
  printf(FH "companyUsedQuota: 0\n");
  printf(FH "o: example\n");
  printf(FH "companyQuota: 102400\n");
  printf(FH "companyvatnumber: 1234567890\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: organization\n");
  printf(FH "objectClass: babmwcompany\n");
  printf(FH "maxsms: 10000\n");
  printf(FH "maxfax: 10000\n");
  printf(FH "\n");

  printf(FH "dn: cn=admin role,o=example,node=$isola, $dn\n");
  printf(FH "changetype: add\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: ldapsubentry\n");
  printf(FH "objectClass: nsroledefinition\n");
  printf(FH "objectClass: nscomplexroledefinition\n");
  printf(FH "objectClass: nsfilteredroledefinition\n");
  printf(FH "nsRoleFilter: (&(businesscategory=companymanager)(objectclass=inetorgperson)(objectclass=babmwcompany))\n");
  printf(FH "cn: admin role\n");
  printf(FH "\n");

  printf(FH "dn: cn=cosindicator,o=example,node=$isola, $dn\n");
  printf(FH "changetype: add\n");
  printf(FH "aci: (targetattr = \"*\") (version 3.0;acl \"Company Manager Cos administrator\";allow (all)(roledn = \"ldap:///cn=admin role,o=example,node=$isola, $dn\");)\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: cossuperdefinition\n");
  printf(FH "objectClass: cosindirectdefinition\n");
  printf(FH "objectClass: ldapSubEntry\n");
  printf(FH "cosAttribute: maildirquota\n");
  printf(FH "cosAttribute: mailmaxmessagesize\n");
  printf(FH "cosAttribute: maildirwarn1\n");
  printf(FH "cosAttribute: maildirwarn2\n");
  printf(FH "cosAttribute: maildirwarn3\n");
  printf(FH "cosAttribute: smsenabled\n");
  printf(FH "cosAttribute: faxenabled\n");
  printf(FH "cosAttribute: imenabled\n");
  printf(FH "cosAttribute: syncmlenabled\n");
  printf(FH "cosAttribute: gigaenabled\n");
  printf(FH "cosAttribute: mailcollectorenabled\n");
  printf(FH "cosIndirectSpecifier: manager\n");
  printf(FH "cn: cosindicator\n");
  printf(FH "\n");

  printf(FH "dn: dc=example.com,o=example,node=$isola, $dn\n");
  printf(FH "changetype: add\n");
  printf(FH "dc: example.com\n");
  printf(FH "calCalURI: http://localhost:8080/ucaldav/\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: domain\n");
  printf(FH "objectClass: babmwcompany\n");
  printf(FH "objectClass: calentry\n");
  printf(FH "\n");

  printf(FH "dn: ou=People,dc=example.com,o=example,node=$isola, $dn\n");
  printf(FH "changetype: add\n");
  printf(FH "aci: (targetattr = \"*\") (version 3.0;acl \"Company Manager People\";allow (all)(roledn = \"ldap:///cn=admin role,o=example,node=$isola, $dn\");)\n");
  printf(FH "ou: People\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: organizationalunit\n");
  printf(FH "\n");

  printf(FH "dn: ou=Groups,dc=example.com,o=example,node=$isola, $dn\n");
  printf(FH "changetype: add\n");
  printf(FH "aci: (targetattr = \"*\") (version 3.0;acl \"Company Manager Groups\";allow (all)(roledn = \"ldap:///cn=admin role,o=example,node=$isola, $dn\");)\n");
  printf(FH "ou: Groups\n");
  printf(FH "objectClass: top\n");
  printf(FH "objectClass: organizationalunit\n");
  printf(FH "\n");

  close(FH);
}

sub create_balance() {
  $addressbooks =~ s/ +//g;
  my $command = "bash -c './balance.sh $isola:ldap://localhost:389/{$addressbooks}'";
  print STDERR "executing $command\n" if ($opt{'v'});

  system($command) == 0
	 or die("Error creating balance.xml");
}

sub main() {
  &create_ldif;
  &create_calendar_ldif;
 # &create_balance;
}

&main;
