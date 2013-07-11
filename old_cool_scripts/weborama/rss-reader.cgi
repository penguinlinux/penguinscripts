#!/bin/sh
#echo "Content-type: text/html\n"
# RSS Reader  Script by Marco Maldonado
base=/home/tepezcuintle/cgi-bin/weborama
echo "Content-type: text/html"
echo ""
echo "<body bgcolor="white">"
echo "<img src="http://penguincares.no-ip.org:9090/penguin/images/installation.gif">"
echo "<br><pre>"
       for  file in $( ls -all $base/feeds/ | tr -s ' ' | cut -d' ' -f9 )
       do
       rss=`xml sel --net -t -m "/rss/channel/item" -v "title" -o " | " -v "link" -n "$base/feeds/$file" | sed 's/\~/\%7E/g' | $base/url.sh`
       echo "<h1>$( echo $file | sed 's/.xml//g' )</h1>"
       echo "<font size="3" face="Verdana" color=black>"
       echo "$rss"
       done;
echo "</pre>"
echo "</body>"
