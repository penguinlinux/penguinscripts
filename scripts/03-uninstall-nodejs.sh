#!/bin/bash

SOURCE=/usr/local/src/node*

cd $SOURCE && make uninstall

echo "Node JS Has Been Removed" 
echo "Report found on $SOURCE/report.log"
