#!/bin/bash

set -e
logfile=./$(date +%Y%m%d.log)
(
echo "[$(date +%Y%m%d %H:%M:%S)]"
OUTPUT=$(curl http://localhost/version.json | jq '.version')
if [ "$OUTPUT" == "null" ]; then
    echo "Connect Failure"
else
    echo "Connect OK! Version is $OUTPUT"
fi
) 2>&1 | tee -a $logfile
