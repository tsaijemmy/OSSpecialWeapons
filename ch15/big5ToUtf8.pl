#!/usr/bin/perl
# big5ToUtf8.pl
my @files = glob "/tmp/input/*.TXT";       # 指定目錄所有的TXT檔
for $file (@files) {
    my $name = (split("/", $file))[-1];        # 取得檔名
    my $newname = $name;
    $newname =~ s/\.TXT$/_utf8\.TXT/;     # 置換檔名，尾綴_utf8
    print "$name ==> $newname \n";
    system "iconv -f BIG-5 -t UTF-8 $name > /tmp/output/$newname";
};

