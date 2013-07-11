host=www.visual-a.com
for port in  80 21 25 53 443 143 110
do
  if netcat -z  -w 2 $host $port
  then
    echo port $port is up
  else
    echo port $port is down |  mail -s "the following port $port is down on $host" mmaldonado@visual-a.com
  fi
done
