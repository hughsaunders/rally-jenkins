#!/bin/bash -xe
source lib.sh
setup
setup_ansible
run_playbook launch,resumedevstack,rally -e image=$(cat ~jenkins/jobscripts/devstack_image_id)
run_playbook launch,destroy
