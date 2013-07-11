#!/bin/bash

echo "******************************************"
echo " Install Cow Say on Server and Show on Start"
echo " "
echo " Marco M Jan 15 2012"
echo "******************************************"


yum -y install cowsay  && yum -y install fortune-mod  # Install fortune and cowsay

cd /etc/ && curl -s http://penguincares.no-ip.org/jacksays.conf > /etc/jacksays.conf

curl -s http://penguincares.no-ip.org/cowsay.sh > /etc/cron.daily/cowsay.sh

chmod 755 /etc/cron.daily/cowsay.sh
