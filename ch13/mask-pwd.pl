#!/usr/bin/perl
print "Please input the password:\n";
system('/usr/bin/stty', '-echo');
my $password = <>;
chomp $password;
system('/usr/bin/stty', 'echo');
print "You entered: $password"

