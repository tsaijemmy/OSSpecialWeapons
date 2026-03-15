#!/usr/bin/perl
use utf8;
use Encode qw(encode);
# for example, printing to STDOUT
my $perl_string = "精誠資訊Systex";
print encode('UTF-8', $perl_string) . "\n"; # in a Linux environment

use URI::Escape;
my $encoded = uri_escape_utf8($perl_string);
print $encoded . "\n";
my $decoded = uri_unescape($encoded);
print $decoded . "\n";

