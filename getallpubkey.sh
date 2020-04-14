#!/bin/bash

while getopts ":a:u:p:d:t:l:" opt
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
        l)
        LOCAL_DIR=${OPTARG}
        ;;
        ?)
        echo "未知参数"
        exit 1;;
    esac
done

mkdir -p $LOCAL_DIR
ftp -v -n $FTP_HOST_IP $FTP_PORT <<EOF
user $USERNAME $PASSWORD
cd $FTP_HOST_DIR
lcd $LOCAL_DIR
prompt
mget *.pub
ls
close
bye
EOF
