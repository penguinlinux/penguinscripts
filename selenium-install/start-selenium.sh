sudo /usr/bin/Xvfb :99 -ac -screen 0 1440x900x16 &

sleep 5 

echo "Starting fluxbox and VNC"
 
DISPLAY=:99 fluxbox & x11vnc  -ncache_cr -display :99 -bg -nopw -listen developer-machine.com -xkb

DISPLAY=:99 java -DfirefoxDefaultPaht=/usr/bin/firefox -jar /opt/selenium/selenium-server.jar -firefoxTemplate "/home/developer/.mozilla/"

