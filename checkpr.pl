#!/usr/bin/perl
#Check your printer panel codes and return an error on the specific panel words.
#Works on most HP Business Printer systems
#
#Create and store a variable for argument zero
$ip = $ARGV[0]; 
#Check four versions of the snmp string value (1 through 4) and "for loop" through it to collect information on each snmp MIB.
for ($i=1; $i<=4; $i++) {
	unless ($cmd = `/usr/bin/snmpget -v 2c $ip -c public mib-2.43.16.5.1.2.1.$i -O v`){
	    #due to the unless clause, if the above fails, print "Printer check failed" and exit with code 2
	    print "Printer check failed\n";
	    exit(2);
	}
#Build an arrau and split the strings out.
	@snmp = split(/STRING: /, $cmd);

#Another for loop and then +1 after each one.
	for ($j=1; $j<=$#snmp; $j++) {

#Print the code on variable $j	 	
	print $snmp[$j];
               
 #As the program is going through the array of the mib, check for the word "Empty" and print the below              
		if ($snmp[$j] =~ m/EMPTY/ || $snmp[$j] =~ m/empty/) {
			print "One of the trays is empty on $ip\n";
			exit(1);
		}

 #As the program is going through the array of the mib, check for the word "Personality or Mismatch" and print the below
		if ($snmp[$j] =~ m/LOAD/ || $snmp[$j] =~ m/PERSONALITY/ || $snmp[$j] =~ m/MISMATCH/ || $snmp[$j] =~ m/Mismatch/) {
			print "Paper size error on $ip\n";
			exit(1);
		}

 #As the program is going through the array of the mib, check for the word "Low or Cartridge" and print the below
		if ($snmp[$j] =~ m/LOW/ || $snmp[$j] =~ m/Cartridge/) {
			print "LOW Toner on $ip\n";
			exit(1);
		}

 #As the program is going through the array of the mib, check for the word "Missing or Cartridge" and print the below		
		if ($snmp[$j] =~ m/MISSING/ || $snmp[$j] =~ m/CARTRIDGE/ || $snmp[Sj] =~ m/TONER OUT/) {
			print "Toner is Missing or Empty on $ip\n";
			exit(1);
		}

 #As the program is going through the array of the mib, check for the word "Maintenance or Accessory" and print the below		
		if ($snmp[$j] =~ m/MAINTENANCE/ || $snmp[$j] =~ m/ACCESSORY/) {
			print "Printer needs maintenance on $ip\n";
			exit(1);
		}

 #As the program is going through the array of the mib, check for the word "Fuse" and print the below - NOTE THE EXIT CODE!!!!
                if ($snmp[$j] =~ m/FUSE/) {
                        print "FUSE Error on $ip.\n";
                        exit(2);
                }

 #As the program is going through the array of the mib, check for the word "Misfeed, Mispick Jam or JAM" and print the below - NOTE THE EXIT CODE!!!!               
                if ($snmp[$j] =~ m/JAM/ || $snmp[$j]=~ m/Jam/ || $snmp[$j] =~ m/MISFEED/ || $snmp[$j] =~ m/MISPICK/) {
                        print "Paper Jam on $ip\n";
                        exit(1);
                }


 	}
}
#Exit zero if nothing is picked up from the array.
#print "All is good on $ip.\n";
exit(0);
