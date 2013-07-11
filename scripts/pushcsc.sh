#/bin/bash
#
#
#
LOGFILE=log.$$
backup="/backup/cscdb/"
server=www.fakesite.com.com
backupdate=`date +%Y%m%d-%H%M`

PATH=/sbin:/bin:/usr/sbin:/usr/bin

RETVAL=0

pushstatic()
{
    ### rsync files to production ########

    echo "We will rsync files from beta to production" && sleep 4
    /usr/bin/rsync -rave --delete -e "ssh" --exclude "*.svn" /opt/sites/beta-production/beta.static.fakesite.com.com/ webgroup@$server:/opt/sites/fakesite.com-production/static.fakesite.com.com/ 2>&1 | tee -a $LOGFILE

    #### email a report to marco #########

    mail -s "Push to static.fakesite.com.com" thepenguin@fakesite.com < $LOGFILE
    rm -rf $LOGFILE && echo "Your files were sent to production"
}

pushcode()
{
    ### rsync files to production ########

    echo "We will rsync files from beta to production" && sleep 4
    /usr/bin/rsync -rave --delete -e "ssh" --exclude "*.svn" /opt/sites/beta-production/beta.fakesite.com.com/ webgroup@$server:/opt/sites/fakesite.com-production/www.fakesite.com.com/ 2>&1 | tee -a $LOGFILE

    #### email a report to marco #########

    mail -s "Push to www.fakesite.com.com" thepenguin@fakesite.com < $LOGFILE
    rm -rf $LOGFILE && echo "Your files were sent to production"
}

backupdb()
{
    echo "Great we are going to create a backup located inside /backup/cscdb"
    ssh webgroup@www.fakesite.com.com mysqldump -u root -pfakePassword fakesite.com > $backup\fakesite.com-$backupdate.sql  &&
    sleep 3   ; echo "Backup was created $backup/fakesite.com-$backupdate.sql"
}

pushbetadb()
{
    echo "Pushing beta fakesite.com database to production"
    mysqldump -u root -pfakePassword fakesite.com | ssh webgroup@www.fakesite.com.com mysql -u root -pfakePassword fakesite.com && 
    echo "Databases has been reloaded"
}

case "$1" in 
        pushcode)
	           pushcode
                    ;;
        backupdb)  
                   backupdb
                   ;;
        pushbetadb)
                   pushbetadb
                   ;;
        pushstatic)
                  pushstatic
                  ;;
        *)
                  echo $"Usage: $0 {pushcode|backupdb|pushbetadb}"
                  echo "pushcode will push only code"
                  echo "backupdb will create a backup of the database"
                  echo "pushbetadb will push the beta database to production"
                  echo "pushstatic wil push the static content to static.fakesite.com.com"
                  exit 1
					 
esac
exit $RETVAL
