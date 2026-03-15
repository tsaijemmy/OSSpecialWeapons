#!/usr/bin/perl
# tree.pl
use strict;
use warnings;
use File::Find;

sub print_tree {
    my ($path, $prefix) = @_;
    opendir(my $dh, $path) or die "Can't open $path: $!";
    my @files = grep { $_ ne '.' && $_ ne '..' } readdir($dh);
    closedir($dh);

    for my $file (@files) {
        print "$prefix$file\n";
        print_tree("$path/$file", "$prefix  ") if -d "$path/$file";
    }
}

my $root = shift || '.';
print_tree($root, '');
