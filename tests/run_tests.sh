#!/bin/bash -xe

if [ ! -f id_rsa ];then
    ssh-keygen -f id_rsa -t rsa -N ""
fi

cp Dockerfile-Ubuntu Dockerfile
docker.io build -t ubuntu:14.04_ssh .

cp Dockerfile-Centos Dockerfile
docker.io build -t centos:6.4_ssh .

rm Dockerfile


C_UBUNTU=$(docker.io ps | awk '/ubuntu:14.04_ssh/ {print $1}')
C_CENTOS=$(docker.io ps | awk '/centos:6.4_ssh/ {print $1}')

# Start ubuntu, if it is not running
if [ -z $C_UBUNTU ];then
    C_UBUNTU=$(docker.io run -h puppet -diPt ubuntu:14.04_ssh)
fi

# start centos, if it is not running
if [ -z $C_CENTOS ];then
    C_CENTOS=$(docker.io run -h puppet -diPt centos:6.4_ssh)
fi

IP_UBUNTU=$(docker inspect ${C_UBUNTU} | awk '/IPAddress/ {print $2}' | sed 's/[^0-9.]//g')
IP_CENTOS=$(docker inspect ${C_CENTOS} | awk '/IPAddress/ {print $2}' | sed 's/[^0-9.]//g')

# Hosts file just for me
echo "[testservers]" > hosts.ini
echo "${IP_UBUNTU} ansible_ssh_user=root" >> hosts.ini
echo "${IP_CENTOS} ansible_ssh_user=root" >> hosts.ini

cd ..
ansible-playbook --private-key=tests/id_rsa -i tests/hosts.ini install.yaml
ansible-playbook --private-key=tests/id_rsa -i tests/hosts.ini install.yaml

RC=${?}

# Cleanup docker container on a succesful run.
if [[ $RC -eq 0 ]];then
    docker kill ${C_CENTOS}
    docker kill ${C_UBUNTU}
fi

exit ${RC}

