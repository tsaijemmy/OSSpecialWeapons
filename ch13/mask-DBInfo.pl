#!/usr/bin/perl
# Usage: ./maskDBInfo.pl ./docker-compose.yml
open F, $ARGV[0] or die "error: $!";
@patterns = <DATA>;
while(<F>) {
        my $line = $_;
        for $pat (@patterns) {
                chomp $pat;
                $line =~ s/($pat): .+$/$1: XXXXX/;  # 判斷key: value
                $line =~ s/($pat)=.+?;/$1=XXXXX;/;  # 判斷key=value
        }
        print $line;
}
close F;

__DATA__
DB_PWD
APP_LOCAL_ADMIN_PWD
databaseName

