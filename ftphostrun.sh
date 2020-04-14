#!/bin/bash

HOSTIP=`sed '/HOSTIP=/p' -n commonhostrun_1.sh|sed 's/HOSTIP=//g'`
HOSTNAME=`sed '/HOSTNAME=/p' -n commonhostrun_1.sh|sed 's/HOSTNAME=//g'`
FTP_HOST_IP=`sed '/FTP_HOST_IP=/p' -n commonhostrun_1.sh|sed 's/FTP_HOST_IP=//g'`
USERNAME=`sed '/USERNAME=/p' -n commonhostrun_1.sh|sed 's/USERNAME=//g'`
PASSWORD=`sed '/PASSWORD=/p' -n commonhostrun_1.sh|sed 's/PASSWORD=//g'`
FTP_HOST_DIR=`sed '/FTP_HOST_DIR=/p' -n commonhostrun_1.sh|sed 's/FTP_HOST_DIR=//g'`
FTP_PORT=`sed '/FTP_PORT=/p' -n commonhostrun_1.sh|sed 's/FTP_PORT=//g'`
LOCAL_DIR=$FTP_HOST_DIR

if [ "$FTP_PORT" == "" ];then   # attention: "$FTP_PORT"
 FTP_PORT=21
fi

dir=`pwd`
sh makeprocesshosts.sh -a $HOSTIP  -n $HOSTNAME

sh processhosts.sh

echo "creating id_rsa_***.pub and transfer to ftp host -->"

sh createpubkey2ftp.sh -a $FTP_HOST_IP -u $USERNAME -p $PASSWORD -d $FTP_HOST_DIR -t $FTP_PORT # >> /dev/null

echo "modifying /etc/ssh/ssh_config: StrictHostKeyChecking  ask >>> StrictHostKeyChecking  no"
sed  '$a StrictHostKeyChecking no' -i /etc/ssh/ssh_config

echo "restarting sshd -->"

sh -c "systemctl restart sshd"

touch /root/.ssh/authorized_keys

cd $LOCAL_DIR && ls |grep pub|xargs cat >> /root/.ssh/authorized_keys

echo "Merge to authorized_keys OK."

