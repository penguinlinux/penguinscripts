#!/bin/bash -x 
#  Sites Push:  Marco Maldonado 
#  File site-deploys.txt is created by http://ctlsdev.com/cgi-bin/deploy.cgi
#  This file is then used by a cron job to push the sites using this script every 5 minutes
#  Lets set a few variables 

   launchpad="/var/www/cgi-bin"
   sitedir="/opt/sites/beta-sites"  
   remotesite="mddclinicalexchange.com"
   emailadmin="thepenguin@fakesite.com"
   remoteuser="webgroup"
#  The while loop will run through the file line by line and 
#  push the site via rsync to the remote server listed above

   cat $launchpad/site-deploys.txt | while read line ; do 
   site=$( echo $line | cut -d'#' -f1 )
   user=$( echo $line | cut -d'#' -f2 )
   comments=$( echo $line | cut -d'#' -f3 | sed "s/'//g" ) 

#  We will create a temp file like site-user-log this file will catch some of the
#  output from svn and the rsync command so that we can use it for logging. 
#  and also push the site to the remote server.
   touch $launchpad/$site-$user-log ; svn update $sitedir/$site 2>&1 | tee -a $launchpad/$site-$user-log ; sleep 2
   rsync -rave --delete -e "ssh" --exclude ".svn" $sitedir/"$site"/ $remoteuser@$remotesite:$sitedir/"$site"  | tee -a $launchpad/$site-$user-log

#  Now we are going to add values to a mysql database so that we can log all the actions onto a database.
#
   svlog=$( cat $launchpad/$site-$user-log  | sed "s/'//g" ) 
   mysql -umarcopenguin -ppenguins33rule -e "insert into deployments( Site, User, Comments, Svn_Log, pushdate) VALUES('$site','$user','$comments','$svlog',NOW())"  ctlsdevdeploy

#  Now let's send an email to the admin just in case, and then remove the log file

   EMAIL="$emailadmin,$user@fakesite.com"

	 cat "$site was pushed by $user on `date`" >> $launchpad/$site-$user-log
   mail -s "$site has been pushed by $user on `date` {ID4919}" $EMAIL  -- -r "$user@fakesite.com" < $launchpad/$site-$user-log

   rm -rf $launchpad/$site-$user-log 
   done

#  Now let's just blank the site-deploys.txt file so it can be ready for more sites for the next push 
   cat < /dev/null > $launchpad/site-deploys.txt
