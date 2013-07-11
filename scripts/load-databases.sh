#!/bin/bash  
#
#
echo #We will be loading and SQL File into dev beta and live"

#database=$1

echo "Enter SQL server root password"
read rootpassword
echo "read database please use suffix"
read database 
echo "Loading Database content on DEV dev_$database"

mysql -u root -p$rootpassword dev_$database < $1 &&

sleep 3
echo "DONE loading DEV"

sleep 3

echo "Loading Database content on BETA beta_$database"

sleep 3
cat $1 | ssh webgroup@thepenguinexchange.com mysql -u root -p$rootpassword beta_$database &&

sleep 3

echo "DONE loading BETA"

echo "Loading Database content on LIVE live_$database"
sleep 3

cat $1 | ssh webgroup@thepenguinexchange.com mysql -u root -p$rootpassword live_$database &&

echo "DONE loading LIVE" 
sleep 3

echo "ALL DATABASES ARE LOADED BYE"

