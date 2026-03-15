#!/usr/bin/perl
# mask-ip.pl
my @files = glob("./*.txt");   # 搜尋所在目錄所有.txt檔
foreach my $file (@files) {
	my $log = $file . ".log";
	print "gen $log ...\n";
	open(my $out, '>', $log) or die "error:$!";
	open(my $fh, '>', $file) or die "error:$!";
	while (my $line = <$fh>) {
		$line =~ s/(\d{1,3}\.)(\d{1,3}\.)(\d{1,3}\.)(\d{1,3})/x.y.z$4/g;
		print $out $line;
	}
	close $fh;
	close $out;
}

