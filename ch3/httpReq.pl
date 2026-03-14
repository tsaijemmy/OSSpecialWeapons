#!/usr/bin/perl -w
use utf8; 
use strict;
use warnings;
use HTTP::Request; 
use LWP::UserAgent;

my $ua = LWP::UserAgent->new(ssl_opts => { SSL_verify_mode => 0 });
# my $ua = LWP::UserAgent->new(ssl_opts => { SSL_verify_mode => 'SSL_VERIFY_NONE' });
my $request = HTTP::Request->new('GET', "https://linebotapi.com:7443/target?name=xx");
$request->header(Content_Type => 'application/json');
my $response = $ua->request($request);
print $response->content; 

