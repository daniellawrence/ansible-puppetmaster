#!/bin/bash -x

if [ ! -f id_rsa ];then
    ssh-keygen -f id_rsa -t rsa -N ""
fi

docker.io build -t ubuntu:14.04_ssh .
C=$(docker.io run -diPt ubuntu:14.04_ssh)
IP=$(docker inspect ${C} | awk '/IPAddress/ {print $2}' | sed 's/[^0-9.]//g')
echo "[testservers]" > hosts.ini
echo "${IP} ansible_ssh_user=root" >> hosts.ini

cd ..
ansible -i tests/hosts.ini -m setup --private-key=tests/id_rsa $IP |grep ansible_distribution_version
ansible-playbook --private-key=tests/id_rsa -i tests/hosts.ini install.yaml
ansible-playbook --private-key=tests/id_rsa -i tests/hosts.ini install.yaml

RC=${?}

# Cleanup docker container
docker kill ${C}
exit ${RC}

