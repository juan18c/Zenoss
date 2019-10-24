#!/usr/bin/perl
# Description: This script runs a query against a MS SQL
# database to make sure that it's working.  The simple
# query is simply grabbing the SQL version.
#You can run this check for Zenoss and or Nagios.

use DBI;

# normal output for the simple query
$pattern = "Microsoft SQL Server";

$server= $ARGV[0];
#$usernamm = $ARGV[1];
#server = "sSQL SERVERIP HERE";
$username = "ZenossSQLUserName";
$password = "SQLPASSWORD";

my $dbh = DBI->connect("DBI:Sybase:server=$server", $username, $password, {PrintError => 0});
die "Unable for connect to server $DBI::errstr" unless $dbh;

$str_sql = "select \@\@version";
$sth = $dbh->prepare($str_sql) || print "Could not prepare $str_sql, $DBI::errstr";
$sth->execute || print "Could not execute $str_sql, $DBI::errstr";
$result = $sth->fetchrow;

if ($result =~ /$pattern/){
    $return_code=0;

}

else{
    $return_code=1;
}

# finish the query
$sth->finish;

# disconnect from the database server
$dbh->disconnect;

#print $return_code;
exit $return_code;
