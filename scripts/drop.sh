#!/usr/bin/sh
for ((i=$1; i<=$2; i++)); do echo "Do you want to drop $3$i"; sudo mysql -u root -p -Bse "drop database $3$i;"; done;
