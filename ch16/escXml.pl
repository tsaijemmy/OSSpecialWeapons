#!/usr/bin/perl
# escXml.pl
sub escapeXmlChar{
   my$s= shift;
    my %esc= (
        '&' => '&amp;',
        "'" => '&apos;', 
        '<' => '&lt;',
        '>' => '&gt;',
        '"' => '&quot;'
        );
    $s=~ s/[&'<>"]/$esc{$&}/g;
    return $s;
}

sub XmlChar {
    my $s= shift;
    my %esc= (
        '&amp;' => '&',
        '&apos;' => "'",
        '&lt;' => '<',
        '&gt;' => '>',
        '&quot;' => '"'
        );
    $s=~ s/&(amp|apos|lt|gt|quot);/$esc{$&}/g;
    return $s;
}

my $name = "特殊字元<轉譯> & \"IT鐵人賽\" -- 單引號(')";
print "原文: $name \n";
my $name1 = escapeXmlChar($name);
print "轉譯後: $name1 \n";
my $name2 = XmlChar($name1);
print "復原後: $name2 \n";
