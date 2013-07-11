#bin/bash

scp epel-release-5-4.noarch.rpm root@$1:/var/tmp
scp resolv.conf root@$1:/etc

ssh root@$1 "rpm -Uvh /var/tmp/epel-release-5-4.noarch.rpm ; yum -y install python26 python26-PyYAML python26-paramiko python26-jinja2 python-simplejson cowsay"

echo "You are done installing python dependencies" | cowsay
