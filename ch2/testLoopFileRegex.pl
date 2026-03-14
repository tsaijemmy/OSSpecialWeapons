#!/usr/bin/perl
use strict;
use warnings;

my $filename = 'data.txt';
open(my $fh, '<', $filename) or die "Cannot open file: $!";

while (my $line = <$fh>) {
    chomp $line;  # 去掉換行
    if ($line =~ /ITHome/) {   # Regex 比對
        print "Found ITHome: $line\n";
    } else {
        print "No match: $line\n";
    }
}
close($fh);

