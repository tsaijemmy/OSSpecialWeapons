#!/usr/bin/perl
# crossline.pl
sub handleBlock {
    my $block = shift;
    @lines = split/\n/, $block;
    print $lines[0] . ":\n";
    print join("\n", @lines[1 .. $#lines]);
    print "\n\n";
}
undef $/;

open F, "./javaue.def" or die "$!";
$ctx = <F>;
close F;
while ($ctx =~ /(Definition for table .*?End of definition)/gs) {
    handleBlock($1);
}
