#!/bin/bash
# script name: validateCertDate.sh
for url in `cat ./url.txt`
	do
		echo "$url check:"
		echo QUIT | openssl s_client -connect $url | openssl x509 -noout -dates | egrep --color=always "not(Before|After)"
		printf "\n"
	done
