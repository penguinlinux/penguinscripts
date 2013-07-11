#!/bin/sh
#echo "Content-type: text/html\n"
# Automated Flicker Script by Marco Maldonado

echo "Content-type: text/html"
echo ""
echo "<body bgcolor="black">"
echo "<font face="Verdana" color=white>"
echo "<p>"                          
echo "Recent logins since February 1st 2008 to April 8th 2008"
echo "<form method="get" action="/cgi-bin/some_random_penguin.cgi">"
echo "<b>Search Users:</b>"
echo "<input type="text" name="p">"
echo "<input type="submit" value="search">"
echo "</form>"


### Query string ####
   search=$( echo "$QUERY_STRING" | sed 's/p=//g' )


RESULTS=$( /bin/grep -i "$search" /home/tepezcuintle/cgi-bin/addresses.txt )

for i in $( echo "$RESULTS" ) ; do
     echo "$i" ;
     done
