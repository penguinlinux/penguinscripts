#!/bin/bash 
# Script to Drop Databases on dev beta and live 
#
echo "This script will drop databases on dev beta and live"
echo "##### DANGER WILL ROBINSON PLEASE BE CAREFUL ####"

echo "Please enter the name of the database you want to drop"
read database

echo "Please enter the SQL root server password"
read rootpassword
echo "Dropping Database on DEV dev_$database"

mysqladmin -u root -p$rootpassword drop dev_$database &&

echo "DROPPED dev_$database"

sleep 4

echo "Dropping Database on BETA beta_$database"

ssh webgroup@mddclinicalexchange.com mysqladmin -u root -p$rootpassword drop beta_$database &&

echo "DROPPED beta_$database" 

sleep 4

echo "Dropping Database on LIVE live_$database"

ssh webgroup@mddclinicalexchange.com mysqladmin -u root -p$rootpassword drop live_$database &&

echo "DROPPED live_$database"

echo "ALL DATABASES HAVE BEEN DROPPED FROM DEV BETA AND LIVE BYE"

