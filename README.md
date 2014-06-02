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
