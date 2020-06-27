for ((i=$1; i<=$2; i++)); do echo "Do you want to create $3$i?"; yes ""| sudo mysql -u root -p -Bse "create database $3$i;";done;
