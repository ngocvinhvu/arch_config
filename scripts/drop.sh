#!/usr/bin/bash
# for ((i=$2; i<=$3; i++)); do echo "Do you want to drop $1$i"; sudo mysql -u root -p -Bse "drop database $1$i;"; done; # old
echo "drop database $1;"  | sudo mysql -u root -p1
