#!/bin/bash 


function load {

server_hosts="ctlsdev.com production.fakesite.com beta.fakesite.com uk.production.fakesite.com www.fakesite.com.com"


for server in $server_hosts ; do printf "\r$server " ; ssh webgroup@$server  "cat /proc/loadavg" | awk '{ print $2 }'  ; done

}
  
function httpcon {

server_hosts="ctlsdev.com production.fakesite.com beta.fakesite.com uk.production.fakesite.com www.fakesite.com.com"

#

for server in $server_hosts ; do printf "\r$server " ; ssh webgroup@$server "ps -A" | grep httpd | wc -l  ; done

}

function memory { 

server_hosts="ctlsdev.com production.fakesite.com beta.fakesite.com uk.production.fakesite.com www.fakesite.com.com"

#

for server in $server_hosts ; do echo "$server" ; ssh webgroup@$server "free -m" | tr -s ' ' | grep Mem  ; done

}


echo "
<html><head>
<title>SERVER REPORT</title>
<style>
        body { background-color: #153E7E; text-align: center;}
        a { color: white; }
        body, div { font-size: 15pt; }

</style>
</head>
<body >
<div id=\"container\">
<font face=\"Verdana\" color=white>
"
echo "<center><img src=\"tux_small.gif\"></center>"
echo "<br>`date`</br>"
echo "Server Load Last 5 Minutes"      
echo "<pre>`load`</pre>"
echo "<br>"
echo "HTTP Sessions in last 5 minutes"
echo  "<pre>`httpcon`</pre>"
echo "<br>"
echo "Memory Total Used Free"
echo "<pre>`memory`</pre>"
echo "</html>"
