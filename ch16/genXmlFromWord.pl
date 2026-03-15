#!/usr/bin/perl
use strict;
use XML::Twig;

my $service;
my $soap;
my $gen_flag = 0;

while(<DATA>) {
	chomp;
	if (/<soapenv:Envelope/ and $service ne '') {
		$gen_flag = 1;
		$soap .= $_;
	} elsif (/<\/soapenv:Envelope>/ and $service ne '') {
		$soap .= $_;
		$gen_flag = 0;
		# 提取CDATA內容
		print "start $service ....\n";
		my $twig = XML::Twig->new( 
    		twig_handlers => {
        		'#CDATA' => sub { 
        			open F, "> cdata.xml" or die "error:$!";
					print F $_->text;
					close F;
					$service =~ s/[ \/]/_/g;
					my $cmd = "xmllint --format cdata.xml > output/${service}.xml";
					system  $cmd ;
					print "${service}.xml finish \n";
				},
    		},  
		)->parse($soap);
		$soap = '';
	} elsif (/表 ?(.+)Response XML Sample Code/) {
		$service = '';
	} elsif (/表 ?(.+)Request XML Sample Code/) {
		print "$1\n";
		$service = $1;
	} elsif ($gen_flag == 1) {
		$soap .= $_;
	}
}

__DATA__
3.1.4.2.2.2 Request XML Sample Code
表 3.11 Get Package Detail Request XML Sample Code
<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:brm="http://172.16.4.170:7001/infranetwebsvc/services/BRMPymtServices">
    <soapenv:Header/>
    <soapenv:Body>
        <opcode soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <opcode xsi:type="xsd:string">PCM_OP_CUST_POL_READ_PLAN</opcode>
            <inputXML xsi:type="xsd:string">
                <![CDATA[
                    <PCM_OP_CUST_POL_READ_PLAN_inputFlist>
                        <POID>0.0.0.1 /plan 651273 0</POID>
                    </PCM_OP_CUST_POL_READ_PLAN_inputFlist>
                ]]>
        </inputXML>
        <m_SchemaFile xsi:type="xsd:string"/>
    </opcode>
</soapenv:Body>
</soapenv:Envelope>


