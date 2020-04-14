#!/bin/bash

HOSTIP=192.168.176.200,192.168.176.100,192.168.176.101
HOSTNAME=ks-allinone,VMmaster,node1
FTP_HOST_IP=192.168.176.200
USERNAME=ftpuser
PASSWORD=0000
FTP_HOST_DIR=/home/ftpuser/pubkey
FTP_PORT=21
LOCAL_DIR=$FTP_HOST_DIR


dir=`pwd`
sh makeprocesshosts.sh -a $HOSTIP  -n $HOSTNAME

sh processhosts.sh

echo "restarting sshd -->"

sh -c "systemctl restart sshd"

echo "creating id_rsa_***.pub and transfer to ftp host -->"

sh createpubkey2ftp.sh -a $FTP_HOST_IP -u $USERNAME -p $PASSWORD -d $FTP_HOST_DIR -t $FTP_PORT # >> /dev/null

echo "modifying /etc/ssh/ssh_config: StrictHostKeyChecking  ask >>> StrictHostKeyChecking  no"

sed  '$a StrictHostKeyChecking no' -i /etc/ssh/ssh_config

echo "commonhostrun_1 complete."

