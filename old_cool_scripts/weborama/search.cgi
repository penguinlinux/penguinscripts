#!/bin/sh
#
# Search Engine by Marco Maldonado

echo "Content-type: text/html"
echo ""
echo "<p>"
echo "<body bgcolor="white">"
echo "<font face="Verdana" color=black>"
echo "<form method="get" action="/cgi-bin/weborama/search.cgi">"
echo "<b>Search:</b>"
echo "<input type="text" name="p">"
echo "<input type="submit" value="search flicker">"
echo "</form>"
echo "</center>"


echo "<body bgcolor="White">"
echo "<font face="Verdana" color=Black>"
echo "<center>"
   search=$( echo "$QUERY_STRING" | sed 's/p=//g' )
    clean=`echo $search | sed 's/+/ /g'`
     echo "Google Hack Number $clean"
googlehack=`curl -s  "http://johnny.ihackstuff.com/ghdb.php?function=detail&id=$clean" | sed -n "/www.google.com/,/main_tcat_bl/p"`
   echo $googlehack
