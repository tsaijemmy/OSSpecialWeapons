#!/usr/bin/perl
# hereDocReplace.pl
my $keystore = "ABC";
my $storepass = "DEF";
my $alias = "GHI";
my $keypass = "JKL";
my $buildprop = <<"ENDPROP";
    signingConfigs {
        defaultConfig {
            storeFile file("$keystore")
            storePassword "$storepass"
            keyAlias "$alias"
            keyPassword "$keypass"
        }
    }
ENDPROP

open F, "build.gradle" or die "$!";
my $ctx = join "", <F>; # 這是把檔案內容全存到字串變數的方式
close F;
$ctx =~ s/ +signingConfigs \{\n(.+\n){7}/$buildprop/m; # 置換: 找到signingConfigs起8行置換
print $ctx;
