#!/bin/bash -xe
git clone https://github.com/hughsaunders/rally-jenkins
virtualenv .venv
source .venv/bin/activate
pip install ansible pyrax rackspace-novaclient
#wait
cd rally-jenkins
cp -r ~jenkins/jobscripts/* .
sed -i -e 's+ansible_python_interpreter=+ansible_python_interpreter='$VIRTUAL_ENV/bin/python'+' inventory-local/hosts
cat inventory-local/hosts
ansible-playbook bootstrap.yml -i inventory-local/ -e region=LON -e buildid="$BUILD_TAG" -e keypair=jenkins -vvvv --private-key=id_jenkins -t launch,deploy,rally
ansible-playbook bootstrap.yml -i inventory-local/ -e region=LON -e buildid="$BUILD_TAG" -e keypair=jenkins -vvvv --private-key=id_jenkins -t launch,destroy
