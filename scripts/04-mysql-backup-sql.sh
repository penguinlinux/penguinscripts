#!/bin/bash -x
#
# Marco Maldonado MySQL Backup
# Version 1.0 September 9 2008
# comments marco@penguincares.no-ip.org

MYSQL=`which mysql`
MYSQLDUMP=`which mysqdump`
BACKUPS=/backups/marco-db-sql
#userpassword=" --user=root --password=fakePassword"
dbs=`$MYSQL -u root -pfakePassword -Bse 'show databases'`

for db in $dbs
do
rm -rf $BACKUPS/$db.3
mv $BACKUPS/$db.2 $BACKUPS/$db.3
mv $BACKUPS/$db.1 $BACKUPS/$db.2
mv $BACKUPS/$db.0 $BACKUPS/$db.1
#mkdir $BACKUPS/$db.0
#$HOTCOPY $userpassword $db $BACKUPS/$db.0
mysqldump -u root -pfakePassword $db  > $BACKUPS/$db.0
done

