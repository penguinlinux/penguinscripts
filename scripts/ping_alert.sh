#!/bin/bash -x
#  Ping Alert Monitor by Marco Maldonado V 1.0
#  Create a hosts file and save it somewhere on your server
#  specify a path and an email address where you want to send alerts
#
#  Note: Your hosts file should have the IP address of the host followed by a space and the name
#  of the server: Example Below
#
#  69.147.76.15  www.yahoo.com
#  209.85.165.147 wwww.scroogle.com
#

# Path to your hosts file

HOSTS="/scripts/hosts"

# Email address where to send alerts, you can add more addresses followed by a comma

EMAIL="thepenguin@fakesite.com,thepenguin@gmail.com"

### Do not edit anything below ############


for myHost in `cat $HOSTS | cut -d' ' -f1` ; do
     ping -c 4 $myHost > /dev/null
 if [ $? -ne 0 ] ; then
    serverip=`nslookup $myHost | grep Address | grep -v "#"`
    echo "Server `grep $myHost $HOSTS` with ip address $serverip is down reported down at `date`" | mail -s "Ping Alert Server `grep $myHost $HOSTS` might be down" $EMAIL
 fi ;
 done

