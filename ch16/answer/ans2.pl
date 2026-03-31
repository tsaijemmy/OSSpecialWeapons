#!/usr/bin/perl
use utf8;
use strict;
binmode(STDOUT, ":encoding(utf-8)");

sub escapeXmlChar {
    my $s = shift;
    my %esc = (
        '&' => '&amp;', "'" => '&apos;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;',
        '↑' => '[up arrow]',    '↓' => '[down arrow]', 
        '←' => '[left arrow]',  '→' => '[right arrow]',
        '↖' => '[up-left]',     '↗' => '[up-right]', 
        '↙' => '[down-left]',   '↘' => '[down-right]'
    );
    # 使用正則表達式匹配所有定義的 Key
    my $keys = join('', keys %esc);
    $s =~ s/([$keys])/$esc{$1}/g;
    return $s;
}

sub XmlChar {
    my $s = shift;
    # 建立反向對照表
    my %desc = (
        '&amp;' => '&', '&apos;' => "'", '&lt;' => '<', '&gt;' => '>', '&quot;' => '"',
        '\[up arrow\]'    => '↑', '\[down arrow\]'  => '↓',
        '\[left arrow\]'  => '←', '\[right arrow\]' => '→',
        '\[up-left\]'     => '↖', '\[up-right\]'    => '↗',
        '\[down-left\]'   => '↙', '\[down-right\]'  => '↘'
    );
    
    # 使用 | 連結所有對象進行搜尋
    my $search = join('|', keys %desc);
    $s =~ s/($search)/$desc{$1}/g;
    return $s;
}

my $name = "方向測試: ←↑→↓ 加上 <XML> 標籤 & '單引號'";
print "原文: $name \n";
my $name1 = escapeXmlChar($name);
print "轉譯後: $name1 \n";
my $name2 = XmlChar($name1);
print "復原後: $name2 \n";