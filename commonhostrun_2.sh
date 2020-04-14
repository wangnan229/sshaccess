#!/bin/bash

FTP_HOST_IP=`sed '/FTP_HOST_IP=/p' -n commonhostrun_1.sh|sed 's/FTP_HOST_IP=//g'`
USERNAME=`sed '/USERNAME=/p' -n commonhostrun_1.sh|sed 's/USERNAME=//g'`
PASSWORD=`sed '/PASSWORD=/p' -n commonhostrun_1.sh|sed 's/PASSWORD=//g'`
FTP_HOST_DIR=`sed '/FTP_HOST_DIR=/p' -n commonhostrun_1.sh|sed 's/FTP_HOST_DIR=//g'`
FTP_PORT=`sed '/FTP_PORT=/p' -n commonhostrun_1.sh|sed 's/FTP_PORT=//g'`
LOCAL_DIR=$FTP_HOST_DIR

echo "Downloading id_rsa_***.pub from ftp host -->"

sh getallpubkey.sh -a $FTP_HOST_IP -u $USERNAME -p $PASSWORD -d $FTP_HOST_DIR -t $FTP_PORT -l $LOCAL_DIR  # >> /dev/null

touch /root/.ssh/authorized_keys

cd $LOCAL_DIR && ls |grep pub|xargs cat >> /root/.ssh/authorized_keys

echo "Merge to authorized_keys complete-->"

echo "commonhostrun_2 complete."

