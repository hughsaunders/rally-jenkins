#!/bin/bash -xe
source lib.sh
setup
setup_ansible
run_playbook launch,deploy,rally
run_playbook launch,destroy
