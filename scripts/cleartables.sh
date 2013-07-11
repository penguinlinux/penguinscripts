#!/bin/bash -x  
#
#

database=$1
progname=$(basename $0)


echo "#########################################################"
echo "We will be running and SQL File into dev beta and live"
echo "#########################################################"

echo "Are you ready? (CTRL-C at any time to exit)"
read -p "Type database name:" database
read -sp "Enter Root SQL Server ( Will not be echoed):" rootpassword

mysql -u root -p$rootpassword $database -e "show tables" | grep -v Tables_in | grep -v "+" | \gawk '{print "drop table " $1 ";"}' | mysql -u root -p$rootpassword $database || echo "This failed try again"


