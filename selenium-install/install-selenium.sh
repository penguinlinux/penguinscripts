#!/bin/bash
#
#  Install Script to install Selenium.  Run 
#  sudo ./install-selenium.sh
#
#

mkdir /opt/selenium

cd  /opt/selenium

wget http://selenium.googlecode.com/files/selenium-server-standalone-2.19.0.jar

ln -s /opt/selenium/selenium-server-standalone-2.19.0.jar /opt/selenium/selenium-server.jar

yum install -y xorg-x11-server-Xvfb.i686 mesa-dri-drivers.i686 xorg-x11-fonts-100dpi.noarch xorg-x11-fonts-75dpi.noarch xorg-x11-fonts-cyrillic.noarch fluxbox x11vnc.i686 xterm.i686 firefox java-1.6.0-openjdk.i686 dbus-x11 bluefish

echo "Finished Installing all Selenium Components"
echo "Now edit your hosts file on this machine and add your IP address to /etc/hosts"
echo "Make and entry like"
echo "10.2.1.32 developer-machine.com"
echo "Make sure you use your local IP address"
echo "Then on the same line add the local website you want to test"
echo "example"
echo "10.2.1.32 developer-machine.com otsuka-webapp.dev dm2.com"  
echo "This way selenium will know how to access the correct site"

