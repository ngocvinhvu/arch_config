for ((i=$2; i<=$3; i++)); do echo "Do you want to create $1$i?"; sudo mysql -u root -p -Bse "create database $1$i;";done;
