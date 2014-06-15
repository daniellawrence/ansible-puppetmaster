#!/bin/bash
ip a
if [ ! -f /etc/ssh/ssh_host_dsa_key ];then
ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ""
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""
fi
/usr/sbin/sshd -D
