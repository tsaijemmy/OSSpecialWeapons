#!/usr/bin/perl
# Usage: ./ans2.pl ./docker-compose.yml

open F, $ARGV[0] or die "error: $!";
my @patterns = <DATA>;
close DATA; # 良好的習慣：讀取完 DATA 後關閉

while(<F>) {
    my $line = $_;
    for my $pat (@patterns) {
        chomp $pat;
        # 1. 處理 key: value 格式 (例如 IP: 192.168.1.1)
        $line =~ s/($pat):\s*.+$/$1: XXXXX/i; 
        
        # 2. 處理 key=value; 格式 (例如 IP=192.168.1.1;)
        $line =~ s/($pat)=.+?;/$1=XXXXX;/i;
        
        # 3. 額外處理：如果 IP 直接出現在行末且沒有分號 (例如 DB_IP=192.168.1.1)
        $line =~ s/($pat)=[^;]+$/$1=XXXXX/i;
    }
    print $line;
}
close F;

__DATA__
DB_PWD
APP_LOCAL_ADMIN_PWD
databaseName
IP