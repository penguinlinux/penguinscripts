#!/bin/bash

### virtual-django.sh  - Add a virtual host to the /home/developer/conf.d site. 

docroot="/home/developer/htdocs"
logroot="/home/developer/logs"

checkconfig="sudo apachectl configtest"
restart="sudo service httpd restart"

showonly=0
tempout="/tmp/addvirtual.$$"; trap "rm -rf $tempout $tempout.2" 0

if [ $# -eq  0 ]; then
   echo "django Virtual host creation by Marco Maldonado"
   echo "Usage:  ./$(basename $0)  www.sitename.com" >&2
   echo "where www.sitename.com is your website" >&2
   exit 1
fi
#### Check for common Errors 

if [ $( whoami ) = "root" ]; then
   echo "You can't run this as user root, Please run as user developer" >&2
   exit 0
fi

if [ "$(echo $@ | sed 's/ //g')" != "$1" ]; then
   echo "Sorry Dude! Domain names cannot have spaces" >&2
   exit 1 
fi
#### Build the directory structure for this domain ###

    echo "Creating Directory $doocroot/$1 "
    mkdir  "$docroot/$1"

   echo "Installing Virtual Env "
    cd $docroot/$1
     virtualenv --no-site-packages virtpy
     source  $docroot/$1/virtpy/bin/activate


### Install Django inside the virpy Directory ###

easy_install MySQL-python markdown html5lib  python-memcached Django

###  Create  Sample  Project  code ####
    django-admin.py startproject htdocs

#### Create the Mod_WSGI and Egg Cache ## Directory 

echo "Creating the mod_wsgi and Egg Cache Directory" 
      mkdir -p $docroot/$1/mod_wsgi/egg-cache

# now let's drop the necessary block into the httpd.conf file

cat << EOF > $tempout

####### Virtual Host setup for $1 ###########


<VirtualHost *:80>

    ServerName $1
    ErrorLog   "/home/developer/logs/developer-machine_error.log"
    CustomLog "/home/developer/logs/developer-machine_com_access.log" combined

  #  Alias /media/ /$docroot/$1/htdocs/media/

    <Directory /$docroot/$1/htdocs/media>
      Order deny,allow
      Allow from all
     </Directory>

     WSGIScriptAlias / /home/developer/htdocs/$1/mod_wsgi/django.wsgi

     <Directory /home/developer/htdocs/$1/htdocs/apache>
        Order deny,allow
        Allow from all
     </Directory>
</VirtualHost>


EOF

#### Copy new config file  and restart apache #####

     mv $tempout  $HOME/conf.d/"$1".conf


### Create the django.wsgi file ############

cat << EOF > $docroot/$1/mod_wsgi/django.wsgi

import os
import sys
sys.stdout = sys.stderr
# Add the virtual Python environment site-packages directory to the path
import site
site.addsitedir('$docroot/$1/virtpy/lib/python2.6/site-packages')


# Create your Egg Directory #######
import os
os.environ['PYTHON_EGG_CACHE'] = '$docroot/$1/mod_wsgi/egg-cache'

#If your project is not on your PYTHONPATH by default you can add the following
sys.path.append('$docroot/$1')
sys.path.append('$docroot/$1/htdocs')
os.environ['DJANGO_SETTINGS_MODULE'] = 'htdocs.settings'


import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()

EOF

### Restart Apache ###########

$checkconfig && $restart


### Send some information #####  

echo #We Are Done"
echo "Website http://$1 has been created"
echo "The path to your project is $docroot/$1"
echo "Edit your hosts file and add $1 to your hosts file"


