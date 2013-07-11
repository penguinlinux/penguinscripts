#!/bin/bash

echo "type the hostname of the ssh server you want to copy keys to."

read servername 

echo "Type the username of this server"

read sshuser


ID="$HOME/.ssh/id_rsa"

if [ ! -e $ID ] ; then

    echo "creating rsa keys do not enter a password"
 
    ssh-keygen -t rsa

else

## Copy id to Server ###

    echo "Copying SSH Private Key To your Server $server"
    ssh-copy-id -i ~/.ssh/id_rsa.pub $sshuser@$servername
    echo "Done now log off and try to connect again to your sever using ssh $sshuser@servername"
fi
