#!/bin/bash
for i in $(ls audit/*.rb); do
    f="$(basename -- $i)"
    bin/rails r ${i} > "audit/${f}.log";
done;

