#!/usr/bin/perl
#
$ip = $ARGV[0]; 
#for ($i=1; $i<=4; $i++) {
for ($i=1; $i<=4; $i++) {
	unless ($cmd = `/usr/bin/snmpget -v 1 $ip -c public mib-2.43.16.5.1.2.1.$i -O v`){
	    print "Printer check failed\n";
	    exit(2);
	}
	@snmp = split(/STRING: /, $cmd);

	for ($j=1; $j<=$#snmp; $j++) {
	 	
	print $snmp[$j];
               
               
		if ($snmp[$j] =~ m/EMPTY/ || $snmp[$j] =~ m/empty/) {
			print "One of the trays is empty on $ip\n";
			exit(1);
		}
		if ($snmp[$j] =~ m/LOAD/ || $snmp[$j] =~ m/PERSONALITY/ || $snmp[$j] =~ m/MISMATCH/ || $snmp[$j] =~ m/Mismatch/) {
			print "Paper size error on $ip\n";
			exit(1);
		}
		if ($snmp[$j] =~ m/LOW/ || $snmp[$j] =~ m/Cartridge/) {
			print "LOW Toner on $ip\n";
			exit(1);
		}
		if ($snmp[$j] =~ m/MISSING/ || $snmp[$j] =~ m/CARTRIDGE/ || $snmp[Sj] =~ m/TONER OUT/) {
			print "Toner is Missing or Empty on $ip\n";
			exit(1);
		}
		if ($snmp[$j] =~ m/MAINTENANCE/ || $snmp[$j] =~ m/ACCESSORY/) {
			print "Printer needs maintenance on $ip\n";
			exit(1);
		}
                if ($snmp[$j] =~ m/FUSE/) {
                        print "FUSE Error on $ip.\n";
                        exit(2);
                }
                if ($snmp[$j] =~ m/JAM/ || $snmp[$j]=~ m/Jam/ || $snmp[$j] =~ m/MISFEED/ || $snmp[$j] =~ m/MISPICK/) {
                        print "Paper Jam on $ip\n";
                        exit(1);
                }


 	}
}

#print "All is good on $ip.\n";
exit(0);
