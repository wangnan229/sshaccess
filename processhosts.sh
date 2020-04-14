#!/bin/bash
cat << EOF >> /etc/hosts
192.168.176.200 ks-allinone
192.168.176.100 VMmaster
192.168.176.101 node1
 
EOF

cat << EOF >> /etc/hosts.allow
sshd:192.168.176.200
sshd:192.168.176.100
sshd:192.168.176.101
EOF

