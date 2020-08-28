#!/usr/bin/bash
# for ((i=$2; i<=$3; i++)); do echo "Do you want to create $1$i?"; sudo mysql -u root -p -Bse "create database $1$i;";done;  # old
dbname=$1
passwd=$2
echo "create database $dbname;"  | sudo mysql -u root -p1

echo "CREATE USER '$dbname '@'localhost' IDENTIFIED BY '$passwd';" | sudo mysql -u root -p$passwd
echo "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbname'@'localhost';" | sudo mysql -u root -p$passwd
echo "FLUSH PRIVILEGES;" | sudo mysql -u root -p$passwd
