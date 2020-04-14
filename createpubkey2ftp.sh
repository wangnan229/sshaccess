#!/bin/bash

while getopts ":a:u:p:d:t:" opt
do
    case $opt in
        a)
        FTP_HOST_IP=${OPTARG}
        ;;
        u)
        USERNAME=${OPTARG}
        ;;
        p)
        PASSWORD=${OPTARG}
        ;;
        d)
        FTP_HOST_DIR=${OPTARG}
        ;;
        t)
        FTP_PORT=${OPTARG}
        ;;
        ?)
        echo "未知参数"
        exit 1;;
    esac
done

mkdir -p $FTP_HOST_DIR
LOCAL_HOSTNAME=`hostname`
mkdir -p /root/.ssh
sshfiles=`ls /root/.ssh`

if [ ${#sshfiles[*]} -gt 0 ]
then 
  echo "id_rsa.pub already exists,recreating..." 
  cd /root/.ssh &&  echo "y"|ssh-keygen -t rsa -N '' -f id_rsa -q
else
  cd /root/.ssh && ssh-keygen -t rsa -N '' -f id_rsa -q
fi
printf "\n"

ftpstatus=`yum list installed ftp|grep Installed`

if [ "$ftpstatus" != "Installed Packages" ]
 then
  echo "ftp not found,ready to install-->"
  yum install -y ftp >> /dev/null
  echo "ftp installed complete-->"
else
  echo "ftp found,continue-->"
fi

ftp -v -n $FTP_HOST_IP $FTP_PORT <<EOF
user $USERNAME $PASSWORD
cd $FTP_HOST_DIR
lcd /root/.ssh
put id_rsa.pub "id_rsa_$LOCAL_HOSTNAME.pub"
ls
close
bye
EOF


