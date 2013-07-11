#!/bin/bash -x
#
# Find and compress files runs monthly
#


DIR="/opt/sites/production"
DATE=`date +%B-%d-%Y`

## Search for files then compress them and blank the original file

for i in `find $DIR -name "*.log" -print` ; do gzip $i -c > $i.$DATE.gz ; cat /dev/null > $i ; echo "Compressed $i" ; done 

exit 0
