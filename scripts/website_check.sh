#!/bin/bash -x
SITES="/scripts/websites" 
     for i in `cat $SITES` ; do       
         links --dump  http://$i  
      if [ $? -ne 0 ] ; then
      echo "Site http://$i appears to be down" | mail -s "Website Alert for http://$i on `date`" "thepenguin@fakesite.com,thepenguin@gmail.com"
      fi ; 
      done
