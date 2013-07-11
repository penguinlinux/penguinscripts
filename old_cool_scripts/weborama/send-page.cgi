#!/bin/sh
#
# Send Page by Marco Maldonado

echo "Content-type: text/html"
echo ""
echo "<p>"
echo "<body bgcolor="white">"
echo "<font face="Verdana" color=black>"
echo "<form method="get" action="/cgi-bin/weborama/send-page.cgi">"
echo "<b>Send</b>"
echo "<input type="text" name="p">"
echo "<input type="submit" value="search flicker">"
echo "</form>"
echo "</center>"


echo "<body bgcolor="White">"
echo "<font face="Verdana" color=Black>"
echo "<center>"
   search=$( echo "$QUERY_STRING" | sed 's/p=//g' )
    clean=`echo $search | sed 's/+/ /g'`

emailme()
{ ### function that sends the page
 url="$clean"
to="marco.maldonado@the451group.com"

( cat << EOF
Subject: Marco Sent you this page
From: Marco Maldonado  <halthepenguin@halthepenguin.com>
Content-type: text/html
To: $to

<html>
<body border=0 leftmargin=0 topmargin=0>
<div style='background-color:309;color:fC6;font-size:45pt;
 font-style:sans-serif;font-weight:900;text-align:center;
margin:0;padding:3px;'>
THE STRAIGHT DOPE</div>

<div style='padding:3px;line-height:1.1'>
EOF

  lynx -source "http://www.the451group.com" 
  echo "</div></body></html>"
) | /usr/sbin/sendmail -t

exit 0
}
   emailme
