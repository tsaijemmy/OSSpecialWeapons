#!/bin/bash
# script name: ans2.sh
for host in `cat ./url.txt`
do
  echo $host
  for cipher in `cat ./cipher.txt` 
  do
    echo $cipher
    echo QUIT | openssl s_client -connect $host -cipher $cipher
    printf "\n"
  done
done


