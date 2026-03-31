#!/bin/bash
# script name: ans1.sh
for url in `cat ./url.txt`
	do
		echo "$url check:"
		echo QUIT | openssl s_client -connect $url -cipher TLS_RSA_WITH_AES_128_GCM_SHA256
		printf "\n"
	done
