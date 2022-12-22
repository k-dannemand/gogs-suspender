#!/bin/bash

./gam print users lastlogintime > lastlogin.csv
awk 'NR>1' lastlogin.csv > lastloginr.csv
rm lastlogin.csv 2> /dev/null

INPUT=lastloginr.csv
cutoff=$(date -d '2 days ago' +%s)

while IFS=, read -r field1 field2
do
  age=$(date -d "$field2" +%s)
  if (($age < $cutoff))
  then
    printf "Warning! "$field1" has not logged in with in 2 days suspending account\n"
    ./gam update user $field1 suspended on
  fi
done < $INPUT
