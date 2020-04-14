#!/bin/bash

while getopts ":a:n:" opt
do
    case $opt in
        a)
        aa=${OPTARG}
        ;;
        n)
        nn=${OPTARG}
        ;;
        ?)
        echo "未知参数"
        exit 1;;
    esac
done
hostsip=(${aa//,/ })
hostsname=(${nn//,/ })
# echo "####${hostsip[*]}"
# makesh(): hostip & hostname added to processhosts.sh file.
makesh()
 {
  echo "cat << EOF >> $1" >> ./processhosts.sh
  hostnum=${#hostsip[*]}
  for((i=0;i<=$hostnum;i++));do  
    if [ $1 == "/etc/hosts" ];then 
      echo "${hostsip[i]} ${hostsname[i]}" >> ./processhosts.sh
    elif [ $1 == "/etc/hosts.allow" ];then
       if [ ${hostsip[i]} ];then
        echo "sshd:${hostsip[i]}" >> ./processhosts.sh
       fi
    fi
  done
  echo "EOF" >> ./processhosts.sh
  printf "\n" >> ./processhosts.sh
 }

touch ./processhosts.sh
echo "#!/bin/bash" > ./processhosts.sh
makesh "/etc/hosts"
makesh "/etc/hosts.allow"

