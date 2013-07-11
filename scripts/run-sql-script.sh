#!/bin/bash  
#

database=$1
progname=$(basename $0)

if [ $# -eq 0 ] ; then
   echo "Usage $progname file.sql [use_prefixes=true]" >&2 ; exit 1
	 echo "  if use_prefixes = false, does not use 'dev_', 'beta_', 'live_' prefixes"
fi

dev_pre="dev_";
beta_pre="beta_";
prod_pre="live_";
if [[ -z "$2" ]] ; then
	if [[ ( "$2" -eq "f" || "$2" -eq "false" || "$2" -eq "n" || "$2" -eq "no" ) ]] ; then
		dev_pre="";
		beta_pre="";
	fi;
fi;

echo "#########################################################"
echo "We will be running and SQL File into dev beta and live"
echo "#########################################################"

echo "Are you ready? (CTRL-C at any time to exit)"
read -p "Type database name: " database
read -p "Load dev db? (default: n): " load_dev
read -p "Load beta & prod? (default: n): " load_beta_prod
read -sp "Enter Root SQL Server (Will not be echoed): " rootpassword

echo ""
#convert to all lowercase
database=$(echo $database|tr '[A-Z]' '[a-z]')
load_dev=$(echo $load_dev|tr '[A-Z]' '[a-z]')
load_beta_prod=$(echo $load_beta_prod|tr '[A-Z]' '[a-z]')

# update dev db (if requested)
if [[ $load_dev == "y" || $load_dev == "yes" ]]; then
	echo "[DEV] About to run script for database $dev_pre$database (Ctrl+C to abort)"
	sleep 2
	echo "[DEV] RUNNING Script for database $dev_pre$database"
	mysql -u root -p$rootpassword $dev_pre$database < $1 &&
	echo "[DEV] DONE running your script for database $dev_pre$database"
else
	echo ""
	echo "[DEV] SKIPPED data load for database $dev_pre$database";
fi;

if [[ $load_beta_prod == "y" || $load_beta_prod == "yes" ]]; then
# update beta db
	echo ""
	echo "[BETA] About to run script for database $beta_pre$database (Ctrl+C to abort)"
	sleep 2
	echo "[BETA] RUNNING script for database $beta_pre$database"
	cat $1 | ssh webgroup@thepenguinexchange.com mysql -u root -p$rootpassword $beta_pre$database &&
	echo "[BETA] DONE running script for database $beta_pre$database"

# update production db
	echo ""
	echo "[PROD] About to run script on the prod server for db $prod_pre$database (Ctrl+C to abort)"
	sleep 2
	echo "[PROD] RUNNING Script on $prod_pre$database"
	cat $1 | ssh webgroup@thepenguinexchange.com mysql -u root -p$rootpassword $prod_pre$database &&
	echo "[PROD] DONE running script on the prod server for db $prod_pre$database" 
else
	echo ""
	echo "[BETA] SKIPPED data load for database $beta_pre$database"
	echo "[PROD] SKIPPED data load for database $prod_pre$database"
fi;

echo ""
echo "---------------------------"
echo "COMPLETED your script has been run"

