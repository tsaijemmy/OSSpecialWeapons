#!/usr/bin/perl
# runBth.pl
my $flag = `ps -ef | grep -v grep | grep -c batch.jar`;
chomp $flag;
unless ($flag eq "0") {
	print "Running Batch...\n";
	my $last = (stat("/opt/batch/logs/batch.log"))[9];
	my $now = time();
	print "$now - $last = " . ($now - $last) . "\n";
	if ($now - $last > 3 * 60 * 1000) {
		print "Batch is blocking...\n";
		system "./stop.sh; nohup ./runBatch.sh >/dev/null 2>&1 &"
	}
} else {
	system "nohup ./runBatch.sh >/dev/null 2>&1 &";
}	
