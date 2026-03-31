#!/usr/bin/perl
# ans3.pl
use strict;
use warnings;

# 讀取檔案內容到陣列
open(my $fh_url, '<', 'url.txt') or die "無法開啟 url.txt: $!";
my @hosts = <$fh_url>;
close($fh_url);

open(my $fh_cipher, '<', 'cipher.txt') or die "無法開啟 cipher.txt: $!";
my @ciphers = <$fh_cipher>;
close($fh_cipher);

foreach my $host (@hosts) {
    chomp($host); # 去除換行符號
    print "Host: $host\n";

    foreach my $cipher (@ciphers) {
        chomp($cipher);
        print "  Cipher: $cipher\n";

        # 執行 openssl 指令
        # 使用管道傳送 QUIT 並捕獲輸出
        my $cmd = "echo QUIT | openssl s_client -connect $host -cipher $cipher 2>&1";
        my $result = qx/$cmd/;
        
        print $result;
        print "\n" . "-"x30 . "\n";
    }
}
