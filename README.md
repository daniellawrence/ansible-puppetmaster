Ansible-puppetmaster
------------------------

Install and configure puppetmaster via ansible!

Installing
------------

	$ git clone git@github.com:daniellawrence/ansible-puppetmaster.git
	$ mkvirtualenv ansible
	$ pip install ansible

Running
---------

Install a puppetmaster on a node called 'puppet' (change the hosts.ini)

	$ ansible-playbook -i hosts.ini install.yaml


Testing
---------

The tests assume that you habe ansible and docker install on your local machine.
by running `./tests/run_tests.sh` a new machine will be created and ansible will
take over and install the puppetmaster.

The `ubuntu:14.04` is also assumed to be installed locally.

Buildout
----------
serverspec will make sure that everything is install and configured as
it should be.
