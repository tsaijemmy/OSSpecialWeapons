#!/bin/bash

filename="data.txt"
while IFS= read -r line
do
    if [[ $line =~ ITHome ]]; then
        echo "Found ITHome: $line"
    else
        echo "No match: $line"
    fi
done < "$filename"

