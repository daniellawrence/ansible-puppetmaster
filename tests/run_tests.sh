#!/bin/bash -xe

if [ ! -f id_rsa ];then
    ssh-keygen -f id_rsa -t rsa -N ""
fi

cp Dockerfile-Ubuntu Dockerfile
docker.io build -t ubuntu:14.04_ssh .

cp Dockerfile-Centos Dockerfile
docker.io build -t centos:6.4_ssh .

rm Dockerfile

C_UBUNTU=$(docker.io run -diPt ubuntu:14.04_ssh)
C_CENTOS=$(docker.io run -diPt centos:6.4_ssh)
IP_UBUNTU=$(docker inspect ${C_UBUNTU} | awk '/IPAddress/ {print $2}' | sed 's/[^0-9.]//g')
IP_CENTOS=$(docker inspect ${C_CENTOS} | awk '/IPAddress/ {print $2}' | sed 's/[^0-9.]//g')
echo "[testservers]" > hosts.ini
echo "${IP_UBUNTU} ansible_ssh_user=root" >> hosts.ini
echo "${IP_CENTOS} ansible_ssh_user=root" >> hosts.ini

cd ..
ansible -i tests/hosts.ini -m setup --private-key=tests/id_rsa $IP_UBUNTU |grep ansible_distribution_version
ansible -i tests/hosts.ini -m setup --private-key=tests/id_rsa $IP_CENTOS |grep ansible_distribution_version
ansible-playbook --private-key=tests/id_rsa -i tests/hosts.ini install.yaml
ansible-playbook --private-key=tests/id_rsa -i tests/hosts.ini install.yaml

RC=${?}

# Cleanup docker container
docker kill ${C_CENTOS}
docker kill ${C_UBUNTU}
exit ${RC}

