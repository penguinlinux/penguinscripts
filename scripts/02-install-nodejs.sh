#!/bin/bash

echo "******************************************"
echo "Configure Centos box with Node JS"
echo " "
echo " Marco M Jan 12 2012"
echo "******************************************"

echo " - Get souce from nodejs "

cd /usr/local/src

wget http://nodejs.org/dist/v0.6.7/node-v0.6.7.tar.gz

tar xvfz node-v0.6.7.tar.gz

echo "Compile NodeJS Source Code"

cd node-v0.6.7

configure && make && make install

echo "NodeJs has been Installed"

