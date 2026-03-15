#!/usr/bin/perl
# versionSQL.pl
use strict;
use Net::FTP;
use POSIX qw(strftime);
use File::Copy;

print "Please input the password of DBACCOUNT:\n";
system('/usr/bin/stty', '-echo');
my $password = <>;
chomp $password;
system('/usr/bin/stty', 'echo');

system "rm *.sql *.log *.err";
my $date = strftime "%Y%m%d", localtime;
print "start version...$date\n";
my $HOST = "1.1.1.1";
my $ftp = Net::FTP->new($HOST) or die "Can't connect: $@\n";
$ftp->login("ftpuser", "ftppwd") or die "Can't login by ftpuser: $@\n";
$ftp->cwd("UAT/$date" . "_UAT/DB") or die "NO Folder: $@\n";
$ftp->mkdir($date); # or die "Error: $@\n";
my @files = $ftp->ls;
for my $file (@files) {
	next unless ($file =~ /\.sql$/);
	print "GET $file\n";
	$ftp->get($file);
	system "cp $file ${file}.log";
	system 'echo exit | sqlplus DBACCOUNT/' . $password . '@DBSID @' . $file . " 1>>${file}.log 2>${file}.err";
	$ftp->cwd($date);
	$ftp->put("${file}.log");
	my $size = -s "${file}.err";
	$ftp->put("$date/${file}.err") if ($size > 0);
	$ftp->cwd("..");
}
$ftp->quit
