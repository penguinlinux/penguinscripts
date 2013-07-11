#!/bin/bash 
echo "####################################################"
echo "# We are going to get an SQL dump from the PRODUCTION Server"
echo "Are you ready? (CTRL-C at any time to exit)"
read -p "What database do you want a dump from? " database
read -sp "Now enter the root SQL password (will not be echoed): " rootpassword

echo ""
echo "Please wait for a backup of $database"

ssh webgroup@mddclinicalexchange.com mysqldump -u root -p$rootpassword $database > backup-of-$database.sql

echo "Your SQL dump is done.  Your backup file is backup-of-$database.sql"

echo "DONE"
