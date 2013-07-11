#!/bin/bash 
# This script will create a username on dev beta and live 
# you need to specify the suffix of the database you will be creating 
# for example to create databases dev_animaldb beta_animaldb and live_animaldb
# you only need to speficy animaldb as the name of the database
# 
# Version 0.1
# Marco Maldonado Oct 21 2009 

echo "####  ECHO CREATE GRANTS ON BOTH CTLSDEV BETA AND PRODUCTION FOR DBNAME ###" 

echo "### which database please specify only the suffix ###"
read dbname
echo "Which username do you want to create"
read dbusername
echo "#####################################"
echo "which password do you want to use for this user  please use upper and lower case and numbers"
read dbpassword
echo "##############################################################"
echo "Now finally enter the root password for the sql server"
read rootpassword
 
sleep 3 ;
echo "Creating Permissions on CLTSDEV dev_$dbname for $dbusername with password $dbpassword"

mysql -u root -p$rootpassword -e "grant all on dev_$dbname.* to $dbusername@localhost identified by '"$dbpassword"';"
echo "DONE"
sleep 4 ;

echo "Creating Permissions on BETA beta_$dbname for $dbusername with password $dbpassword"

echo "grant all on beta_$dbname.* to $dbusername@localhost identified by '$dbpassword';" | ssh webgroup@beta.fakesite.com  mysql -u root -p$rootpassword

echo "DONE"

sleep 4 ; 
echo "Creating Permissions on PRODUCTION live_$dbname for $dbusername with password $dbpassword"

echo "grant all on live_$dbname.* to $dbusername@localhost identified by '$dbpassword';" | ssh webgroup@thepenguinexchange.com mysql -u root -p$rootpassword

sleep 3 ;


echo "DONE"

echo "Today `date` grants have been assigned to dev_$dbname beta_$dbname live_$dbname with username $dbusername and password $dbpassword" >> log.txt
  
