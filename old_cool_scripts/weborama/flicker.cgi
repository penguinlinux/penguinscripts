#!/bin/sh
#echo "Content-type: text/html\n"
# Automated Flicker Script by Marco Maldonado

echo "Content-type: text/html"
echo ""
echo "<body bgcolor="black">"
echo "<font face="Verdana" color=white>"
echo "<center>"
   search=$( echo "$QUERY_STRING" | sed 's/p=//g' )
   picture=$( curl -g "http://www.flickr.com/services/feeds/photos_public.gne?tags="$search"&format=rss_200" -s | /usr/bin/fmt | grep src= | sed 's/&quot;//g' )
   count=$( echo "$picture" | wc -l)
   if [ $count -eq 1 ] ; then 
  echo "<img src="http://www.oakville.ca/StructureImages/404notfound.jpg"><br>"
  echo "There are no pictures that match your request. Please try another search" ;  fi 
  if [ $count -gt 1 ] ; then 
#   echo "<br>Pictures from Flicker.com<b><br><p>"
   echo "$picture" | /home/mongrel/chatbot/picturebuddy/webflicker.sh | /usr/local/bin/rl | head -n 30 ; fi
echo "<p>"
echo "<form method="get" action="/cgi-bin/weborama/flicker.cgi">"
echo "<b>Search Flicker:</b>"
echo "<input type="text" name="p">"
echo "<input type="submit" value="search flicker">"
echo "</form>"
echo "</center>"
