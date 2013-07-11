#!/bin/sh
#
# Cow Report by Marco Maldonado

echo "Content-type: text/html"
echo ""
echo "<body bgcolor="black">"
echo "<font face="Verdana" color=white>"
echo "<p>"
vaca=$( /usr/games/fortune | /usr/local/bin/cowsay -f $(perl -le 'opendir COWS, "/usr/local/share/cows/";push @a, $_ foreach readdir COWS;closedir COWS;$a[int rand $#a]=~/(.*)\.cow/;print $1') )
echo "<pre>"
echo "$vaca"
echo "<br>"
echo "<br>"
echo "</pre>"

