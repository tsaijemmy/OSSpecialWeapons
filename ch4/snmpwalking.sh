#!/bin/bash
# script name: snmpwalking.sh
while :
do 
  for host in `cat ./host.txt`
  do
    echo $host
    for oid in `cat ./oid.txt` 
    do echo "  $oid"  && snmpwalk -v3 -l authPriv -u username -a MD5 -A password -x DES -X password $host $oid # > /dev/stdout
    done
  done
  sleep 1
done

