#!/bin/bash 
# Script to deploy the dam-ftp application 
source  /data01/apps/runtime/glamour2/glamdamcp/resin/glamour2-stg-app01_glamdamcp_1/bin/setenv.sh
DATE=`date +%Y%m%d`
WAR_FILE="/home/fkhan1/temp/glamdam-ft.war"
DEPLOYER=developer
RESIN_STOP="/apps/runtime/glamour2/glamdamcp/resin/glamour2-stg-app01_glamdamcp_1/bin/resin.sh stop"
RESIN_START="/apps/runtime/glamour2/glamdamcp/resin/glamour2-stg-app01_glamdamcp_1/bin/resin.sh start"
JAR="/data01/apps/common/java/jdk1.6.0_07/bin/jar"
STORE="/apps/runtime/glamour2/glamdamcp/resin/glamour2-stg-app01_glamdamcp_1/webapps"

#### Do not edit below this line ###

    ### Check for User ###

   if [ "$USER" != "developer" ]  ;  then
     echo "You have to run this as user cnp"   
     exit  
   fi

###  Deploy script ###

   deploy()
   {
    echo "Hey! $USER do you really want to deploy this war file Y/N?" 
    read  a
    if [[ $a == "Y" || $a == "y" ]] ; then

    ## Create a backup of file First ###
    tar -cipz $STORE\ROOT -f $STORE\ROOT-$DATE.tgz
    mv  $STORE\ROOT $STORE\ROOT_BACKUP
   
    ### Stop Resin ######
    echo "Stopping Resin Instance" ;  exec $RESIN_STOP ; sleep 3
    
    mkdir $STORE\ROOT  $$ cd $STORE\ROOT && $JAR -xf $WAR_FILE && Echo "Extracted War File Start Resin" 
    sleep 3 ; exec $RESIN_START

   echo "Application has been deployed and  Resin Instance Restarted"
   
   else
   echo "You Decided not to Deploy" 
   fi
   }

   #### Selection Happens Here ######
   
   case "$1" in
     --deploy)
         deploy;;
         *)
          echo $"Usage: $0 [--option]"
          echo " --deploy will deploy your war file with a backup file"
          exit 1
    esac
