#!/bin/bash 
# Script to push most DJango projects
# change varialbles listed below #
#
DATE=`date +%Y%m%d`
LOGFILE=log.$$
REMOTE=beta2.fakesite.com
USER_REMOTE=ctls_root
SITE=beta.otsukaweb.fakesite.com
REMOTE_PATH=/opt/sites/beta/
LOCAL_PATH=/opt/deploy-base/
DBUSER=otsuka_slides
DATABASE=otsuka_slides
DBPASS=sWGtsCu5HGcrxN9d
WSGI=/mod_wsgi/beta.otsukaweb-django.wsgi
SCOOBY=thepenguin@fakesite.com
RETVAL=0
DBBACKUPS=$LOCAL_PATH/db-backups/
SITELOG=$LOCAL_PATH/logs/$SITE
IP=`env | grep SSH_CONNECTION | awk '{ print $1 }' | sed 's/SSH_CONNECTION=//g'`
   ## DO NO EDIT BELOW THIS LINE ####
   COWPATH=/usr/share/cowsay/     
    ### Check for User ###

   if [ "$USER" == "" ]  ;  then 
     echo "You have no user variable sorry log back in"  | cowsay && sleep 2  
     exit  
   fi

  ## Deploy Functions #####

   push()
   {
    echo "Hey! $USER do you really want to push $SITE Y/N?" | cowsay -e "@@" 
    read  a
    if [[ $a == "Y" || $a == "y" ]] ; then

    ### Prompt for Message" 
    echo "Make a comment about this push" | cowsay -e "88"
    read comment

    #### svn update directory to rsync ####
    svn update  $LOCAL_PATH$SITE   2>&1 | tee -a $LOGFILE || mail -s "Something Went Wrong with $SITE deploy svn update" $SCOOBY,$USER@fakesite.com

    ### Rsync Files to the site  #####

    echo  "Deploying $SITE to $REMOTE" && sleep 4
    rsync -rave --delete -e "ssh" --exclude "*.svn" $LOCAL_PATH"/$SITE/"  $USER_REMOTE@$REMOTE:$REMOTE_PATH/"$SITE"/  | tee -a $LOGFILE
    REVISION=`cat $LOGFILE | grep revision`  
    echo "$comment | UPDATED $REVISION | $USER | $IP | `date`" >> $SITELOG
   ### Reload the Application after new Code has been pushed  #######   
    ssh $USER_REMOTE@$REMOTE "touch $REMOTE_PATH/$SITE/$WSGI"
   #### Email Report to the Admin ########
   mail -s "$USER from "$IP" has pushed website  $SITE on `date`" $SCOOBY,$USER@fakesite.com < $LOGFILE
   rm -rf  $LOGFILE && echo "Your site $SITE has been sent to $REMOTE with version $REVISION" | cowthink -e "=="
   else      
   echo "You decided not to push $SITE good move" | cowsay -f $COWPATH/tux.cow ; exit 0
   fi
   }
   
   ## Revert Code to  Specific Version #####
   revert()
   {
    echo "Hey! $USER do you really want to revert code for  $SITE Y/N?" | cowsay -e "@@" 
    read  a
    if [[ $a == "Y" || $a == "y" ]] ; then

    ### Prompt for Message" 
    echo "Before the Magic Cow reverts your site type a comment" | cowsay -e "88"
    read comment
     
    ### Here we revert the site ######
   echo "Rolling back $SITE"
   echo "Current Revision $( svn info $LOCAL_PATH$SITE | grep Revision )"
   echo "Enter Revision You Want to Push "
   read  REV
   echo "Updating Site $1 to Revision $REV"
   svn update -r $REV $LOCAL_PATH$SITE  2>&1 | tee -a $LOGFILE ; sleep 3
   rsync -rave --delete -e "ssh" --exclude "*.svn" $LOCAL_PATH"/$SITE/"  $USER_REMOTE@$REMOTE:$REMOTE_PATH/"$SITE"/ | tee -a $LOGFILE
   REVISION=`cat $LOGFILE | grep revision`  

   echo "$comment | REVERTED $REVISION | $USER | $IP | `date`" >> $SITELOG
   #### Email Report to the Admin ########
   mail -s "The $SITE was reverted by $USER from $IP to $REV  on $DATE" $SCOOBY,$USER@fakesite.com < $LOGFILE
   rm -rf  $LOGFILE && echo "Your site $SITE has been  $REVISION on  $REMOTE" | cowsay -e "@@"
   else      
   echo "You decided not to revert $SITE good move" | cowsay -f $COWPATH/three-eyes.cow ; exit 0
   fi

   }
   ### Create Virtual ENV ####
   create-virtualenv()
   {
   ### create virtualpy directory   #### 
   ssh  $USER_REMOTE@$REMOTE "cd $REMOTE_PATH$SITE && virtualenv --no-site-packages virtpy"
   }
   #### Install Python dependencies based on requirements.txt"
   python-deps()
   {
    ssh  $USER_REMOTE@$REMOTE "cd $REMOTE_PATH$SITE && (source virtpy/bin/activate && pip install -r mod_wsgi/requirements.txt) &"
   }
   ###  dbsync will load the database the first time ####
   dbsync()
   {
    ssh  $USER_REMOTE@$REMOTE "cd $REMOTE_PATH$SITE && source virtpy/bin/activate && python htdocs/manage.py syncdb --noinput"  
   }
  ### Run migrations ######
   migrate()
   {
    ssh  $USER_REMOTE@$REMOTE "cd $REMOTE_PATH$SITE && source virtpy/bin/activate && python htdocs/manage.py migrate"
    echo "Yo I took care of your Migrations" | cowsay -e "X-" -T "vv"
   } 
  ## Backups Database ###
   backupdb()
  { 
   ssh  $USER_REMOTE@$REMOTE mysqldump -u$DBUSER -p$DBPASS $DATABASE > $DBBACKUPS$DATABASE-$DATE-$USER-$$.sql || echo "Something went wrong" | cowsay -e "XX" 
   }   
  ###  Show last 3 pushes ########
  report()
  {
  tail -n 3 $SITELOG | while IFS= read -r LINE; do echo "$LINE" | cowthink -f $COWPATH/tux.cow ; sleep 1  ; done 
  }
   ### run a command ####
   command()
   {
    echo "Hey! $USER do you really want to run a python manage command for  $SITE Y/N?" | cowsay -e "@@"
    read  a
    if [[ $a == "Y" || $a == "y" ]] ; then

    ### Prompt for Message"
    echo "Which python manage command do you want to run?" | cowsay -e "88"
    read command

    ### Here we run your command ######

    ssh  $USER_REMOTE@$REMOTE "cd $REMOTE_PATH$SITE && source virtpy/bin/activate && python htdocs/manage.py $command"
    echo "The magic cow just ran your command $command" | cowsay -e "X-" -T "vv"
    fi
   }

   #### Selections happen here ##########

  case "$1" in
        --push)
             push;;
        --revert)
             revert;;
        --create-virtualenv)
             create-virtualenv;;
        --python-deps)
             python-deps;;
        --dbsync)
             dbsync;;
        --migrate)
             migrate;;
        --backupdb)
             backupdb;;
        --report)
             report;;
        --command)
             command;;
             *) 
            echo $"Usage: $0 [--option]"
            echo "       --push will push your site $SITE"
          #  echo "       --revert will revert code to a specific version" 
          #  echo "       --create-virtualenv ADMIN command will create the virtualenv directory run ONLY ONE TIME"
          #  echo "       --python-deps ADMIN command will install python dependencies run ONLY ONE TIME"
          #  echo "       --dbsync Create Initial Tables and Load Database" 
          #  echo "       --migrate run migrations"
          #  echo "       --backupdb will backup your database just in case you mess something up"
          #  echo "       --donothing will not push anything"
            echo "       --report show a log of the last 3 pushes"
            exit 1
  esac 

  exit $RETVAL
