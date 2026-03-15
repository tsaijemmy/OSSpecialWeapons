#!/usr/bin/perl
# gen_pom.pl
my %depends;
while (<DATA>) {
     chomp;
     my @tags = split/\:/;

     unless (exists $depends{$tags[0] . ":" . $tags[1]}) {
          $depends{$tags[0] . ":" . $tags[1]} = 1;
          my $pom = <<EOF;
<dependency>
     <groupId>$tags[0]</groupId>
     <artifactId>$tags[1]</artifactId>
     <version>$tags[2]</version>
</dependency>
EOF
          print $pom;
     }
}

__DATA__
org.projectlombok:lombok:1.18.24
org.springframework.boot:spring-boot-starter-data-jpa:2.7.5
org.springframework.boot:spring-boot-starter-aop:2.7.5
org.springframework.boot:spring-boot-starter:2.7.5
org.springframework.boot:spring-boot:2.7.5
org.springframework:spring-core:5.3.23
org.springframework:spring-jcl:5.3.23
