#!/usr/bin/perl
# genSourceCodeCSV.pl
use File::Find qw(finddepth);

my $src = "/Users/jemmy/Downloads/demo/src";  # Source Code目錄

finddepth(sub {
    my $fname = $File::Find::name;
    my @ary = split/\t/;
    return if ($ary[-1] =~ /^[.].*/);
    my $dir = "src/" . substr($fname, length($src) + 1, length($fname) - length($src) - 2 - length($ary[-1]));
    my @tst = split(".", $ary[-1]);
    print "2025/10/27\tDemo\tUAT\t9527\t$dir\t$ary[-1]\n" unless (-d $fname);
}, $src);
