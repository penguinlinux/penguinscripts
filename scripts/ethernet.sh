#!/bin/bash 
function ethget { 
   for ethernet  in $( ifconfig | cut -d' ' -f1 | grep -v ^$ ) ; do ping -I $ethernet -c 2 www.yahoo.com 
   if [ $? -eq 0 ] ; then
    echo "Ethernet $ethernet is your forward facing ethernet Adapter" ;
   else 
    echo "Ethernet $ethernet is NOT your forward facing ethernet Adapter" ;  
   fi
   done
   }
   ethget | grep Ethernet 
